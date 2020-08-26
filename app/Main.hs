{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Application.App as App (runApp)
import qualified Application.Cli as CliApp (runApp)
import Application.Mode
import Options.Generic (getRecord)

-- | The 'main' function gathers the required environment information and
-- initializes the application.
main :: IO ()
main = do
  (Mode appMode) <- getRecord "App creator"
  case appMode of
    (Just appMode') -> startUpApp appMode'
    Nothing -> startUpApp Normal
  where
    startUpApp :: AppMode -> IO ()
    startUpApp Cli = CliApp.runApp
    startUpApp Normal = App.runApp