module Main where

import Web.Spock
import Web.Spock.Config

import GHC.Generics

import BaseTypes.SpockApi ( Api, ApiAction )

import Services.GetComment     ( getComment )
import Services.GetAllComments ( getAllComments )
import Services.InsertComment  ( insertComment )
import Services.DeleteComment  ( deleteComment )
import Services.UpdateComment  ( updateComment )

import Network.Wai.Middleware.Cors
import Operations.Mongolia.Auth
import Operations.Mongolia.CreateCollection

main :: IO ()
main = do
    authRequest <- auth
    collectionCreationRequest <- createCollections
    spockCfg <- defaultSpockCfg () PCNoDatabase ()
    runSpock 8835 (spock spockCfg app)

app :: Api
app = do
    middleware simpleCors
    
    getComment

    getAllComments

    deleteComment

    insertComment

    updateComment