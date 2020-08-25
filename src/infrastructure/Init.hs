{-# LANGUAGE OverloadedStrings #-}

module Infrastructure.Init where

import Control.Concurrent (killThread)
import Control.Exception (bracket)
import Database.Persist.Postgresql (ConnectionPool, runSqlPool)
import Infrastructure.Config
  ( Config (..),
    Environment (..),
    makePool,
    setLogger,
  )
import Infrastructure.Http.Api (app)
import Infrastructure.Logger (defaultLogEnv)
import qualified Katip
import qualified Modules.Candidates.Infrastructure.Persistence.Models as CandidatesMigration
import qualified Modules.Jobs.Infrastructure.Persistence.Models as JobsMigration
import Network.Wai (Application)
import Network.Wai.Handler.Warp (run)
import Safe (readMay)
import System.Environment (lookupEnv)

-- | An action that creates a WAI 'Application' together with its resources,
--   runs it, and tears it down on exit
runApp :: IO ()
runApp = bracket acquireConfig shutdownApp runApp
  where
    runApp config = run (configPort config) =<< initialize config

-- | The 'initialize' function accepts the required environment information,
-- initializes the WAI 'Application' and returns it
initialize :: Config -> IO Application
initialize cfg = do
  let logger = setLogger (configEnv cfg)
  executeMigration (configPool cfg)
  pure . logger . app $ cfg

executeMigration :: ConnectionPool -> IO ()
executeMigration pool = do
  runSqlPool CandidatesMigration.doMigrations pool
  runSqlPool JobsMigration.doMigrations pool

-- | Allocates resources for 'Config'
acquireConfig :: IO Config
acquireConfig = do
  port <- lookupSetting "PORT" 8081
  env <- lookupSetting "ENV" Development
  logEnv <- defaultLogEnv
  pool <- makePool env logEnv
  pure
    Config
      { configPool = pool,
        configEnv = env,
        configPort = port,
        configLogEnv = logEnv
      }

-- | Takes care of cleaning up 'Config' resources
shutdownApp :: Config -> IO ()
shutdownApp cfg = do
  Katip.closeScribes (configLogEnv cfg)
  pure ()

-- | Looks up a setting in the environment, with a provided default, and
-- 'read's that information into the inferred type.
lookupSetting :: Read a => String -> a -> IO a
lookupSetting env def = do
  maybeValue <- lookupEnv env
  case maybeValue of
    Nothing ->
      return def
    Just str ->
      maybe (handleFailedRead str) return (readMay str)
  where
    handleFailedRead str =
      error $
        mconcat
          [ "Failed to read [[",
            str,
            "]] for environment variable ",
            env
          ]
