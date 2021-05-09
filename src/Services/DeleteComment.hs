{-# LANGUAGE OverloadedStrings #-}

module Services.DeleteComment where

import Web.Spock
import Network.HTTP.Types

import BaseTypes.SpockApi ( Api, ApiAction )
import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)

deleteComment :: Api
deleteComment = do
    delete ("comments" <//> var) $ \commentId -> do
        comment <- liftIO $ MongoOperations.deleteComment commentId
        setStatus noContent204
    