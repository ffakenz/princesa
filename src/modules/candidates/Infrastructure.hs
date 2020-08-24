module Modules.Candidates.Infrastructure where

import Modules.Candidates.Domain

class Monad e => CandidateRepository e where
  find :: CandidateId -> e (Maybe Candidate)
  create :: Candidate -> e ()
  searchAll :: e [Candidate]