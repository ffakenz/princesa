{-# LANGUAGE OverloadedStrings #-}

module Modules.Jobs.Infrastructure.Persistence.Db where

import Control.Monad.Logger (logDebugNS)
import Control.Monad.Reader (MonadIO, liftIO)
import Data.Text (pack)
import Database.Persist.Postgresql
  ( Entity (..),
    fromSqlKey,
    insert,
    selectFirst,
    selectList,
    (==.),
  )
import Infrastructure.Config (Config)
import Infrastructure.Logger
import Infrastructure.Persistence.DBRuntime (runDb)
import Infrastructure.Types (AppT)
import Modules.Jobs.Domain.Entity
import Modules.Jobs.Domain.Repository
import Modules.Jobs.Infrastructure.Persistence.Models
  ( EntityField (JobTKey),
    jobToJobT,
    jobtToJob,
  )

instance MonadIO m => JobRepository (AppT m) where
  find jobId = do
    logDebugNS "web" (pack $ ("finding a job " <> show jobId))
    jobResult <- runDb (selectFirst [JobTKey ==. (getJobId jobId)] [])
    let maybeJob = (\(Entity _ c) -> jobtToJob c) <$> jobResult
    return maybeJob
  create job = do
    logDebugNS "web" (pack $ ("creating a job " <> show job))
    newJob <- runDb (insert $ jobToJobT $ job)
    let logMsg = pack $ ("job created " <> show newJob <> " with key " <> (show $ fromSqlKey newJob))
    logDebugNS "web" logMsg
    return ()
  searchAll = do
    logDebugNS "web" "searchAll"
    jobsResult <- runDb $(selectList [] [])
    let jobs = map (\(Entity _ c) -> jobtToJob c) jobsResult
    return jobs