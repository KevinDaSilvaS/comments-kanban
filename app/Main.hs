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
import Operations.Redis.ConnectionRedis
import qualified Database.Redis as RD

main :: IO ()
main = do
    conn <- connectionAmqpBroker
    chan <- channelAmqpBroker conn
    connectBroker conn chan
    spockCfg <- defaultSpockCfg () PCNoDatabase ()
    runSpock 8835 (spock spockCfg app)

app :: Api
app = do
    conn <- liftIO connection
    connRedis <- liftIO connectRedis
    middleware simpleCors
    
    getComment conn

    getAllComments conn

    deleteComment conn

    insertComment conn connRedis

    updateComment conn