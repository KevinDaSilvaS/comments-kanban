{-# LANGUAGE OverloadedStrings #-}

module Services.DeleteAllComments where

import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)

deleteAllComments taskId = do
    liftIO $ MongoOperations.deleteComment taskId
    putStrLn $ "Processed" ++ taskId