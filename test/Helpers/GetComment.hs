{-# LANGUAGE OverloadedStrings #-}

module Helpers.GetComment where

import BaseTypes.Comment
import qualified Data.Aeson as Aeson
import Network.HTTP.Conduit
import Network.HTTP.Simple
import System.IO ()

import Helpers.ResponseTypes.SuccessSingleResponse (ReqResponse)
import Helpers.ResponseTypes.SuccessResponse ( ReqResponseArray )

getComment :: String -> String -> IO (Int, Maybe ReqResponse)
getComment taskId commentId = do
  initReq <- parseRequest ("http://localhost:8835/comments/" ++ taskId ++ "/" ++ commentId)
  let req = initReq { method = "GET" }
  response <- httpLBS req

  let status = getResponseStatusCode response
  let jsonBody = getResponseBody response
  let decodedBody = Aeson.decode jsonBody :: Maybe ReqResponse
  return (status, decodedBody)

getAllComments :: String -> IO (Int, Maybe ReqResponseArray)
getAllComments taskId = do
    initReq <- parseRequest ("http://localhost:8835/comments/" ++ taskId)
    let req = initReq { method = "GET" }
    response <- httpLBS req
  
    let status = getResponseStatusCode response
    let jsonBody = getResponseBody response
    let decodedBody = Aeson.decode jsonBody :: Maybe ReqResponseArray
    return (status, decodedBody)
