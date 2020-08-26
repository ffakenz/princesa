module Application.Cli where

import Infrastructure.Environment (Environment (..))
import Infrastructure.System (lookupSetting)

runApp :: IO ()
runApp = do
  cnf <- fetchConfig
  print "wip"

data CliConfig = CliConfig
  { configEnv :: Environment
  }
  deriving (Show)

fetchConfig :: IO CliConfig
fetchConfig = do
  env <- lookupSetting "ENV" Development
  pure
    CliConfig
      { configEnv = env
      }
