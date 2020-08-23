module Modules.Jobs.Domain where

newtype JobId = JobId
  { getJobId :: Int
  }
  deriving (Show)

data Job = Job
  { jobId :: JobId,
    jobDescription :: String
  }
  deriving (Show)

newtype JobError = JobError
  { errorMessage :: String
  }
  deriving (Show)

type JobResponse a = Either JobError a