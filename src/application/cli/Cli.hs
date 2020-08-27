module Application.Cli.Cli where

import Application.Cli.CliT
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
import qualified Modules.Candidates.Infrastructure.Persistence.Models as CandidatesMigration
import qualified Modules.Jobs.Domain.Service as Jobs
import qualified Modules.Jobs.Infrastructure.Persistence.Models as JobsMigration

runApp :: IO ()
runApp = bracket fetchConfig runApp' shutdownApp

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

runApp' :: Config -> IO ()
runApp' cnf = do
  print . show $ cnf
  initialize $ cnf
  run cnf program

-- | The 'initialize' function accepts the required environment information,
-- initializes the 'Application' and returns it
-- initialize :: Config -> CliT IO
initialize :: Config -> IO ()
initialize cfg = do
  executeMigration (configPool cfg)
  where
    executeMigration :: ConnectionPool -> IO ()
    executeMigration pool = do
      runSqlPool CandidatesMigration.doMigrations pool
      runSqlPool JobsMigration.doMigrations pool

run :: Config -> CliT IO () -> IO ()
run cfg program = do
  let programInput = undefined
  result <- runExceptT $ (runReaderT (runCli program) (cfg, programInput))
  case result of
    (Right _) -> print "continue looping" -- run cfg program
    (Left error) -> print error

program :: CliT IO ()
program = CliT {runCli = ReaderT runCli'}
  where
    runCli' :: (Config, ProgramInput) -> (ExceptT CliError IO) ()
    runCli' (config, programInput) = ExceptT $ process' config programInput
    process' :: Config -> ProgramInput -> IO (Either CliError ())
    process' config programInput = sequence $ Right $ print "wip"