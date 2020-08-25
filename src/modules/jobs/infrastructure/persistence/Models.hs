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

module Modules.Jobs.Infrastructure.Persistence.Models where

import Database.Persist.Sql (SqlPersistT, runMigration)
import Database.Persist.TH
  ( mkMigrate,
    mkPersist,
    persistLowerCase,
    share,
    sqlSettings,
  )
import Modules.Jobs.Domain.Entity

-- @TODO revisit Tjob Primary key Int (jobId)
share
  [mkPersist sqlSettings, mkMigrate "migrateAll"]
  [persistLowerCase|

JobT sql=jobs
    key Int
    description String
    deriving Show
|]

doMigrations :: SqlPersistT IO ()
doMigrations = runMigration migrateAll

jobtToJob :: JobT -> Job
jobtToJob JobT {..} =
  Job
    { jobId = JobId $ jobTKey,
      jobDescription = jobTDescription
    }