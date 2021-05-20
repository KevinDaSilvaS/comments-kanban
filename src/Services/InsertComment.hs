{-# LANGUAGE OverloadedStrings #-}

module Services.InsertComment where

import Web.Spock
import Network.HTTP.Types

import BaseTypes.SpockApi ( Api, ApiAction )
import qualified BaseTypes.PostRequest as PR
import BaseTypes.Comment as CM
import Errors.ErrorMessages
import Data.Maybe (isNothing)

import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)

import LoadEnv
import System.Environment (lookupEnv)
import Services.Integrations.MiniKanban.GetTaskInfo
import Response.Response as Res

import Helpers.GenerateUUID

insertComment :: Api
insertComment = do
    post "comments" $ do
        body <- jsonBody :: ApiAction (Maybe PR.PostCommentRequest)
        if isNothing body then
            setStatus status400 >> _PARSING_POST_BODY
        else do
            let (Just sanitizeBody) = body
            let boardId = PR.boardId sanitizeBody
            let taskId = PR.taskId sanitizeBody

            taskIntegration <- liftIO $ getTaskInfo body

            if fst taskIntegration >= 500 then do
                setStatus status500 >> _INTERNAL_SERVER_ERROR

            else if snd taskIntegration == 404 then do
                setStatus status404 >> _BOARD_NOT_FOUND

            else do 
                uuid <- liftIO generateUUID

                let comment = CM.Comment {
                    CM.content   = PR.content sanitizeBody,
                    CM.taskId    = taskId,
                    CM.boardId   = boardId,
                    CM.commentId = uuid
                }

                insertedComment <- liftIO $ MongoOperations.insertComment comment
                setStatus status201 >> Res.responseSimple 
                    (statusCode status201) insertedComment