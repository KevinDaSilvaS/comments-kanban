module Operations.RabbitMq.PublishMessage where
    
import Network.AMQP

publishMessage chan (logsExchange, severity) body = do
    publishMsg chan logsExchange severity
                (newMsg {
                    msgBody = body,
                    msgDeliveryMode = Just Persistent
                })

    