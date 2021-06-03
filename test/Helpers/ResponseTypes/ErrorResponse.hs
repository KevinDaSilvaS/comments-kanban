{-# LANGUAGE DeriveGeneric #-}

module Helpers.ResponseTypes.ErrorResponse where

import qualified Data.Aeson as Aeson
import GHC.Generics (Generic)

data ReqResponseError = ReqResponseError
    { 
        code :: String,
        details :: String
    }
    deriving (Generic, Show)
  
instance Aeson.ToJSON ReqResponseError
  
instance Aeson.FromJSON ReqResponseError