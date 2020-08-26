{-# LANGUAGE OverloadedStrings #-}

module Application.App where

import Control.Concurrent (killThread)
import Control.Exception (bracket)
import Control.Monad.Logger (runNoLoggingT, runStdoutLoggingT)
import qualified Data.ByteString.Char8 as BS
import Database.Persist.Postgresql (ConnectionPool, ConnectionString, createPostgresqlPool, runSqlPool)
import Infrastructure.Config
  ( Config (..),
    connStr,
  )
import Infrastructure.Environment
import Infrastructure.Http.Api (app)
import Infrastructure.Logger (defaultLogEnv)
import Infrastructure.System (lookupSetting)
import Katip (LogEnv, defaultScribeSettings, initLogEnv, registerScribe)
import qualified Katip
import qualified Modules.Candidates.Infrastructure.Persistence.Models as CandidatesMigration
import qualified Modules.Jobs.Infrastructure.Persistence.Models as JobsMigration
import Network.Wai (Application)
import Network.Wai.Handler.Warp (run)
import Network.Wai.Middleware.RequestLogger (logStdout, logStdoutDev)

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
  pool <- makePool env logEnv connStr
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

makePool ::
  Environment ->
  LogEnv ->
  (BS.ByteString -> ConnectionString) ->
  IO ConnectionPool
makePool Test _ connStr =
  runNoLoggingT $ createPostgresqlPool (connStr "") (envPool Test)
makePool Development _ connStr =
  runStdoutLoggingT $ createPostgresqlPool (connStr "") (envPool Development)
makePool e _ connStr =
  runStdoutLoggingT $ createPostgresqlPool (connStr "") (envPool e)
