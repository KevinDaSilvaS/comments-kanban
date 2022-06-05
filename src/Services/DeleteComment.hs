{-# LANGUAGE OverloadedStrings #-}

module Services.DeleteComment where

import Web.Spock
import Network.HTTP.Types

import BaseTypes.SpockApi ( Api, ApiAction )
import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)
import Database.MongoDB ( Pipe, Database )

import Errors.ErrorMessages
import Logger.Styles(_info, _error, _green)

deleteComment :: (Pipe, Database) -> ([Char] -> [Char] -> IO ()) -> Api
deleteComment connection _logger = do
    delete ("comments" <//> var) $ \commentId -> do
        liftIO $ _logger _info ("[DELETE - Delete one comment] commentId " ++ commentId)
        comment <- liftIO $ MongoOperations.deleteComment 
            connection "commentId" commentId
        case comment of
            Nothing -> do 
                liftIO $ _logger _green "[DELETE 204 - Comment deleted]"
                setStatus noContent204
            Just _  -> do
                liftIO $ _logger _error "[DELETE 400 - Error deleting comment]"
                setStatus status400 >> _ERROR_DELETING_COMMENT
    