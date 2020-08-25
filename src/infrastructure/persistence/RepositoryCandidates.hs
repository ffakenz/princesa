module Infrastructure.Persistence.RepositoryCandidates where

import Data.Aeson
import Modules.Candidates.Domain
import Modules.Candidates.Infrastructure

-- Json Marshaller
instance ToJSON Candidate

instance ToJSON CandidateId

-- DB Repository
instance CandidateRepository IO where
  find candidateId =
    if (getCandidateId candidateId `mod` 2) == 0
      then pure Nothing
      else pure $ Just (Candidate candidateId "a candidate")
  create candidate = print $ "inside repo: " <> show candidate
  searchAll =
    let candidateIds = [CandidateId id | id <- [1 .. 5]]
     in pure $
          [ (Candidate candidateId "a candidate")
            | candidateId <- candidateIds
          ]
