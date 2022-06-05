{-# LANGUAGE OverloadedStrings #-}

module Services.UpdateComment where

import Web.Spock
import Network.HTTP.Types
    
import BaseTypes.SpockApi ( Api, ApiAction )
import qualified BaseTypes.PatchRequest as PATCHR

import Errors.ErrorMessages
import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)
import Database.MongoDB ( Pipe, Database )
import Logger.Styles(_info, _error, _green)

updateComment :: (Pipe, Database) -> ([Char] -> [Char] -> IO()) -> Api
updateComment connection _logger = do
    patch ("comments" <//> var) $ \commentId -> do
        liftIO $ _logger _info "[PATCH - Update comment]"
        body <- jsonBody :: ApiAction (Maybe PATCHR.PatchCommentRequest)
        case body of
            Nothing -> do 
                liftIO $ _logger _error "[POST 400 - Error parsing request body]"
                setStatus status400 >> _PARSING_PATCH_BODY
            Just patchPayload -> do 
                comment <- liftIO $ MongoOperations.updateComment 
                    connection commentId (PATCHR.content patchPayload)
                case comment of
                    Nothing -> do
                        liftIO $ _logger _green "[POST 204 - Comment updated]"
                        setStatus noContent204
                    Just _  -> do
                        liftIO $ _logger _error "[POST 400 - Error updating comment]"
                        setStatus status400 >> _ERROR_UPDATING_COMMENT