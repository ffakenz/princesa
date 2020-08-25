{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module Modules.Jobs.Infrastructure.Http.Api where

import Control.Monad.Logger (logDebugNS)
import Control.Monad.Reader (MonadIO)
import Infrastructure.Logger
import Infrastructure.Types
import Modules.Jobs.Domain.Entity
import qualified Modules.Jobs.Domain.Service as Jobs
import Modules.Jobs.Infrastructure.Persistence.Db
import Servant

type JobAPI =
  "jobs" :> Get '[JSON] [Job]
    :<|> "jobs" :> ReqBody '[JSON] Job :> Post '[JSON] ()
    :<|> "jobs" :> Capture "jobId" Int :> Get '[JSON] (Maybe Job)

jobApi :: Proxy JobAPI
jobApi = Proxy

-- | The server that runs the JobAPI
jobServer :: MonadIO m => ServerT JobAPI (AppT m)
jobServer = allJobs :<|> createJob :<|> findJob

-- | Returns a job in the database.
findJob :: MonadIO m => Int -> AppT m (Maybe Job)
findJob jobId = do
  findJobR <- Jobs.findJob (JobId jobId)
  let result = case findJobR of
        (Right maybeJob) -> maybeJob
        (Left error) -> Nothing -- @TODO
  return result

-- | Returns all jobs in the database.
allJobs :: MonadIO m => AppT m [Job]
allJobs = do
  searchAllJobsR <- Jobs.searchAllJobs
  let result = case searchAllJobsR of
        (Right jobs) -> jobs
        (Left error) -> [] -- @TODO
  return result

-- | Create a job in the database.
createJob :: MonadIO m => Job -> AppT m ()
createJob job = do
  createJobR <- Jobs.createJob job
  let result = case createJobR of
        (Right _) -> ()
        (Left error) -> () -- @TODO
  return result