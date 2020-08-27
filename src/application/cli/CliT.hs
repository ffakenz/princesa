{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Application.Cli.CliT where

import Control.Monad.Except (ExceptT, MonadError)
import Control.Monad.Reader
  ( MonadIO,
    MonadReader,
    ReaderT,
    asks,
  )
import Infrastructure.Config (Config)

data CliError = CliError
  { errorMessage :: String
  }
  deriving (Show)

newtype CliT m a = CliT
  { -- runCli :: ReaderT Config (ExceptT CliError m) a
    runCli :: ReaderT (Config, ProgramInput) (ExceptT CliError m) a
  }
  deriving
    ( Functor,
      Applicative,
      Monad,
      MonadReader (Config, ProgramInput),
      MonadError CliError,
      MonadIO
    )

data ProgramInput
  = AllJobs
  | CreateJob {key :: String, description :: String}
  | FindJob {key :: String}
  | AllCandidates
  | CreateCandidate {key :: String, description :: String}
  | FindCandidate {key :: String}