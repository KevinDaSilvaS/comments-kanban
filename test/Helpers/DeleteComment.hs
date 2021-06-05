{-# LANGUAGE OverloadedStrings #-}

module Helpers.DeleteComment where

import BaseTypes.Comment
import qualified Data.Aeson as Aeson
import Helpers.ResponseTypes.ErrorResponse (ReqResponseError)
import Helpers.ResponseTypes.SuccessSingleResponse (ReqResponse)
import Network.HTTP.Conduit
import Network.HTTP.Simple
import System.IO ()
import Data.Text (pack)
import LoadEnv
import System.Environment (lookupEnv)

deleteComment :: String -> IO Int
deleteComment commentId = do
  loadEnv
  (Just port) <- lookupEnv "PORT"
  let url = "http://localhost:"++ port ++"/comments/" ++ commentId
  initReq <- parseRequest url
  let req =
        initReq
          { method = "DELETE"}
  response <- httpLBS req

  let status = getResponseStatusCode response
  return status