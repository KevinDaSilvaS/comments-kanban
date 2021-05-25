{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Operations.Mongo.ConnectionMongoDB where

import qualified Data.Text as T
import Database.MongoDB
import LoadEnv
import System.Environment (lookupEnv)

connection :: IO (Pipe, T.Text)
connection = do
    loadEnv
    (Just mongoHost) <- lookupEnv "MONGO_HOST"
    (Just dbName)    <- lookupEnv "MONGO_DB_NAME"
    (Just username)  <- lookupEnv "MONGO_USERNAME"
    (Just password)  <- lookupEnv "MONGO_PASSWORD"
    let txtDbName    = T.pack dbName
    let txtUsername  = T.pack username
    let txtPassword  = T.pack password
    
    pipe <- connect (host mongoHost)
    isAuthenticated <- access pipe master txtDbName (auth txtUsername txtPassword)
    if isAuthenticated then do
        return (pipe, txtDbName)
    else
        error "Unable to connect to database"