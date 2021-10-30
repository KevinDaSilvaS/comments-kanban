{-# LANGUAGE OverloadedStrings #-}

module Helpers.GetComment where

import BaseTypes.Comment
import qualified Data.Aeson as Aeson
import Network.HTTP.Conduit
import Network.HTTP.Simple
import System.IO ()

import Helpers.ResponseTypes.SuccessSingleResponse ( ReqResponse )
import Helpers.ResponseTypes.SuccessResponse ( ReqResponseArray )
import Helpers.ResponseTypes.ErrorResponse ( ReqResponseError )
import LoadEnv
import System.Environment (lookupEnv)

getComment :: String -> String -> IO (Int, Maybe ReqResponse)
getComment taskId commentId = do
  loadEnv
  (Just port) <- lookupEnv "PORT"
  let url = "http://localhost:" ++ port ++ 
        "/comments/" ++ taskId ++ "/" ++ commentId

  initReq <- parseRequest url
  let req = initReq { method = "GET" }
  response <- httpLBS req

  let status = getResponseStatusCode response
  let jsonBody = getResponseBody response
  let decodedBody = Aeson.decode jsonBody :: Maybe ReqResponse
  return (status, decodedBody)

getCommentError :: String -> String -> IO (Int, Maybe ReqResponseError)
getCommentError taskId commentId = do
  loadEnv
  (Just port) <- lookupEnv "PORT"
  let url = "http://localhost:" ++ port ++ "/comments/" 
        ++ taskId ++ "/" ++ commentId
        
  initReq <- parseRequest url
  let req = initReq { method = "GET" }
  response <- httpLBS req
  
  let status = getResponseStatusCode response
  let jsonBody = getResponseBody response
  let decodedBody = Aeson.decode jsonBody :: Maybe ReqResponseError
  return (status, decodedBody)

getAllComments :: String -> IO (Int, Maybe ReqResponseArray)
getAllComments taskId = do
    loadEnv
    (Just port) <- lookupEnv "PORT"
    let url = "http://localhost:" ++ port ++ "/comments/" ++ taskId

    initReq <- parseRequest url
    let req = initReq { method = "GET" }
    response <- httpLBS req
  
    let status = getResponseStatusCode response
    let jsonBody = getResponseBody response
    let decodedBody = Aeson.decode jsonBody :: Maybe ReqResponseArray
    return (status, decodedBody)

getAllCommentsPaginated taskId page limit = do
    loadEnv
    (Just port) <- lookupEnv "PORT"
    let queryParams = "?page=" ++ show page ++ "&limit=" ++ show limit
    let url = "http://localhost:" ++ port ++ "/comments/" ++ taskId ++ queryParams
    
    initReq <- parseRequest url
    let req = initReq { method = "GET" }
    response <- httpLBS req
      
    let status = getResponseStatusCode response
    let jsonBody = getResponseBody response
    let decodedBody = Aeson.decode jsonBody :: Maybe ReqResponseArray
    return (status, decodedBody)