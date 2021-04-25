{-# LANGUAGE OverloadedStrings #-}

module Services.UpdateComment where

import Web.Spock
import Network.HTTP.Types
    
import BaseTypes.SpockApi ( Api, ApiAction )
import qualified BaseTypes.PatchRequest as PATCHR

import Errors.ErrorMessages

updateComment :: Api
updateComment = do
    patch ("comments" <//> var) $ \commentId -> do
        let v = commentId ++ "!"
        body <- jsonBody :: ApiAction (Maybe PATCHR.PatchCommentRequest)
        case body of
            Nothing -> setStatus status400 >> _PARSING_PATCH_BODY
            Just patchPayload -> do 
                setStatus noContent204