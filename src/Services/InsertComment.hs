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
            taskIntegration <- liftIO $ getTaskInfo body

            case taskIntegration of
                200 -> do
                    let (Just sanitizeBody) = body
                    uuid <- liftIO generateUUID

                    let comment = CM.Comment {
                        CM.content   = PR.content sanitizeBody,
                        CM.taskId    = PR.taskId sanitizeBody,
                        CM.boardId   = PR.boardId sanitizeBody,
                        CM.commentId = uuid
                    }

                    insertedComment <- liftIO $ 
                        MongoOperations.insertComment comment

                    setStatus status201 >> Res.responseSimple 
                        (statusCode status201) insertedComment

                404 -> do setStatus status404 >> _TASK_NOT_FOUND
                _   -> do setStatus status400 >> _ERROR_SEARCHING_TASK