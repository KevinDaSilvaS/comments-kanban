{-# LANGUAGE OverloadedStrings #-}

module Operations.RabbitMq.ConnectBroker where

import Network.AMQP ( openConnection, openChannel, Connection, Channel )

import Data.Text (pack)

import LoadEnv ( loadEnv )
import System.Environment (lookupEnv)

import Operations.RabbitMq.Queues ( queuesListConsumers, queuesListPublishers )

import Operations.RabbitMq.StartQueue ( startQueue, startConsumer )

import Operations.Mongo.ConnectionMongoDB
import Control.Monad.Trans (liftIO)
import Operations.Redis.ConnectionRedis

connectionAmqpBroker :: IO Connection
connectionAmqpBroker = do
    loadEnv
    (Just rabbitHost) <- lookupEnv "RABBIT_HOST"
    (Just username) <- lookupEnv "RABBIT_USERNAME"
    (Just password) <- lookupEnv "RABBIT_PASSWORD"
    let txtUsername = pack username
    let txtPassword = pack password

    openConnection rabbitHost (pack "/") txtUsername txtPassword

channelAmqpBroker :: Connection -> IO Channel
channelAmqpBroker conn = do openChannel conn
    
connectBroker :: Connection -> Channel -> IO (Connection, Channel)
connectBroker conn chan = do
    connMongo <- liftIO connection
    connRedis <- liftIO connectRedis

    mapM_ (startQueue conn chan) queuesListConsumers
    mapM_ (startConsumer chan connMongo connRedis) queuesListConsumers

    mapM_ (startQueue conn chan) queuesListPublishers
    return (conn, chan)