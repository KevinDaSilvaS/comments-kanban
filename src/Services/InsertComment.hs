{-# LANGUAGE OverloadedStrings #-}

module Services.InsertComment where

import Web.Spock
import Network.HTTP.Types
import Network.HTTP.Simple

import BaseTypes.SpockApi ( Api, ApiAction )
import qualified BaseTypes.PostRequest as PR
import BaseTypes.Comment
import Errors.ErrorMessages
import Data.Maybe (isNothing)

import qualified Data.Aeson as Aeson
import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)

import Data.UUID
import Data.UUID.V1 ( nextUUID )

insertComment :: Api
insertComment = do
    post "comments" $ do
        body <- jsonBody :: ApiAction (Maybe PR.PostCommentRequest)
        if isNothing body then
            setStatus status400 >> _PARSING_POST_BODY
        else do
            let (Just sanitizeBody) = body
            response <- httpLBS "http://httpbin.org/get"
            let code = getResponseStatusCode response

            if code == 200 then do
                uuid <- liftIO nextUUID
                let (Just sanitizedUUID) = uuid
                let strUUID = toString sanitizedUUID

                let comment = Comment {
                    content   = PR.content sanitizeBody,
                    taskId    = PR.taskId sanitizeBody,
                    boardId   = PR.boardId sanitizeBody,
                    commentId = strUUID
                }

                insertedComment <- liftIO $ MongoOperations.insertComment comment
                setStatus status201 >> json insertedComment
            else if code == 404 then
                setStatus status404 >> _BOARD_NOT_FOUND
            else
                setStatus status500 >> _INTERNAL_SERVER_ERROR
