{-# LANGUAGE OverloadedStrings #-}

module Services.DeleteAllComments where

import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)
import Operations.Mongo.ConnectionMongoDB

deleteAllComments field value = do
    conn <- liftIO connection
    liftIO $ MongoOperations.deleteComment conn field value
    putStrLn $ "Processed " ++ value