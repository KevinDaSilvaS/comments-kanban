{-# LANGUAGE OverloadedStrings #-}

module Services.InsertComment where

import Web.Spock
import Network.HTTP.Types
import Network.HTTP.Simple

import BaseTypes.SpockApi ( Api, ApiAction )
import qualified BaseTypes.PostRequest as PR
import Errors.ErrorMessages
import Data.Maybe (isNothing)
import BaseTypes.Mongolia.GetTypes

import qualified Data.Aeson as Aeson
import Operations.Mongo.MongoDBOperations
import Control.Monad.Trans (liftIO)

insertComment :: Api
insertComment = do
    post "comments" $ do
        body <- jsonBody :: ApiAction (Maybe PR.PostCommentRequest)
        if isNothing body then
            setStatus status400 >> _PARSING_POST_BODY
        else do
            response <- httpLBS "http://httpbin.org/get"
            let code = getResponseStatusCode response

            if code == 200 then do
                r <- liftIO $ server
                setStatus status201 >> json r
            else if code == 404 then
                setStatus status404 >> _BOARD_NOT_FOUND
            else
                setStatus status500 >> _INTERNAL_SERVER_ERROR
