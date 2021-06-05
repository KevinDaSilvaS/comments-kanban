{-# LANGUAGE OverloadedStrings #-}

module Helpers.InsertComment where

import BaseTypes.Comment
import qualified Data.Aeson as Aeson
import Network.HTTP.Conduit
import Network.HTTP.Simple
import System.IO ()

import Helpers.ResponseTypes.SuccessSingleResponse (ReqResponse)
import Helpers.ResponseTypes.ErrorResponse (ReqResponseError)

import LoadEnv
import System.Environment (lookupEnv)

insertComment :: String -> IO (Int, Maybe ReqResponse)
insertComment identifier = do
  loadEnv
  (Just port) <- lookupEnv "PORT"
  initReq <- parseRequest ("http://localhost:" ++ port ++ "/comments/")
  let req =
        initReq
          { method = "POST",
            requestBody =
              RequestBodyLBS $
                Aeson.encode $
                  Aeson.object
                    [ ("content", "content"),
                      "taskId" Aeson..= (identifier :: String),
                      "boardId" Aeson..= (identifier :: String)
                    ]
          }
  response <- httpLBS req

  let status = getResponseStatusCode response
  let jsonBody = getResponseBody response
  let decodedBody = Aeson.decode jsonBody :: Maybe ReqResponse
  return (status, decodedBody)

insertCommentError :: String -> IO (Int, Maybe ReqResponseError)
insertCommentError identifier = do
  loadEnv
  (Just port) <- lookupEnv "PORT"
  initReq <- parseRequest ("http://localhost:" ++ port ++ "/comments/")
  let req =
        initReq
          { method = "POST",
            requestBody =
              RequestBodyLBS $
                Aeson.encode $
                  Aeson.object
                    [ ("content", "content"),
                      "taskId" Aeson..= (identifier :: String),
                      "boardId" Aeson..= (identifier :: String)
                    ]
          }
  response <- httpLBS req

  let status = getResponseStatusCode response
  let jsonBody = getResponseBody response
  let decodedBody = Aeson.decode jsonBody :: Maybe ReqResponseError
  return (status, decodedBody)