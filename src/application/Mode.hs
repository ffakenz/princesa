{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module Application.Mode where

import Options.Generic

data AppMode = Cli | Normal deriving (Generic, Show, Read)

data Mode = Mode
  { appMode :: Maybe AppMode
  }
  deriving (Generic, Show)

instance ParseField AppMode

instance ParseFields AppMode

instance ParseRecord AppMode

instance ParseRecord Mode
