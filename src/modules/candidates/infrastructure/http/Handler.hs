module Modules.Candidates.Infrastructure.Http.Handler where

import Control.Monad.Logger (logDebugNS)
import Control.Monad.Reader (MonadIO)
import Infrastructure.Logger
import Infrastructure.Types
import Modules.Candidates.Domain.Entity
import qualified Modules.Candidates.Domain.Service as Candidates
import Modules.Candidates.Infrastructure.Persistence.Db

-- | Returns a candidate in the database.
findCandidate :: MonadIO m => Int -> AppT m (Maybe Candidate)
findCandidate candidateId = do
  findCandidateR <- Candidates.findCandidate (CandidateId candidateId)
  let result = case findCandidateR of
        (Right maybeCandidate) -> maybeCandidate
        (Left error) -> Nothing -- @TODO
  return result

-- | Returns all candidates in the database.
allCandidates :: MonadIO m => AppT m [Candidate]
allCandidates = do
  searchAllCandidatesR <- Candidates.searchAllCandidates
  let result = case searchAllCandidatesR of
        (Right candidates) -> candidates
        (Left error) -> [] -- @TODO
  return result

-- | Create a candidate in the database.
createCandidate :: MonadIO m => Candidate -> AppT m ()
createCandidate candidate = do
  createCandidateR <- Candidates.createCandidate candidate
  let result = case createCandidateR of
        (Right _) -> ()
        (Left error) -> () -- @TODO
  return result