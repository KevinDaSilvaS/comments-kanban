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
import Logger.Logger(startLogger, logger)
import Logger.Styles(_info)

main :: IO ()
main = do
    mvar <- startLogger
    let _logger = logger mvar

    conn <- connectionAmqpBroker
    chan <- channelAmqpBroker conn
    connectBroker conn chan
    spockCfg <- defaultSpockCfg () PCNoDatabase ()
    runSpock 8835 (spock spockCfg (app _logger))

app :: ([Char] -> [Char] -> IO ()) -> Api
app _logger = do
    liftIO $ _logger _info "Server started"

    conn      <- liftIO connection
    connRedis <- liftIO connectRedis
    middleware simpleCors
    
    getComment conn _logger

    getAllComments conn

    deleteComment conn

    insertComment conn connRedis

    updateComment conn