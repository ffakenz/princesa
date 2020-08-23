module Modules.Jobs.Service where

import Modules.Jobs.Domain
import Modules.Jobs.Infrastructure

getJob ::
  (JobRepository e) =>
  JobId ->
  e (JobResponse (Maybe Job))
getJob jobId = Right <$> find jobId

createJob ::
  (JobRepository e) =>
  Job ->
  e (JobResponse ())
createJob job@(Job jobId _) =
  do
    jobR <- getJob jobId
    case jobR of
      (Right (Just job)) ->
        Right <$> create job
      (Right Nothing) ->
        pure . Left . JobError $ "job already exists"
      (Left jobError) ->
        pure . Left $ jobError