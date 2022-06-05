{-# LANGUAGE OverloadedStrings #-}

module Services.GetComment where

import Web.Spock(get, (<//>), var, setStatus)

import BaseTypes.Comment
    ( Comment(Comment, content, taskId, commentId, boardId) )
import BaseTypes.SpockApi ( Api, ApiAction )

import Operations.Mongo.MongoDBOperations as MongoOperations
import Control.Monad.Trans (liftIO)

import Response.Response as Res
import Network.HTTP.Types
import Errors.ErrorMessages
import Database.MongoDB ( Pipe, Database )
import Logger.Styles(_info, _error, _green)

getComment :: (Pipe, Database) -> ([Char] -> [Char] -> IO ()) -> Api
getComment connection _logger = do
    get ("comments" <//> var <//> var) $ \taskId commentId -> do
        let _log = ("[GET - Get one comment] taskId/commentId " ++ taskId ++ "/" ++ commentId)
        liftIO $ _logger _info _log

        comment <- liftIO $ MongoOperations.getComment 
            connection taskId commentId

        case null comment of
            True -> do
                liftIO $ _logger _error "[GET 404 - Get one comment] Comment not found"
                setStatus status404 >> _COMMENT_NOT_FOUND
            _ -> do
                liftIO $ _logger _green "[GET 200 - Get one comment] Comment found"
                Res.responseSimple (statusCode status200) (head comment)