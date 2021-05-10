{-# LANGUAGE OverloadedStrings #-}

module Services.InsertComment where

import Web.Spock
import Network.HTTP.Types
import Network.HTTP.Simple
import Network.HTTP.Conduit

import BaseTypes.SpockApi ( Api, ApiAction )
import qualified BaseTypes.PostRequest as PR
import BaseTypes.Comment as CM
import BaseTypes.TaskTypes as TT
import Errors.ErrorMessages
import Data.Maybe (isNothing)

import qualified Data.Aeson as Aeson
import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)

import Data.UUID
import Data.UUID.V1 ( nextUUID )

import LoadEnv
import System.Environment (lookupEnv)

insertComment :: Api
insertComment = do
    post "comments" $ do
        body <- jsonBody :: ApiAction (Maybe PR.PostCommentRequest)
        if isNothing body then
            setStatus status400 >> _PARSING_POST_BODY
        else do
            liftIO loadEnv
            maybeUrl <- liftIO (lookupEnv "CHECK_TASK_URL")
            let (Just url) = maybeUrl
            let (Just sanitizeBody) = body
            let boardId = PR.boardId sanitizeBody
            let taskId = PR.taskId sanitizeBody

            initReq <- liftIO $ parseRequest (url ++ "/" ++ boardId ++ "/" ++ taskId)
            let req = initReq { method = "GET" }
            response <- httpLBS req
            let resCode = getResponseStatusCode response

            if resCode == 404 then do
                setStatus status404 >> _BOARD_NOT_FOUND
            else if resCode > 200 then do
                setStatus status500 >> _INTERNAL_SERVER_ERROR
            else do 
                let jsonBody = getResponseBody response
                let decodedBody = Aeson.decode jsonBody :: Maybe TT.Response
                case decodedBody of
                    Nothing -> do setStatus status404 >> _BOARD_NOT_FOUND
                    Just _ -> do
                        uuid <- liftIO nextUUID
                        let (Just sanitizedUUID) = uuid
                        let strUUID = toString sanitizedUUID

                        let comment = CM.Comment {
                            CM.content   = PR.content sanitizeBody,
                            CM.taskId    = taskId,
                            CM.boardId   = boardId,
                            CM.commentId = strUUID
                        }

                        insertedComment <- liftIO $ MongoOperations.insertComment comment
                        setStatus status201 >> json insertedComment
