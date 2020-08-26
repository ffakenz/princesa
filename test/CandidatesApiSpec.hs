{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module CandidatesApiSpec (spec) where

import Infrastructure.Config
import Infrastructure.Http.Api (app)
import Application.NormalMode
import Infrastructure.Logger (defaultLogEnv)
import Test.Hspec
import Test.Hspec.Wai
import Test.Hspec.Wai.JSON

-- @TODO inject config to app
spec :: Spec
spec = with (_app) $ do
  describe "GET /candidates" $ do
    it "responds with 200" $ do
      get "/candidates" `shouldRespondWith` 200
    it "responds with [Candidate]" $ do
      let candidates = "[]"
      get "/candidates" `shouldRespondWith` candidates
  where
    _app = do
      logEnv <- defaultLogEnv
      pool <- makePool Test logEnv
      executeMigration pool
      let cfg = defaultConfig logEnv pool
      pure . app $ cfg