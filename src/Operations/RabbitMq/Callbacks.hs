module Operations.RabbitMq.Callbacks where

import Network.AMQP ( ackEnv, Envelope, Message(msgBody) )
import BaseTypes.MessageTypes
    ( BodyWhenTaskIsDeletedConsumer(taskId) )
import Data.Aeson ( decode )

import Control.Monad.Trans (liftIO)

import Services.DeleteAllComments ( deleteAllComments )

callbackCommentsWhenTaskIsDeleted :: (Message,Envelope) -> IO ()
callbackCommentsWhenTaskIsDeleted (msg, env) = do
    let decodedMessageBody = 
            decode (msgBody msg) :: Maybe BodyWhenTaskIsDeletedConsumer
                
    case decodedMessageBody of
        Nothing   -> putStrLn "received Nothing from broker"
        Just body -> do 
                    putStrLn $ "received from broker: " ++ show body
                    liftIO $ deleteAllComments (taskId body)
    ackEnv env