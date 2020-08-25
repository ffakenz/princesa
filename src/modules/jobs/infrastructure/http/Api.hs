{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module Modules.Jobs.Infrastructure.Http.Api where

import Control.Monad.Except (MonadIO, liftIO)
import Control.Monad.Logger (logDebugNS)
import Database.Persist.Postgresql (Entity (..), selectList)
import Infrastructure.Logger
import Infrastructure.Persistence.DBHelper (runDb)
import Infrastructure.Types
import Modules.Jobs.Domain.Entity
import Modules.Jobs.Infrastructure.Persistence.Models
import Servant

type JobAPI = "jobs" :> Get '[JSON] [Job]

jobApi :: Proxy JobAPI
jobApi = Proxy

-- | The server that runs the JobAPI
jobServer :: MonadIO m => ServerT JobAPI (AppT m)
jobServer = allJobs

-- | Returns all users in the database.
allJobs :: MonadIO m => AppT m [Job]
allJobs = do
  logDebugNS "web" "allJobs"
  jobsResult <- runDb $(selectList [] [])
  let jobs =
        map (\(Entity _ c) -> jobtToJob c) jobsResult
  return jobs