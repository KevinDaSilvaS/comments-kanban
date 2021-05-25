module Operations.RabbitMq.Queues where

import Operations.RabbitMq.Callbacks
    ( callbackCommentsWhenTaskOrBoardIsDeleted )
   
import Network.AMQP ( Envelope, Message ) 
import Database.MongoDB ( Pipe, Database )

queuesList :: [([Char], (Pipe, Database) -> (Message, Envelope) -> IO ())]
queuesList = [
    ("comments-service-delete-all-comments-when-task-or-board-is-deleted",
    callbackCommentsWhenTaskOrBoardIsDeleted)
    ]