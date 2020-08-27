module Application.Cli where

import Application.Provider
import Control.Exception (bracket)
import Control.Monad.Except (ExceptT (..), runExceptT)
import Control.Monad.Reader (ReaderT (..), runReaderT)
import Database.Persist.Postgresql (ConnectionPool, runSqlPool)
import Infrastructure.Config (Config (..), connStr)
import Infrastructure.Environment (Environment (..), setLogger)
import Infrastructure.Logger (defaultLogEnv)
import Infrastructure.Persistence.PoolProvider (makePool)
import Infrastructure.System (lookupSetting)
import Infrastructure.Types (CliT (..))
import qualified Modules.Candidates.Infrastructure.Persistence.Models as CandidatesMigration
import qualified Modules.Jobs.Domain.Service as Jobs
import qualified Modules.Jobs.Infrastructure.Persistence.Models as JobsMigration

runApp :: IO ()
runApp = bracket fetchConfig runApp' shutdownApp

runApp' :: Config -> IO ()
runApp' cnf = do
  print . show $ cnf
  initialize $ cnf
  run cnf cli

fetchConfig :: IO Config
fetchConfig = do
  logEnv <- defaultLogEnv
  let env = Development
  pool <- makePool env logEnv connStr
  pure
    Config
      { configPool = pool,
        configEnv = env,
        configPort = 0,
        configLogEnv = logEnv
      }

-- | The 'initialize' function accepts the required environment information,
-- initializes the WAI 'Application' and returns it
-- initialize :: Config -> CliT IO
initialize :: Config -> IO ()
initialize cfg = do
  executeMigration (configPool cfg)

executeMigration :: ConnectionPool -> IO ()
executeMigration pool = do
  runSqlPool CandidatesMigration.doMigrations pool
  runSqlPool JobsMigration.doMigrations pool

run :: Config -> CliT IO () -> IO ()
run cfg cli = do
  result <- runExceptT $ (runReaderT (runCli cli) cfg)
  case result of
    (Right _) -> print "wip" -- get line and loop
    (Left error) -> print error

cli :: CliT IO ()
cli = CliT {runCli = ReaderT runCli'}
  where
    runCli' config = ExceptT $ process'
    process' = pure (Right ())
