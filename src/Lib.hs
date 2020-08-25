module Lib
  ( someFunc,
  )
where

import Modules.Candidates.Domain.Entity
import Modules.Candidates.Domain.Repository
import Modules.Candidates.Domain.Service
import Modules.Jobs.Domain.Entity
import Modules.Jobs.Domain.Repository
import Modules.Jobs.Domain.Service

someFunc :: (CandidateRepository e, JobRepository e) => (String -> e ()) -> e ()
someFunc print = do
  jobProcess print
  candidateProcess print

jobProcess :: (JobRepository e) => (String -> e ()) -> e ()
jobProcess print = do
  -- first find
  someJob <- findJob (JobId 1)
  print $ show someJob
  -- create success
  let aJob = Job (JobId 3) "another job"
  createResult <- createJob aJob
  print $ show createResult
  someJob2 <- findJob (JobId 2)
  print $ show someJob2

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