{-# LANGUAGE OverloadedStrings #-}

module Services.Integrations.MiniKanban.GetTaskInfo where

import Network.HTTP.Simple
import Network.HTTP.Conduit

import qualified BaseTypes.PostRequest as PR
import BaseTypes.TaskTypes as TT

import qualified Data.Aeson as Aeson
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
    let jsonBody = getResponseBody response
    let decodedBody = Aeson.decode jsonBody :: Maybe TT.Response

    case decodedBody of
        Nothing -> do return (resCode, 404)
        Just responseData -> do return (resCode, code responseData)