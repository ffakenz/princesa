module Main where

import Infrastructure.Candidates ()
import Infrastructure.HttpServer
import Infrastructure.Jobs ()

-- import Lib
-- main = someFunc print

main :: IO ()
main = startApp
