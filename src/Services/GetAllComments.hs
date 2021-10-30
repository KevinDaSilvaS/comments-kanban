{-# LANGUAGE OverloadedStrings #-}

module Services.GetAllComments where

import Web.Spock

import BaseTypes.Comment
import BaseTypes.SpockApi ( Api, ApiAction )

import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)

import Response.Response as Res
import Network.HTTP.Types
import Database.MongoDB ( Pipe, Database )
import Data.Text as T
    
getAllComments :: (Pipe, Database) -> Api
getAllComments connection = do
    get ("comments" <//> var) $ \taskId -> do
        let pr = param ("comments", var) (T.pack "limit")
        print pr
        comments <- liftIO $ MongoOperations.getAllComments connection taskId
        Res.response (statusCode status200) comments