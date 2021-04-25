{-# LANGUAGE OverloadedStrings #-}

module Operations.Mongolia.CreateCollection where

import Network.HTTP.Simple
import Network.HTTP.Conduit
import qualified Data.Aeson as Aeson

import Data.ByteString.Char8 as BT

createCollections = do
    token <- BT.readFile "../token.env"
    
    initReq <- parseRequest "http://localhost:3170/collections" {- "http://httpbin.org/post" -}
    
    let defaultField = Aeson.object
                [ 
                "type" Aeson..= ("String" :: String),
                "required" Aeson..= (True :: Bool)
                ]

    let properties = Aeson.object
                [ 
                "taskId"  Aeson..= (defaultField :: Aeson.Value),
                "boardId" Aeson..= (defaultField :: Aeson.Value),
                "content" Aeson..= (defaultField :: Aeson.Value)
                ]

    let requestObject = Aeson.object
              [ 
                "collectionName" Aeson..= ("comments" :: String),
                "collectionProperties" Aeson..= (properties :: Aeson.Value)
              ]
    
    let req = initReq { 
      method = "POST",
      requestBody = RequestBodyLBS $ Aeson.encode requestObject,
      requestHeaders =
        [ ("Content-Type", "application/json; charset=utf-8"),
          ("mongolia_auth_token", token)
        ]
    }
    
    response <- httpLBS req
    let status = getResponseStatusCode response
    if status == 204 then
        print status
    else do
        error "Error Creating Collections"