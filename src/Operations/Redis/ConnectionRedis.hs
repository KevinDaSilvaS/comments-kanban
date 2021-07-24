{-# LANGUAGE OverloadedStrings #-}
module Operations.Redis.ConnectionRedis (connectRedis) where
  
import Database.Redis 
import LoadEnv ( loadEnv )
import System.Environment (lookupEnv)
import Control.Monad.Trans (liftIO)
import qualified Data.ByteString.Char8 as CHAR8

connectionString = do 
  loadEnv
  (Just redisHost) <- lookupEnv "REDIS_HOST"
  (Just redisPort) <- lookupEnv "REDIS_PORT"
  (Just redisDatabase) <- lookupEnv "REDIS_DATABASE"
  (Just redisMaxConnections) <- lookupEnv "REDIS_MAX_CONNECTIONS"
  (Just redisAuth) <- lookupEnv "REDIS_PASSWORD"

  return ConnInfo
    { 
        connectHost = redisHost
      , connectPort = PortNumber (read redisPort) 
      , connectAuth =  Just $ CHAR8.pack redisAuth
      , connectDatabase = read redisDatabase
      , connectMaxConnections = read redisMaxConnections
      , connectMaxIdleTime = 30
      , connectTimeout = Nothing
      , connectTLSParams = Nothing
    }

connectRedis = do 
  connString <- liftIO connectionString
  connect connString