module Lib
  ( someFunc,
  )
where

import Modules.Candidates.Domain.Entity
import Modules.Candidates.Domain.Repository
import Modules.Candidates.Domain.Service
import Modules.Jobs.Domain.Repository

someFunc :: (CandidateRepository e, JobRepository e) => (String -> e ()) -> e ()
someFunc print = do
  candidateProcess print

candidateProcess :: (CandidateRepository e) => (String -> e ()) -> e ()
candidateProcess print = do
  -- first find
  someCandidate <- findCandidate (CandidateId 1)
  print $ show someCandidate
  -- create success
  let aCandidate = Candidate (CandidateId 3) "another candidate"
  createResult <- createCandidate aCandidate
  print $ show createResult
  -- second find
  someCandidate2 <- findCandidate (CandidateId 2)
  print $ show someCandidate2