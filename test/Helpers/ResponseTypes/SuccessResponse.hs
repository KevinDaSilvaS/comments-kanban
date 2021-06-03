{-# LANGUAGE DeriveGeneric #-}
module Helpers.ResponseTypes.SuccessResponse where

import BaseTypes.Comment (Comment)
import qualified Data.Aeson as Aeson
import GHC.Generics (Generic)

data ReqResponseArray = ReqResponseArray
    { 
        code :: String,
        details :: [Comment]
    } deriving (Generic, Show)

instance Aeson.ToJSON ReqResponseArray

instance Aeson.FromJSON ReqResponseArray