module Application.Provider where

import Infrastructure.Config
import Infrastructure.Environment (Environment (..))
import Infrastructure.Logger (defaultLogEnv)
import Infrastructure.Persistence.PoolProvider (makePool)
import Infrastructure.System (lookupSetting)
import Katip

-- | Allocates resources for 'Config'
acquireConfig :: IO Config
acquireConfig = do
  port <- lookupSetting "PORT" 8081
  env <- lookupSetting "ENV" Production
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