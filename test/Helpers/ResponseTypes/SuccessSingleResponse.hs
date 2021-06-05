{-# LANGUAGE DeriveGeneric #-}

module Helpers.ResponseTypes.SuccessSingleResponse where

import BaseTypes.Comment ( Comment )
import qualified Data.Aeson as Aeson
import GHC.Generics (Generic)

data ReqResponse = ReqResponse
    { 
        code :: String,
        details :: Comment
    }
    deriving (Generic, Show)
  
instance Aeson.ToJSON ReqResponse
  
instance Aeson.FromJSON ReqResponse