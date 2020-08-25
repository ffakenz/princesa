{-# LANGUAGE FlexibleContexts #-}

module Modules.Jobs.Domain.Repository where

import Infrastructure.Types
import Modules.Jobs.Domain.Entity

class Monad m => JobRepository m where
  find :: JobId -> m (Maybe Job)
  create :: Job -> m ()
  searchAll :: m [Job]