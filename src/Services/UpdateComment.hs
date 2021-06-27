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

updateComment :: (Pipe, Database) -> Api
updateComment connection = do
    patch ("comments" <//> var) $ \commentId -> do
        body <- jsonBody :: ApiAction (Maybe PATCHR.PatchCommentRequest)
        case body of
            Nothing -> setStatus status400 >> _PARSING_PATCH_BODY
            Just patchPayload -> do 
                comment <- liftIO $ MongoOperations.updateComment 
                    connection commentId (PATCHR.content patchPayload)
                case comment of
                    Nothing -> setStatus noContent204
                    Just _  -> setStatus status400 >> _ERROR_UPDATING_COMMENT