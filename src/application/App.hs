module Application.App where

import Application.Provider
import Control.Concurrent (killThread)
import Control.Exception (bracket)
import Database.Persist.Postgresql (ConnectionPool, runSqlPool)
import Infrastructure.Config
  ( Config (..),
    connStr,
  )
import Infrastructure.Environment
import Infrastructure.Http.Api (app)
import qualified Modules.Candidates.Infrastructure.Persistence.Models as CandidatesMigration
import qualified Modules.Jobs.Infrastructure.Persistence.Models as JobsMigration
import Network.Wai (Application)
import Network.Wai.Handler.Warp (run)

-- | An action that creates a WAI 'Application' together with its resources,
--   runs it, and tears it down on exit
runApp :: IO ()
runApp = bracket acquireConfig runApp shutdownApp
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
