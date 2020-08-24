{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Infrastructure.HttpServer where

import Control.Monad.IO.Class (liftIO)
import Infrastructure.Jobs ()
import Modules.Jobs.Domain
import Modules.Jobs.Service
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

type API = "jobs" :> Get '[JSON] [Job]

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = liftIO searchAllJobsHandler

searchAllJobsHandler :: IO [Job]
searchAllJobsHandler = do
  response <- searchAllJobs
  case response of
    (Right js) -> pure js
    (Left error) -> pure []
