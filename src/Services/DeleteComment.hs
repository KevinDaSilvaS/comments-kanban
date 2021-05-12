{-# LANGUAGE OverloadedStrings #-}

module Services.DeleteComment where

import Web.Spock
import Network.HTTP.Types

import BaseTypes.SpockApi ( Api, ApiAction )
import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)

import Errors.ErrorMessages

deleteComment :: Api
deleteComment = do
    delete ("comments" <//> var) $ \commentId -> do
        comment <- liftIO $ MongoOperations.deleteComment commentId
        case comment of
            Nothing -> setStatus noContent204
            Just _  -> setStatus status400 >> _ERROR_DELETING_COMMENT
    