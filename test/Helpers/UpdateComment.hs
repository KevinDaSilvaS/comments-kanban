{-# LANGUAGE OverloadedStrings #-}

module Helpers.UpdateComment where

import BaseTypes.Comment
import qualified Data.Aeson as Aeson
import Helpers.ResponseTypes.ErrorResponse (ReqResponseError)
import Helpers.ResponseTypes.SuccessSingleResponse (ReqResponse)
import Network.HTTP.Conduit
import Network.HTTP.Simple
import System.IO ()
import Data.Text (pack)

updateComment :: String -> IO Int
updateComment commentId = do
  initReq <- parseRequest ("http://localhost:8835/comments/" ++ commentId)
  let req =
        initReq
          { method = "PATCH",
            requestBody =
              RequestBodyLBS $ Aeson.encode 
                $ Aeson.object [ ("content", "content") ]
          }
  response <- httpLBS req

  let status = getResponseStatusCode response
  return status

updateCommentError :: String -> String -> String -> IO (Int, Maybe ReqResponseError)
updateCommentError commentId field value = do
  initReq <- parseRequest ("http://localhost:8835/comments/" ++ commentId)
  let req =
        initReq
          { method = "PATCH",
            requestBody =
              RequestBodyLBS $ Aeson.encode 
                $ Aeson.object
                    [ (pack field) Aeson..= (value :: String) ]
          }
  response <- httpLBS req

  let status = getResponseStatusCode response
  let jsonBody = getResponseBody response
  let decodedBody = Aeson.decode jsonBody :: Maybe ReqResponseError
  return (status, decodedBody)