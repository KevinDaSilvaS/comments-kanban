module Operations.RabbitMq.StartQueue where

import Network.AMQP
import Data.Text (pack)

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