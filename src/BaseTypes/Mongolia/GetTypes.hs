{-# LANGUAGE DeriveGeneric #-}

module BaseTypes.Mongolia.GetTypes where

import GHC.Generics ( Generic )
import Data.Aeson ( FromJSON, ToJSON )
import BaseTypes.Comment as CM
import BaseTypes.Mongolia.InsertTypes as CB (BodyComment, boardId, _id, taskId, content)
    
data GetResponse = GetResponse {
    code :: Int,
    details::[BodyComment]
}deriving(Generic, Show)
instance ToJSON GetResponse
    
instance FromJSON GetResponse

serializeGet :: GetResponse -> [BodyComment]
serializeGet GetResponse { code = code, details=details } = details  

serializeResponse :: [CB.BodyComment] -> [CM.Comment]
serializeResponse registers = comments
    where
        comments = map serializeBodyComment registers

serializeBodyComment :: BodyComment -> Comment
serializeBodyComment commentBody = CM.Comment {
    CM.commentId = CB._id commentBody,
    CM.taskId    = CB.taskId commentBody,
    CM.boardId   = CB.boardId commentBody,
    CM.content   = CB.content commentBody
}