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
import Helpers.ValidatePagination

getAllComments :: (Pipe, Database) -> Api
getAllComments connection = do
    get ("comments" <//> var) $ \taskId -> do
        maybePage  <- param "page" 
        maybeLimit <- param "limit"
        let page  = obtainPage maybePage
        let limit = obtainLimit maybeLimit
        comments <- liftIO $ MongoOperations.getAllComments connection taskId (page*limit) limit
        Res.response (statusCode status200) comments                