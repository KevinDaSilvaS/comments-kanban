{-# LANGUAGE OverloadedStrings #-}

module Services.Integrations.MiniKanban.GetTaskInfo where

import Network.HTTP.Simple
import Network.HTTP.Conduit

import qualified BaseTypes.PostRequest as PR

import Control.Monad.Trans (liftIO)

import LoadEnv
import System.Environment (lookupEnv)
import qualified Data.ByteString.Char8 as CHAR8
import Operations.Redis.RedisOperations

getTaskInfo body connectionRedis = do
    liftIO loadEnv
    maybeUrl <- liftIO (lookupEnv "CHECK_TASK_URL")
    let (Just url) = maybeUrl
    let (Just sanitizeBody) = body
    let boardId = PR.boardId sanitizeBody
    let taskId = PR.taskId sanitizeBody
    let baseUri = boardId ++ "/" ++ taskId
    let redisBaseKey = CHAR8.pack baseUri

    keyFound <- getKey connectionRedis redisBaseKey
    case keyFound of
        Right (Just x) -> do 
            return (read (CHAR8.unpack x) :: Int)
        _ -> do
                initReq <- liftIO $ 
                    parseRequest (url ++ "/" ++ baseUri)
                let req = initReq { method = "GET" }
                response <- httpLBS req

                let resCode = getResponseStatusCode response

                setKey connectionRedis 
                    redisBaseKey 
                    (CHAR8.pack $ show resCode) 
                    1800
                return resCode