{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Modules.Candidates.Infrastructure.Http.Api where

import Control.Monad.Reader (MonadIO)
import Infrastructure.Types
import Modules.Candidates.Domain.Entity
import Modules.Candidates.Infrastructure.Http.Handler
import Servant

type CandidateAPI =
  "candidates" :> Get '[JSON] [Candidate]
    :<|> "candidates" :> ReqBody '[JSON] Candidate :> Post '[JSON] ()
    :<|> "candidates" :> Capture "candidatesId" Int :> Get '[JSON] (Maybe Candidate)

candidateApi :: Proxy CandidateAPI
candidateApi = Proxy

-- | The server that runs the CandidateAPI
candidateServer :: MonadIO m => ServerT CandidateAPI (AppT m)
candidateServer = allCandidates :<|> createCandidate :<|> findCandidate