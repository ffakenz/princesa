module Modules.Jobs.Infrastructure where

import Modules.Jobs.Domain

class Monad e => JobRepository e where
  find :: JobId -> e (Maybe Job)
  create :: Job -> e ()
  searchAll :: e [Job]