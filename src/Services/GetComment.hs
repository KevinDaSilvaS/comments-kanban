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

getComment :: Api
getComment = do
    get ("comments" <//> var <//> var) $ \taskId commentId -> do
        comment <- liftIO $ MongoOperations.getComment taskId commentId
        Res.response (statusCode status200) comment