module Operations.RabbitMq.Callbacks where

import Network.AMQP ( ackEnv, Envelope, Message(msgBody) )
import BaseTypes.MessageTypes
    {- ( BodyWhenTaskIsDeletedConsumer(taskId) ) -}
import Data.Aeson ( decode )

import Control.Monad.Trans (liftIO)

import Services.DeleteAllComments ( deleteAllComments )
import Database.MongoDB ( Pipe, Database )

callbackCommentsWhenTaskOrBoardIsDeleted :: (Pipe, Database) -> (Message,Envelope) -> IO ()
callbackCommentsWhenTaskOrBoardIsDeleted connMongo (msg, env) = do
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
                    liftIO $ deleteAllComments connMongo "boardId" (boardId body)
                    
        Just body -> do 
                    putStrLn $ "received from broker: " ++ show body
                    liftIO $ deleteAllComments connMongo "taskId" (taskId body)
    ackEnv env