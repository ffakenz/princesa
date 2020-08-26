{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Modules.Jobs.Infrastructure.Http.Api where

import Control.Monad.Reader (MonadIO)
import Infrastructure.Types
import Modules.Jobs.Domain.Entity
import Modules.Jobs.Infrastructure.Http.Handler
import Servant

type JobAPI =
  "jobs" :> Get '[JSON] [Job]
    :<|> "jobs" :> ReqBody '[JSON] Job :> Post '[JSON] ()
    :<|> "jobs" :> Capture "jobId" Int :> Get '[JSON] (Maybe Job)

jobApi :: Proxy JobAPI
jobApi = Proxy

-- | The server that runs the JobAPI
jobServer :: MonadIO m => ServerT JobAPI (AppT m)
jobServer = allJobs :<|> createJob :<|> findJob