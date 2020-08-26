{-# LANGUAGE TypeOperators #-}

module Infrastructure.Http.Api (app) where

import Control.Monad.Reader (runReaderT)
import Infrastructure.Config (Config (..))
import Infrastructure.Types (AppT (..))
import Modules.Candidates.Infrastructure.Http.Api
  ( CandidateAPI,
    candidateApi,
    candidateServer,
  )
import Modules.Candidates.Infrastructure.Json.Marshaller
import Modules.Jobs.Infrastructure.Http.Api (JobAPI, jobApi, jobServer)
import Modules.Jobs.Infrastructure.Json.Marshaller
import Servant
  ( Proxy (Proxy),
    Raw,
    Server,
    serve,
    serveDirectoryFileServer,
    (:<|>) ((:<|>)),
  )
import Servant.Server

-- | This is the function we export to run our 'JobAPI'. Given
-- a 'Config', we return a WAI 'Application' which any WAI compliant server
-- can run.
jobApp :: Config -> Application
jobApp cfg = serve jobApi (jobAppToServer cfg)

jobAppToServer :: Config -> Server JobAPI
jobAppToServer cfg = hoistServer jobApi (convertApp cfg) jobServer

-- | This is the function we export to run our 'CandidatesAPI'. Given
-- a 'Config', we return a WAI 'Application' which any WAI compliant server
-- can run.
candidateApp :: Config -> Application
candidateApp cfg = serve candidateApi (candidateAppToServer cfg)

candidateAppToServer :: Config -> Server CandidateAPI
candidateAppToServer cfg = hoistServer candidateApi (convertApp cfg) candidateServer

-- | This functions tells Servant how to run the 'App' monad with our
-- 'server' function.
appToServer :: Config -> Server AppAPI
appToServer cfg = jobAppToServer cfg :<|> candidateAppToServer cfg

-- | This function converts our @'AppT' m@ monad into the @ExceptT ServantErr
-- m@ monad that Servant's 'enter' function needs in order to run the
-- application.
convertApp :: Config -> AppT IO a -> Handler a
convertApp cfg appt = Handler $ runReaderT (runApp appt) cfg

-- | API type, the ':<|>' combinator is used to unify
-- two different APIs and applications.
type AppAPI = JobAPI :<|> CandidateAPI

appApi :: Proxy AppAPI
appApi = Proxy

-- | Finally, this function takes a configuration and runs our 'API'
app :: Config -> Application
app cfg =
  serve appApi (appToServer cfg)
