module Modules.Jobs.Domain.Service where

import Modules.Jobs.Domain.Entity
import Modules.Jobs.Domain.Repository

searchAllJobs :: (JobRepository e) => e (JobResponse [Job])
searchAllJobs = Right <$> searchAll

findJob ::
  (JobRepository e) =>
  JobId ->
  e (JobResponse (Maybe Job))
findJob jobId = Right <$> find jobId

createJob ::
  (JobRepository e) =>
  Job ->
  e (JobResponse ())
createJob job@(Job jobId _) =
  do
    jobR <- findJob jobId
    case jobR of
      (Right (Just job)) ->
        Right <$> create job
      (Right Nothing) ->
        pure . Left . JobError $ "job already exists"
      (Left jobError) ->
        pure . Left $ jobError