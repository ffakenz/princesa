module Modules.Candidates.Domain where

newtype CandidateId = CandidateId
  { getCandidateId :: Int
  }
  deriving (Show)

data Candidate = Candidate
  { candidateId :: CandidateId,
    candidateDescription :: String
  }
  deriving (Show)

newtype CandidateError = CandidateError
  { errorMessage :: String
  }
  deriving (Show)

type CandidateResponse a = Either CandidateError a