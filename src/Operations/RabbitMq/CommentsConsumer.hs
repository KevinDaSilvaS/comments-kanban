{-# LANGUAGE OverloadedStrings #-}
module Operations.RabbitMq.CommentsConsumer where

import Network.AMQP

{- 
  15691
  15692
  25672
  4369
  5671
  5672
  docker run --rm -it --hostname my-rabbit -p 15672:15672 
  -p 5672:5672 rabbitmq:3-management
-}

import qualified Data.ByteString.Lazy.Char8 as BL

import Data.Text (pack)

import Control.Monad.Trans (liftIO)

import Services.DeleteAllComments

import LoadEnv
import System.Environment (lookupEnv)
import qualified Data.Text as T

queuesList = [
    ("comments-service-delete-all-comments-when-task-is-deleted",
    callbackCommentsWhenTaskIsDeleted)
    ]

connectBroker = do
    loadEnv
    (Just rabbitHost) <- lookupEnv "RABBIT_HOST"
    (Just username) <- lookupEnv "RABBIT_USERNAME"
    (Just password) <- lookupEnv "RABBIT_PASSWORD"
    let txtUsername = T.pack username
    let txtPassword = T.pack password

    conn <- openConnection rabbitHost (pack "/") txtUsername txtPassword
    let queues = queuesList

    mapM_ (startQueue conn) queues

startQueue conn queueInfo = do

    let queueName = fst queueInfo
    let queueCallback = snd queueInfo
    chan <- openChannel conn
    declareQueue chan newQueue {queueName = pack queueName}

    declareExchange chan newExchange {
        exchangeName = pack "topic-Mini-Kanban",
        exchangeType = pack "topic"}
    bindQueue chan (pack queueName) (pack "topic-Mini-Kanban") (pack "com.*")

    consumeMsgs chan (pack queueName) Ack queueCallback

callbackCommentsWhenTaskIsDeleted :: (Message,Envelope) -> IO ()
callbackCommentsWhenTaskIsDeleted (msg, env) = do
    let message = BL.unpack (msgBody msg)
    putStrLn $ "received from comments-service: "++message
    liftIO $ deleteAllComments message
    ackEnv env