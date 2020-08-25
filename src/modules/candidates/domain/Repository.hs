module Modules.Candidates.Domain.Repository where

import Modules.Candidates.Domain.Entity

class Monad e => CandidateRepository e where
  find :: CandidateId -> e (Maybe Candidate)
  create :: Candidate -> e ()
  searchAll :: e [Candidate]