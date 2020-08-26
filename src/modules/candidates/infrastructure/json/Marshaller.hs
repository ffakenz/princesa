module Modules.Candidates.Infrastructure.Json.Marshaller where

import Data.Aeson
import Modules.Candidates.Domain.Entity

instance ToJSON CandidateId

instance FromJSON CandidateId

instance ToJSON Candidate

instance FromJSON Candidate