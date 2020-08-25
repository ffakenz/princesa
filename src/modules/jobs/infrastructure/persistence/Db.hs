module Modules.Jobs.Infrastructure.Persistence.Db where

import Data.Aeson
import Modules.Jobs.Domain.Entity
import Modules.Jobs.Domain.Repository

-- Json Marshaller
instance ToJSON JobId

instance ToJSON Job

-- DB Repository
instance JobRepository IO where
  find jobId =
    if (getJobId jobId `mod` 2) == 0
      then pure Nothing
      else pure $ Just (Job jobId "a job")
  create job = print $ "inside repo: " <> show job
  searchAll =
    let jobIds = [JobId id | id <- [1 .. 5]]
     in pure $
          [ (Job jobId "a job")
            | jobId <- jobIds
          ]