module Modules.Candidates.Service where

import Modules.Candidates.Domain
import Modules.Candidates.Infrastructure

getCandidate ::
  (CandidateRepository e) =>
  CandidateId ->
  e (CandidateResponse (Maybe Candidate))
getCandidate candidateId = Right <$> find candidateId

createCandidate ::
  (CandidateRepository e) =>
  Candidate ->
  e (CandidateResponse ())
createCandidate candidate@(Candidate candidateId _) =
  do
    candidateR <- getCandidate candidateId
    case candidateR of
      (Right (Just candidate)) ->
        Right <$> create candidate
      (Right Nothing) ->
        pure . Left . CandidateError $ "candidate already exists"
      (Left candidateError) ->
        pure . Left $ candidateError