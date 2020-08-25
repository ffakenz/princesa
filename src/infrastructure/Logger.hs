{-# LANGUAGE OverloadedStrings #-}

module Infrastructure.Logger
  ( adapt,
    defaultLogEnv,
    logMsg,
    runKatipT,
    KatipT (..),
    Katip (..),
    LogEnv,
    Severity (..),
  )
where

import Control.Monad.IO.Class
import Control.Monad.Logger
import qualified Control.Monad.Logger as Logger
import Control.Monad.Reader (asks)
import Infrastructure.Config
import Infrastructure.Types
import Katip
import qualified System.IO as IO
import qualified System.Log.FastLogger as FastLogger

defaultLogEnv :: IO LogEnv
defaultLogEnv = do
  handleScribe <- mkHandleScribe ColorIfTerminal IO.stdout (permitItem DebugS) V2
  env <- initLogEnv "princesa" "production"
  registerScribe "stdout" handleScribe defaultScribeSettings env

fromLevel :: LogLevel -> Severity
fromLevel LevelDebug = DebugS
fromLevel LevelInfo = InfoS
fromLevel LevelWarn = WarningS
fromLevel LevelError = ErrorS
fromLevel (LevelOther _) = NoticeS

-- | Transforms Katip logMsg into monadLoggerLog to be used inside
-- MonadLogger monad
adapt ::
  (ToLogStr msg, Applicative m, Katip m) =>
  (Namespace -> Severity -> Katip.LogStr -> m ()) ->
  Loc ->
  LogSource ->
  LogLevel ->
  msg ->
  m ()
adapt f _ src lvl msg =
  f ns (fromLevel lvl) $ logStr' msg
  where
    ns = Namespace [src]
    -- not sure how fast this is going to be
    logStr' = Katip.logStr . FastLogger.fromLogStr . Logger.toLogStr

-- | Katip instance for @AppT m@
instance MonadIO m => Katip (AppT m) where
  getLogEnv = asks configLogEnv
  localLogEnv = error "not implemented"

-- | MonadLogger instance to use within @AppT m@
instance MonadIO m => MonadLogger (AppT m) where
  monadLoggerLog = adapt logMsg

-- | MonadLogger instance to use in @makePool@
instance MonadIO m => MonadLogger (KatipT m) where
  monadLoggerLog = adapt logMsg