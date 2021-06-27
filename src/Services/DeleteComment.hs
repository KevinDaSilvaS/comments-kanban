{-# LANGUAGE OverloadedStrings #-}

module Services.DeleteComment where

import Web.Spock
import Network.HTTP.Types

import BaseTypes.SpockApi ( Api, ApiAction )
import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)
import Database.MongoDB ( Pipe, Database )
import Network.AMQP

import Errors.ErrorMessages

deleteComment :: (Pipe, Database) -> Channel -> Api
deleteComment connection chan = do
    delete ("comments" <//> var) $ \commentId -> do
        comment <- liftIO $ MongoOperations.deleteComment 
            connection "commentId" commentId
        case comment of
            Nothing -> setStatus noContent204
            Just _  -> setStatus status400 >> _ERROR_DELETING_COMMENT
    