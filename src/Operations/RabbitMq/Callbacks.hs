module Operations.RabbitMq.Callbacks where

import Network.AMQP ( ackEnv, Envelope, Message(msgBody) )
import BaseTypes.MessageTypes
import Data.Aeson ( decode )

import Control.Monad.Trans (liftIO)

import Services.DeleteAllComments ( deleteAllComments )
import Database.MongoDB ( Pipe, Database )
import Operations.Redis.RedisOperations ( removeKeysByPattern )
import qualified Data.ByteString.Char8 as CHAR8

callbackCommentsWhenTaskOrBoardIsDeleted connMongo connRedis (msg, env) = do
    let decodedMessageBody = 
            decode (msgBody msg) :: Maybe BodyWhenTaskIsDeletedConsumer
                
    case decodedMessageBody of
        Nothing   -> do

            let decodedMessageBody = 
                    decode (msgBody msg) :: Maybe BodyWhenBoardIsDeletedConsumer

            case decodedMessageBody of
                Nothing   ->
                    putStrLn "received Nothing from broker"
                Just body -> do 
                    putStrLn $ "received from broker: " ++ show body
                    deleteAllComments connMongo "boardId" (boardId body)
                    removeKeysByPattern connRedis 
                            (CHAR8.pack ("*"++boardId body++"*"))
                    return ()
                    
        Just body -> do 
                    putStrLn $ "received from broker: " ++ show body
                    deleteAllComments connMongo "taskId" (taskId body)
                    removeKeysByPattern connRedis 
                        (CHAR8.pack ("*"++taskId body++"*"))
                    return ()
    ackEnv env  