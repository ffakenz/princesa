module Lib
  ( someFunc,
  )
where

import Infrastructure.Candidates ()
import Infrastructure.Jobs ()
import Modules.Candidates.Domain
import Modules.Candidates.Infrastructure
import Modules.Candidates.Service
import Modules.Jobs.Domain
import Modules.Jobs.Infrastructure
import Modules.Jobs.Service

someFunc :: (CandidateRepository e, JobRepository e) => (String -> e ()) -> e ()
someFunc print = do
  jobProcess print
  candidateProcess print

jobProcess :: (JobRepository e) => (String -> e ()) -> e ()
jobProcess print = do
  -- first find
  someJob <- getJob (JobId 1)
  print $ show someJob
  -- create success
  let aJob = Job (JobId 3) "another job"
  createResult <- createJob aJob
  print $ show createResult
  someJob2 <- getJob (JobId 2)
  print $ show someJob2

candidateProcess :: (CandidateRepository e) => (String -> e ()) -> e ()
candidateProcess print = do
  -- first find
  someCandidate <- getCandidate (CandidateId 1)
  print $ show someCandidate
  -- create success
  let aCandidate = Candidate (CandidateId 3) "another candidate"
  createResult <- createCandidate aCandidate
  print $ show createResult
  -- second find
  someCandidate2 <- getCandidate (CandidateId 2)
  print $ show someCandidate2