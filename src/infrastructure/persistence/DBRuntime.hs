{-# LANGUAGE FlexibleContexts #-}

module Infrastructure.Persistence.DBRuntime where

import Control.Monad.Reader (MonadIO, MonadReader, asks, liftIO)
import Database.Persist.Sql (SqlPersistT, runSqlPool)
import Infrastructure.Config (Config, configPool)

runDb :: (MonadReader Config m, MonadIO m) => SqlPersistT IO b -> m b
runDb query = do
  pool <- asks configPool
  liftIO $ runSqlPool query pool