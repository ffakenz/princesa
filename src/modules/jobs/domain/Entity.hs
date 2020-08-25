{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Modules.Jobs.Domain.Entity where

import GHC.Generics

newtype JobId = JobId
  { getJobId :: Int
  }
  deriving (Show, Enum, Num, Generic)

data Job = Job
  { jobId :: JobId,
    jobDescription :: String
  }
  deriving (Show, Generic)

newtype JobError = JobError
  { errorMessage :: String
  }
  deriving (Show)

type JobResponse a = Either JobError a