{-# LANGUAGE OverloadedStrings #-}

module Services.DeleteAllComments where

import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)

deleteAllComments field value = do
    liftIO $ MongoOperations.deleteComment field value
    putStrLn $ "Processed " ++ value