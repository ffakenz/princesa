{-# LANGUAGE OverloadedStrings #-}

module Infrastructure.Persistence.PoolProvider where

import Control.Monad.Logger (runNoLoggingT, runStdoutLoggingT)
import qualified Data.ByteString.Char8 as BS
import Database.Persist.Postgresql (ConnectionPool, ConnectionString, createPostgresqlPool, runSqlPool)
import Infrastructure.Config (connStr, defaultConfig)
import Infrastructure.Environment (Environment (..), envPool)
import Katip (LogEnv)

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