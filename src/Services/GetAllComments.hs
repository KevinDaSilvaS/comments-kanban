{-# LANGUAGE OverloadedStrings #-}

module Services.GetAllComments where

import Web.Spock

import BaseTypes.Comment
import BaseTypes.SpockApi ( Api, ApiAction )

import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)
    
getAllComments :: Api
getAllComments = do
    get ("comments" <//> var) $ \taskId -> do
        comments <- liftIO $ MongoOperations.getAllComments taskId
        json comments