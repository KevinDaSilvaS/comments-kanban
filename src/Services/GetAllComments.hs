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
import Logger.Styles(_info, _green)

getAllComments :: (Pipe, Database) -> ([Char] -> [Char] -> IO ()) -> Api
getAllComments connection _logger = do
    get ("comments" <//> var) $ \taskId -> do
        liftIO $ _logger _info ( "[GET - Get all comments] taskId/ " ++ taskId)

        maybePage  <- param "page" 
        maybeLimit <- param "limit"
        let page  = obtainPage maybePage
        let limit = obtainLimit maybeLimit
        comments <- liftIO $ MongoOperations.getAllComments connection taskId (page*limit) limit

        liftIO $ _logger _green "[GET 200 - Get all comments]"
        Res.response (statusCode status200) comments                