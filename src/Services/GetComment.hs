{-# LANGUAGE OverloadedStrings #-}

module Services.GetComment where

import Web.Spock

import BaseTypes.Comment
    ( Comment(Comment, content, taskId, commentId, boardId) )
import BaseTypes.SpockApi ( Api, ApiAction )

getComment :: Api
getComment = do
    get ("comments" <//> var <//> var) $ \taskId commentId -> do
        json Comment { 
            content   = "This a comment in a task", 
            taskId    = taskId,
            commentId = commentId,
            boardId =  "ads3rf4"
        }