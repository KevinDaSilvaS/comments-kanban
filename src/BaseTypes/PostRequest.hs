{-# LANGUAGE DeriveGeneric #-}

module BaseTypes.PostRequest where
import BaseTypes.BaseTypes ( Content, TaskId, BoardId )
import Data.Aeson ( FromJSON, ToJSON )
import GHC.Generics ( Generic )

data PostCommentRequest = PostCommentRequest {
        content :: Content,
        boardId :: BoardId,
        taskId  :: TaskId
    } deriving (Generic, Show)

instance ToJSON PostCommentRequest

instance FromJSON PostCommentRequest
    