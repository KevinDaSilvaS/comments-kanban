{-# LANGUAGE OverloadedStrings #-}
module Operations.Redis.RedisOperations where

import Database.Redis ( del, 
    get, keys, setex, runRedis, 
    Connection, Reply, Status )

import Data.ByteString ( ByteString )

setKey :: Connection -> ByteString -> ByteString -> Integer -> IO (Either Reply Status)
setKey connection key value expirationSeconds = do
    runRedis connection $
        setex key expirationSeconds value

getKey :: Connection -> ByteString -> IO (Either Reply (Maybe ByteString))
getKey connection key = do runRedis connection $ get key

removeKeysByPattern :: Connection -> ByteString -> IO (Either Reply Integer)
removeKeysByPattern connection pattern = do
    matchedKeys <- runRedis connection $ keys pattern
    case matchedKeys of
        Right x -> runRedis connection $ del x
        _ -> error "Error fetching keys"