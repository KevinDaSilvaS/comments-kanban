module Operations.RabbitMq.StartQueue where

import Network.AMQP
import Data.Text (pack)

startQueue conn chan (queueName, _, exchange, mode, _) = do
    declareQueue chan newQueue {queueName = pack queueName}
    
    declareExchange chan newExchange {
        exchangeName = pack exchange,
        exchangeType = pack mode}

    return chan
    
startConsumer chan connMongo connRedis (queueName, queueCallback, exchange, _, routing) = do 
    bindQueue chan  (pack queueName) (pack exchange) (pack routing)

    consumeMsgs chan (pack queueName) Ack (queueCallback connMongo connRedis)