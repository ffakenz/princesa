{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Modules.Candidates.Domain.Entity where

import GHC.Generics

newtype CandidateId = CandidateId
  { getCandidateId :: Int
  }
  deriving (Show, Enum, Num, Generic)

data Candidate = Candidate
  { candidateId :: CandidateId,
    candidateDescription :: String
  }
  deriving (Show, Generic)

newtype CandidateError = CandidateError
  { errorMessage :: String
  }
  deriving (Show)

type CandidateResponse a = Either CandidateError a