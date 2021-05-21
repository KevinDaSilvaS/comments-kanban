{-# LANGUAGE OverloadedStrings #-}

module Services.Integrations.MiniKanban.GetTaskInfo where

import Network.HTTP.Simple
import Network.HTTP.Conduit

import qualified BaseTypes.PostRequest as PR

import Control.Monad.Trans (liftIO)

import LoadEnv
import System.Environment (lookupEnv)

getTaskInfo body = do
    liftIO loadEnv
    maybeUrl <- liftIO (lookupEnv "CHECK_TASK_URL")
    let (Just url) = maybeUrl
    let (Just sanitizeBody) = body
    let boardId = PR.boardId sanitizeBody
    let taskId = PR.taskId sanitizeBody

    initReq <- liftIO $ parseRequest (url ++ "/" ++ boardId ++ "/" ++ taskId)
    let req = initReq { method = "GET" }
    response <- httpLBS req

    let resCode = getResponseStatusCode response

    return resCode