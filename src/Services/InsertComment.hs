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
import Database.MongoDB ( Pipe, Database )
import Database.Redis ( Connection )
import Logger.Styles(_info, _error, _green)

insertComment :: (Pipe, Database) -> Connection -> ([Char] -> [Char] -> IO())-> Api
insertComment connection connectionRedis _logger = do
    post "comments" $ do
        liftIO $ _logger _info "[POST - Create comment]"

        body <- jsonBody :: ApiAction (Maybe PR.PostCommentRequest)

        case isNothing body of
            True -> do
                liftIO $ _logger _error "[POST 400 - Error parsing request body]"
                setStatus status400 >> _PARSING_POST_BODY
            _    -> do
                taskIntegration <- liftIO $ getTaskInfo body connectionRedis
                let continue = returnedTaskInfo taskIntegration
                continue connection body _logger

returnedTaskInfo 200 = createComment
returnedTaskInfo 404 = taskNotFound
returnedTaskInfo _   = errorSearchingTask

createComment connection body _logger = do
    let (Just sanitizeBody) = body
    uuid <- liftIO generateUUID

    let comment = CM.Comment {
        CM.content   = PR.content sanitizeBody,
        CM.taskId    = PR.taskId sanitizeBody,
        CM.boardId   = PR.boardId sanitizeBody,
        CM.commentId = uuid
    }

    insertedComment <- liftIO $ MongoOperations.insertComment connection comment

    liftIO $ _logger _green "[POST 201 - Comment created]"
    setStatus status201 >> Res.responseSimple (statusCode status201) insertedComment

taskNotFound _ _ _logger = do 
    liftIO $ _logger _error "[POST 404 - Task not found]"
    setStatus status404 >> _TASK_NOT_FOUND

errorSearchingTask _ _ _logger = do 
    liftIO $ _logger _error "[POST 400 - Error searching task]"
    setStatus status400 >> _ERROR_SEARCHING_TASK