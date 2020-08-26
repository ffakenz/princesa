{-# LANGUAGE OverloadedStrings #-}

module Modules.Candidates.Infrastructure.Persistence.Db where

import Control.Monad.Logger (logDebugNS)
import Control.Monad.Reader (MonadIO, liftIO)
import Data.Text (pack)
import Database.Persist.Postgresql
  ( Entity (..),
    fromSqlKey,
    insert,
    selectFirst,
    selectList,
    (==.),
  )
import Infrastructure.Config (Config)
import Infrastructure.Logger
import Infrastructure.Persistence.DBRuntime (runDb)
import Infrastructure.Types (AppT)
import Modules.Candidates.Domain.Entity
import Modules.Candidates.Domain.Repository
import Modules.Candidates.Infrastructure.Persistence.Models
  ( EntityField (CandidateTKey),
    candidateToCandidateT,
    candidatetToCandidate,
  )

instance MonadIO m => CandidateRepository (AppT m) where
  find candidateId = do
    logDebugNS "web" (pack $ ("finding a candidate " <> show candidateId))
    candidateResult <- runDb (selectFirst [CandidateTKey ==. (getCandidateId candidateId)] [])
    let maybeCandidate = (\(Entity _ c) -> candidatetToCandidate c) <$> candidateResult
    return maybeCandidate
  create candidate = do
    logDebugNS "web" (pack $ ("creating a candidate " <> show candidate))
    newCandidate <- runDb (insert $ candidateToCandidateT $ candidate)
    let logMsg = pack $ ("candidate created " <> show newCandidate <> " with key " <> (show $ fromSqlKey newCandidate))
    logDebugNS "web" logMsg
    return ()
  searchAll = do
    logDebugNS "web" "searchAll"
    candidatesResult <- runDb $(selectList [] [])
    let candidates = map (\(Entity _ c) -> candidatetToCandidate c) candidatesResult
    return candidates
