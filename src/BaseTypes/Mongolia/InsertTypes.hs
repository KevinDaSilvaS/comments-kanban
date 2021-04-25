{-# LANGUAGE DeriveGeneric #-}

module BaseTypes.Mongolia.InsertTypes where

import GHC.Generics ( Generic )
import Data.Aeson ( FromJSON, ToJSON )

data BodyComment = BodyComment {
    boardId:: String,
    taskId:: String,
    content:: String,
    _id:: String,
    _v :: Int
} deriving(Generic, Show)
instance ToJSON BodyComment
    
instance FromJSON BodyComment
    
data InsertResponse = InsertResponse {
    code :: Int,
    details::BodyComment
}deriving(Generic, Show)
instance ToJSON InsertResponse
    
instance FromJSON InsertResponse

serializeInsert :: InsertResponse -> String
serializeInsert InsertResponse { code = code, details=details } = token
    where 
        token =  _id details  