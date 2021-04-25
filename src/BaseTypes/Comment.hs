{-# LANGUAGE DeriveGeneric #-}

module BaseTypes.Comment where
import BaseTypes.BaseTypes ( Content, TaskId, CommentId, BoardId )
import Data.Aeson ( FromJSON, ToJSON )
import GHC.Generics ( Generic )

data Comment = Comment {
    content   :: Content,
    taskId    :: TaskId,
    commentId :: CommentId,
    boardId   :: BoardId
} deriving (Generic, Show)

instance ToJSON Comment

instance FromJSON Comment