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

import Operations.RabbitMq.ConnectBroker
import Network.AMQP
import Operations.Mongo.ConnectionMongoDB
import Control.Monad.Trans (liftIO)

main :: IO ()
main = do
    conn <- connectionAmqpBroker
    chan <- channelAmqpBroker conn
    connectBroker conn chan
    spockCfg <- defaultSpockCfg () PCNoDatabase ()
    runSpock 8835 (spock spockCfg (app chan))

app :: Channel -> Api
app chan = do
    conn <- liftIO connection
    middleware simpleCors
    
    getComment conn chan

    getAllComments conn chan

    deleteComment conn chan

    insertComment conn chan

    updateComment conn chan