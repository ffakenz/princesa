module Modules.Candidates.Domain.Service where

import Modules.Candidates.Domain.Entity
import Modules.Candidates.Domain.Repository

searchAllCandidates ::
  (CandidateRepository e) =>
  e (CandidateResponse [Candidate])
searchAllCandidates = Right <$> searchAll

findCandidate ::
  (CandidateRepository e) =>
  CandidateId ->
  e (CandidateResponse (Maybe Candidate))
findCandidate candidateId = Right <$> find candidateId

createCandidate ::
  (CandidateRepository e) =>
  Candidate ->
  e (CandidateResponse ())
createCandidate candidate@(Candidate candidateId _) =
  do
    candidateR <- findCandidate candidateId
    case candidateR of
      (Right (Just candidate)) ->
        Right <$> create candidate
      (Right Nothing) ->
        pure . Left . CandidateError $ "candidate already exists"
      (Left candidateError) ->
        pure . Left $ candidateError