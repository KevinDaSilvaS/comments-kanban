{-# LANGUAGE OverloadedStrings #-}

module Services.GetAllComments where

import Web.Spock

import BaseTypes.Comment
import BaseTypes.SpockApi ( Api, ApiAction )
    
getAllComments :: Api
getAllComments = do
    get ("comments" <//> var) $ \taskId -> do
        json [
            Comment { 
                content = "This a comment in a task", 
                taskId =  taskId,
                commentId = "j4k0s-s",
                boardId =  "ads3rf4"
            }, 
            Comment { 
                content = "Move the tasks in the board. with love PM", 
                taskId = "ads3rf4",
                commentId = "jk6k0-s",
                boardId =  "ads3rf4"
            }]