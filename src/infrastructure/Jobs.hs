module Infrastructure.Jobs where

import Modules.Jobs.Domain
import Modules.Jobs.Infrastructure

instance JobRepository IO where
  find jobId =
    if (getJobId jobId `mod` 2) == 0
      then pure Nothing
      else pure $ Just (Job jobId "a job")
  create job = print $ "inside repo: " <> show job