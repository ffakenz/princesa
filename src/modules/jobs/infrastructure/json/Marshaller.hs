module Modules.Jobs.Infrastructure.Json.Marshaller where

import Data.Aeson
import Modules.Jobs.Domain.Entity

instance ToJSON JobId

instance FromJSON JobId

instance ToJSON Job

instance FromJSON Job