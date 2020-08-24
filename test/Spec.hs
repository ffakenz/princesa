{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main (main) where

import Infrastructure.HttpServer (app)
import Test.Hspec
import Test.Hspec.Wai
import Test.Hspec.Wai.JSON

main :: IO ()
main = hspec spec

spec :: Spec
spec = with (return app) $ do
  describe "GET /jobs" $ do
    it "responds with 200" $ do
      get "/jobs" `shouldRespondWith` 200
    it "responds with [Job]" $ do
      let jobs = "[{\"jobId\":{\"getJobId\":1},\"jobDescription\":\"a job\"},{\"jobId\":{\"getJobId\":2},\"jobDescription\":\"a job\"},{\"jobId\":{\"getJobId\":3},\"jobDescription\":\"a job\"},{\"jobId\":{\"getJobId\":4},\"jobDescription\":\"a job\"},{\"jobId\":{\"getJobId\":5},\"jobDescription\":\"a job\"}]"
      get "/jobs" `shouldRespondWith` jobs
