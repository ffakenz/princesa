{-# LANGUAGE OverloadedStrings #-}

module Infrastructure.Config where

import Control.Monad.Logger (runNoLoggingT, runStdoutLoggingT)
import qualified Data.ByteString.Char8 as BS
import Database.Persist.Postgresql (ConnectionPool, ConnectionString, createPostgresqlPool)
import Katip (LogEnv, defaultScribeSettings, initLogEnv, registerScribe)
import Network.Wai (Middleware)
import Network.Wai.Handler.Warp (Port)
import Network.Wai.Middleware.RequestLogger (logStdout, logStdoutDev)

-- | The Config for our application is (for now) the 'Environment' we're
-- running in and a Persistent 'ConnectionPool'.
data Config = Config
  { configPool :: ConnectionPool,
    configEnv :: Environment,
    configPort :: Port,
    configLogEnv :: LogEnv
  }

-- | Right now, we're distinguishing between three environments. We could
-- also add a @Staging@ environment if we needed to.
data Environment
  = Development
  | Test
  | Production
  deriving (Eq, Show, Read)

defaultConfig :: LogEnv -> ConnectionPool -> Config
defaultConfig logEnv pool =
  Config
    { configPool = pool,
      configEnv = Development,
      configPort = 8081,
      configLogEnv = logEnv
    }

-- | This returns a 'Middleware' based on the environment that we're in.
setLogger :: Environment -> Middleware
setLogger Test = id
setLogger Development = logStdoutDev
setLogger Production = logStdout

makePool :: Environment -> LogEnv -> IO ConnectionPool
makePool Test _ =
  runNoLoggingT $ createPostgresqlPool (connStr "") (envPool Test)
makePool Development _ =
  runStdoutLoggingT $ createPostgresqlPool (connStr "") (envPool Development)
makePool e _ =
  runStdoutLoggingT $ createPostgresqlPool (connStr "") (envPool e)

-- | The number of pools to use for a given environment.
envPool :: Environment -> Int
envPool Test = 1
envPool Development = 1
envPool Production = 8

-- | A basic 'ConnectionString' for local/test development. Pass in either
-- @""@ for 'Development' or @"test"@ for 'Test'.
connStr :: BS.ByteString -> ConnectionString
connStr sfx =
  "host=localhost dbname=princesa"
    <> sfx
    <> " user=princesa password=princesa port=5432"
