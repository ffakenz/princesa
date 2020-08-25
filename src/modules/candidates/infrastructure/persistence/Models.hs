{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

module Modules.Candidates.Infrastructure.Persistence.Models where

import Database.Persist.Sql (SqlPersistT, runMigration)
import Database.Persist.TH
  ( mkMigrate,
    mkPersist,
    persistLowerCase,
    share,
    sqlSettings,
  )
import Modules.Candidates.Domain.Entity

-- @TODO revisit Tjob Primary key Int (jobId)
share
  [mkPersist sqlSettings, mkMigrate "migrateAll"]
  [persistLowerCase|

CandidateT sql=candidates
    key Int
    description String
    deriving Show

|]

doMigrations :: SqlPersistT IO ()
doMigrations = runMigration migrateAll

candidatetToCandidate :: CandidateT -> Candidate
candidatetToCandidate CandidateT {..} =
  Candidate
    { candidateId = CandidateId $ candidateTKey,
      candidateDescription = candidateTDescription
    }