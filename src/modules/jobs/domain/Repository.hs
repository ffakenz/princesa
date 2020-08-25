module Modules.Jobs.Domain.Repository where

import Modules.Jobs.Domain.Entity

class Monad e => JobRepository e where
  find :: JobId -> e (Maybe Job)
  create :: Job -> e ()
  searchAll :: e [Job]