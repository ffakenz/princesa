module Modules.Jobs.Infrastructure.Http.Handler where

import Control.Monad.Logger (logDebugNS)
import Control.Monad.Reader (MonadIO)
import Infrastructure.Logger
import Infrastructure.Types
import Modules.Jobs.Domain.Entity
import qualified Modules.Jobs.Domain.Service as Jobs
import Modules.Jobs.Infrastructure.Persistence.Db

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