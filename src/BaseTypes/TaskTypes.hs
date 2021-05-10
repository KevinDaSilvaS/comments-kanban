{-# LANGUAGE DeriveGeneric #-}

module BaseTypes.TaskTypes where

import GHC.Generics ( Generic )
import Data.Aeson ( FromJSON, ToJSON )

data Details = Details {
    title:: String,
    description:: Maybe String,
    boardId:: String,
    status:: String
} deriving(Generic, Show)
instance ToJSON Details
    
instance FromJSON Details
    
data Response = Response {
    code :: Int,
    details::Details
}deriving(Generic, Show)
instance ToJSON Response
    
instance FromJSON Response

serializeResponse :: Response -> (Int, Details)
serializeResponse Response { code = code, details=details } = (code, details)