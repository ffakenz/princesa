module Main where

import Infrastructure.Init (runApp)

-- | The 'main' function gathers the required environment information and
-- initializes the application.
main :: IO ()
main = runApp
