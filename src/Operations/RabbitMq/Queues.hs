module Operations.RabbitMq.Queues where

import Operations.RabbitMq.Callbacks
    ( callbackCommentsWhenTaskIsDeleted )
   
import Network.AMQP ( Envelope, Message ) 

queuesList :: [(String, (Message, Envelope) -> IO ())]
queuesList = [
    ("comments-service-delete-all-comments-when-task-is-deleted",
    callbackCommentsWhenTaskIsDeleted)
    ]