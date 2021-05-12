{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Operations.Mongo.MongoDBOperations where

import qualified Data.Text as T
import Database.MongoDB
import Control.Monad.Trans (liftIO)
import Data.AesonBson
import qualified BaseTypes.Comment as Com
import LoadEnv
import System.Environment (lookupEnv)
import Control.Exception 
--https://github.com/mongodb-haskell/mongodb/blob/master/doc/Example.hs
--https://subscription.packtpub.com/book/big_data_and_business_intelligence/9781783286331/1/ch01lvl1sec19/using-mongodb-queries-in-haskell
--https://github.com/mongodb-haskell/mongodb/blob/master/doc/tutorial.md

insertComment body = do
    loadEnv
    (Just mongoHost) <- lookupEnv "MONGO_HOST"
    (Just dbName) <- lookupEnv "MONGO_DB_NAME"
    (Just username) <- lookupEnv "MONGO_USERNAME"
    (Just password) <- lookupEnv "MONGO_PASSWORD"
    let txtDbName = T.pack dbName
    let txtUsername = T.pack username
    let txtPassword = T.pack password

    pipe <- connect (host mongoHost)
    isAuthenticated <- access pipe master txtDbName (auth txtUsername txtPassword)
    if isAuthenticated then do
        insertedCommentId <- access pipe master txtDbName (insertCommentOperation body)
        insertedComment <- access pipe master txtDbName (findMongoOperation ["_id" =: insertedCommentId])
        return $ (aesonify . exclude ["_id"]) $ head insertedComment
    else
        error "Unable to connect to database"

getAllComments taskId = do
    loadEnv
    (Just mongoHost) <- lookupEnv "MONGO_HOST"
    (Just dbName) <- lookupEnv "MONGO_DB_NAME"
    (Just username) <- lookupEnv "MONGO_USERNAME"
    (Just password) <- lookupEnv "MONGO_PASSWORD"
    let txtDbName = T.pack dbName
    let txtUsername = T.pack username
    let txtPassword = T.pack password

    pipe <- connect (host mongoHost)
    isAuthenticated <- access pipe master txtDbName (auth txtUsername txtPassword)
    if isAuthenticated then do
        comments <- access pipe master txtDbName (getAllCommentsOperation taskId)
        return $ map (aesonify . exclude ["_id"]) comments
    else
        error "Unable to connect to database"

getComment taskId commentId = do
    loadEnv
    (Just mongoHost) <- lookupEnv "MONGO_HOST"
    (Just dbName) <- lookupEnv "MONGO_DB_NAME"
    (Just username) <- lookupEnv "MONGO_USERNAME"
    (Just password) <- lookupEnv "MONGO_PASSWORD"
    let txtDbName = T.pack dbName
    let txtUsername = T.pack username
    let txtPassword = T.pack password

    pipe <- connect (host mongoHost)
    isAuthenticated <- access pipe master txtDbName (auth txtUsername txtPassword)
    if isAuthenticated then do
        comment <- access pipe master txtDbName (getOneCommentOperation taskId commentId)
        return $ map (aesonify . exclude ["_id"]) comment
    else
        error "Unable to connect to database"

updateComment commentId content = do
    loadEnv
    (Just mongoHost) <- lookupEnv "MONGO_HOST"
    (Just dbName) <- lookupEnv "MONGO_DB_NAME"
    (Just username) <- lookupEnv "MONGO_USERNAME"
    (Just password) <- lookupEnv "MONGO_PASSWORD"
    let txtDbName = T.pack dbName
    let txtUsername = T.pack username
    let txtPassword = T.pack password

    pipe <- connect (host mongoHost)
    isAuthenticated <- access pipe master txtDbName (auth txtUsername txtPassword)
    if isAuthenticated then do
        updatedComments <- try (access pipe master txtDbName (updateCommentsOperation commentId content)) :: IO (Either SomeException ())
        case updatedComments of
            Left ex -> return $ Just ex
            Right _ -> return Nothing
    else
        error "Unable to connect to database"

deleteComment commentId = do
    loadEnv
    (Just mongoHost) <- lookupEnv "MONGO_HOST"
    (Just dbName) <- lookupEnv "MONGO_DB_NAME"
    (Just username) <- lookupEnv "MONGO_USERNAME"
    (Just password) <- lookupEnv "MONGO_PASSWORD"
    let txtDbName = T.pack dbName
    let txtUsername = T.pack username
    let txtPassword = T.pack password

    pipe <- connect (host mongoHost)
    isAuthenticated <- access pipe master txtDbName (auth txtUsername txtPassword)
    if isAuthenticated then do
        deletedComments <- try $ access pipe master txtDbName (deleteCommentsOperation commentId) :: IO (Either SomeException ())
        case deletedComments of
            Left ex -> return $ Just ex
            Right _ -> return Nothing
    else
        error "Unable to connect to database"

writeFailureErrorStr :: Failure -> Maybe Int
writeFailureErrorStr (WriteFailure _err str "") = Just str
writeFailureErrorStr _other = Nothing
    
findMongoOperation :: Selector -> Action IO [Document]
findMongoOperation query = do rest =<< find (select query "comments") {sort = []}

getAllCommentsOperation :: String -> Action IO [Document]
getAllCommentsOperation taskId = do rest =<< find (select ["taskId" =: taskId] "comments") {sort = []}
    
getOneCommentOperation :: String -> String -> Action IO [Document]
getOneCommentOperation taskId commentId = do rest =<< find (select ["taskId" =: taskId, "commentId" =: commentId] "comments") {sort = []}

insertCommentOperation :: Com.Comment -> Action IO Value
insertCommentOperation Com.Comment {
    Com.content    = content,
    Com.boardId    = boardId,
    Com.taskId     = taskId,
    Com.commentId  = commentId
} = insert "comments" ["content" =: content, "boardId" =: boardId, "taskId" =: taskId, "commentId" =: commentId]

updateCommentsOperation :: String -> String -> Action IO ()
updateCommentsOperation commentId content = fetch (select ["commentId" =: commentId] "comments") >>= save "comments" . merge ["content" =: content]

deleteCommentsOperation :: String -> Action IO ()
deleteCommentsOperation commentId = delete (select ["commentId" =: commentId] "comments")