{-# LANGUAGE OverloadedStrings #-}

module Services.GetAllComments where

import Web.Spock ( var, (<//>), get, param )

import BaseTypes.Comment
import BaseTypes.SpockApi ( Api, ApiAction )

import Operations.Mongo.MongoDBOperations as MongoOperations ( getAllComments )
import Control.Monad.Trans (liftIO)

import Response.Response as Res
import Network.HTTP.Types
import Database.MongoDB ( Pipe, Database, Limit )

getAllComments :: (Pipe, Database) -> Api
getAllComments connection = do
    let defaultLimit = 50
    let defaultPage  = 1
    get ("comments" <//> var) $ \taskId -> do
        maybePage  <- param "page" 
        maybeLimit <- param "limit"
        case maybePage of
            Just page -> do
                case maybeLimit of
                    Just limit -> do 
                        comments <- fetchResults 
                            connection taskId ((page-1)*limit) limit
                        Res.response (statusCode status200) comments
                    _ -> do
                        comments <- fetchResults
                            connection taskId ((page-1)*defaultLimit) defaultLimit
                        Res.response (statusCode status200) comments
            _ -> do
                comments <- 
                    fetchResults connection taskId defaultPage defaultLimit
                Res.response (statusCode status200) comments
                
fetchResults connection taskId page limit = 
    liftIO $ MongoOperations.getAllComments connection taskId page limit