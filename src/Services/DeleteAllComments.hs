{-# LANGUAGE OverloadedStrings #-}

module Services.DeleteAllComments where

import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)
import Operations.Mongo.ConnectionMongoDB
import Database.MongoDB ( Pipe, Database )

deleteAllComments :: (Pipe, Database) -> String -> String -> IO ()
deleteAllComments connection field value = do
    liftIO $ MongoOperations.deleteComment connection field value
    putStrLn $ "Processed " ++ value