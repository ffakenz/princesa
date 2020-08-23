module Infrastructure.Candidates where

import Modules.Candidates.Domain
import Modules.Candidates.Infrastructure

instance CandidateRepository IO where
  find candidateId =
    if (getCandidateId candidateId `mod` 2) == 0
      then pure Nothing
      else pure $ Just (Candidate candidateId "a candidate")
  create candidate = print $ "inside repo: " <> show candidate
