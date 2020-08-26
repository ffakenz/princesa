{-# LANGUAGE OverloadedStrings #-}

module Infrastructure.Config where

import qualified Data.ByteString.Char8 as BS
import Database.Persist.Postgresql (ConnectionPool, ConnectionString)
import Infrastructure.Environment
import Katip (LogEnv)
import Network.Wai.Handler.Warp (Port)

-- | The Config for our application is (for now) the 'Environment' we're
-- running in and a Persistent 'ConnectionPool'.
data Config = Config
  { configPool :: ConnectionPool,
    configEnv :: Environment,
    configPort :: Port,
    configLogEnv :: LogEnv
  }

defaultConfig :: LogEnv -> ConnectionPool -> Config
defaultConfig logEnv pool =
  Config
    { configPool = pool,
      configEnv = Development,
      configPort = 8081,
      configLogEnv = logEnv
    }

-- | A basic 'ConnectionString' for local/test development. Pass in either
-- @""@ for 'Development' or @"test"@ for 'Test'.
connStr :: BS.ByteString -> ConnectionString
connStr sfx =
  "host=localhost dbname=princesa"
    <> sfx
    <> " user=princesa password=princesa port=5432"
