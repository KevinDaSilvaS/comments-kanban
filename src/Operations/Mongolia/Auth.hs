{-# LANGUAGE OverloadedStrings #-}

module Operations.Mongolia.Auth where

import Network.HTTP.Simple
import Network.HTTP.Conduit
import qualified Data.Aeson as Aeson

import System.IO ()
import BaseTypes.Mongolia.AuthTypes

auth = do
    initReq <- parseRequest ("http://localhost:3170/auth")
    let req = initReq { 
            method = "POST",
            requestBody = RequestBodyLBS 
                $ Aeson.encode 
                $ Aeson.object [
                    ("username", "kevin"), 
                    ("password", "kevin")],
            requestHeaders =
                [ ("Content-Type", "application/json; charset=utf-8")
                ]
        }
    response <- httpLBS req

    let status = getResponseStatusCode response
    if status == 201 then do
        let jsonBody = getResponseBody response
        let (Just decodedBody) = Aeson.decode jsonBody :: Maybe AuthResponse
        let token = serializeAuth decodedBody
        writeFile "../token.env" (token)
    else
        error "Error Authenticating"    