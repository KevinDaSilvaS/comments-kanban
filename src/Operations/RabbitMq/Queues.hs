module Operations.RabbitMq.Queues where

import Operations.RabbitMq.Callbacks
    ( callbackCommentsWhenTaskOrBoardIsDeleted )
   
import Network.AMQP ( Envelope, Message ) 
import Database.MongoDB ( Pipe, Database )
import Database.Redis

queuesListConsumers :: [([Char],
  (Pipe, Database)
  -> Connection -> (Network.AMQP.Message, Envelope) -> IO (),
  [Char], [Char], [Char])]
queuesListConsumers = [
    ("comments-service-delete-all-comments-when-task-or-board-is-deleted",
    callbackCommentsWhenTaskOrBoardIsDeleted,
    "topic-Mini-Kanban",
    "topic",
    "com.*")
    ]

queuesListPublishers = []