{-# LANGUAGE OverloadedStrings #-}

module Services.GetComment where

import Web.Spock

import BaseTypes.Comment
    ( Comment(Comment, content, taskId, commentId, boardId) )
import BaseTypes.SpockApi ( Api, ApiAction )

import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)

import Response.Response as Res
import Network.HTTP.Types
import Errors.ErrorMessages

getComment :: Api
getComment = do
    get ("comments" <//> var <//> var) $ \taskId commentId -> do
        comment <- liftIO $ MongoOperations.getComment taskId commentId
        if null comment then
            setStatus status404 >> _COMMENT_NOT_FOUND
        else
            Res.responseSimple (statusCode status200) (Prelude.head comment)