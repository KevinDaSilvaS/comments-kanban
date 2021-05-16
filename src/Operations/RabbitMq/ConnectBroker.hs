{-# LANGUAGE OverloadedStrings #-}

module Operations.RabbitMq.ConnectBroker where

import Network.AMQP ( openConnection )

import Data.Text (pack)

import LoadEnv ( loadEnv )
import System.Environment (lookupEnv)

import Operations.RabbitMq.Queues ( queuesList )

import Operations.RabbitMq.StartQueue ( startQueue )

connectBroker :: IO ()
connectBroker = do
    loadEnv
    (Just rabbitHost) <- lookupEnv "RABBIT_HOST"
    (Just username) <- lookupEnv "RABBIT_USERNAME"
    (Just password) <- lookupEnv "RABBIT_PASSWORD"
    let txtUsername = pack username
    let txtPassword = pack password

    conn <- openConnection rabbitHost (pack "/") txtUsername txtPassword
    let queues = queuesList

    mapM_ (startQueue conn) queues