{-# LANGUAGE OverloadedStrings #-}

module Operations.Mongolia.InsertComment where
    
import Network.HTTP.Simple
import Network.HTTP.Conduit
import qualified Data.Aeson as Aeson
import Data.ByteString.Char8 as BT
import qualified BaseTypes.PostRequest as PR

import BaseTypes.Mongolia.InsertTypes

insertComment body = do
    token <- BT.readFile "../../../token.env"

    initReq <- parseRequest "http://localhost:3170/collections/comments"
    let req = initReq { 
            method = "POST",
            requestBody = RequestBodyLBS 
                $ Aeson.encode body,
            requestHeaders =
                [ ("Content-Type", "application/json; charset=utf-8"),
                  ("mongolia_auth_token", token)
                ]
        }
    response <- httpLBS req

    let status = getResponseStatusCode response
    --if status == 201 then do
    let jsonBody = getResponseBody response
        {- let (Just decodedBody) = Aeson.decode jsonBody :: Maybe InsertResponse
        let commentId = serializeInsert decodedBody
        return commentId -}
    print jsonBody
    --else
        --return "Error"
        --error "Error Authenticating"
   