{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module Modules.Candidates.Infrastructure.Http.Api where

import Control.Monad.Except (MonadIO, liftIO)
import Control.Monad.Logger (logDebugNS)
import Database.Persist.Postgresql (Entity (..), selectList)
import Infrastructure.Logger
import Infrastructure.Persistence.DBHelper (runDb)
import Infrastructure.Types
import Modules.Candidates.Domain.Entity
import Modules.Candidates.Infrastructure.Persistence.Models
import Servant

type CandidateAPI = "candidates" :> Get '[JSON] [Candidate]

candidateApi :: Proxy CandidateAPI
candidateApi = Proxy

-- | The server that runs the CandidateAPI
candidateServer :: MonadIO m => ServerT CandidateAPI (AppT m)
candidateServer = allCandidates

-- | Returns all users in the database.
allCandidates :: MonadIO m => AppT m [Candidate]
allCandidates = do
  logDebugNS "web" "allCandidates"
  candidatesResult <- runDb $(selectList [] [])
  let candidates =
        map (\(Entity _ c) -> candidatetToCandidate c) candidatesResult
  return candidates