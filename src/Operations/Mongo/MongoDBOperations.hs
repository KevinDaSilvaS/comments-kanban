{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Operations.Mongo.MongoDBOperations where

import qualified Data.Text as T
import Database.MongoDB
import Control.Monad.Trans (liftIO)
import Data.AesonBson
import qualified BaseTypes.Comment as Com
--https://github.com/mongodb-haskell/mongodb/blob/master/doc/Example.hs
--https://subscription.packtpub.com/book/big_data_and_business_intelligence/9781783286331/1/ch01lvl1sec19/using-mongodb-queries-in-haskell
--https://github.com/mongodb-haskell/mongodb/blob/master/doc/tutorial.md

insertComment body = do
    pipe <- connect (host "127.0.0.1")
    isAuthenticated <- access pipe master (T.pack "admin") (auth (T.pack "kevin") (T.pack "kevin"))
    if isAuthenticated then do
        insertedCommentId <- access pipe master "admin" (insertCommentOperation body)
        insertedComment <- access pipe master "admin" (findMongoOperation ["_id" =: insertedCommentId])
        return $ (aesonify . exclude ["_id"]) $ head insertedComment
    else
        error "Unable to connect to database"

getAllComments taskId = do
    pipe <- connect (host "127.0.0.1")
    isAuthenticated <- access pipe master (T.pack "admin") (auth (T.pack "kevin") (T.pack "kevin"))
    if isAuthenticated then do
        comments <- access pipe master "admin" (getAllCommentsOperation taskId)
        return $ map (aesonify . exclude ["_id"]) comments
    else
        error "Unable to connect to database"

getComment taskId commentId = do
    pipe <- connect (host "127.0.0.1")
    isAuthenticated <- access pipe master (T.pack "admin") (auth (T.pack "kevin") (T.pack "kevin"))
    if isAuthenticated then do
        comment <- access pipe master "admin" (getOneCommentOperation taskId commentId)
        return $(aesonify . exclude ["_id"]) $ head comment
    else
        error "Unable to connect to database"

updateComment commentId content = do
    pipe <- connect (host "127.0.0.1")
    isAuthenticated <- access pipe master (T.pack "admin") (auth (T.pack "kevin") (T.pack "kevin"))
    if isAuthenticated then do
        updatedComments <- access pipe master "admin" (updateCommentsOperation commentId content)
        return ()
    else
        error "Unable to connect to database"

deleteComment commentId = do
    pipe <- connect (host "127.0.0.1")
    isAuthenticated <- access pipe master (T.pack "admin") (auth (T.pack "kevin") (T.pack "kevin"))
    if isAuthenticated then do
        deletedComments <- access pipe master "admin" (deleteCommentsOperation commentId)
        return ()
    else
        error "Unable to connect to database"
    
findMongoOperation :: Selector -> Action IO [Document]
findMongoOperation query = do rest =<< find (select query "comments") {sort = []}

getAllCommentsOperation :: String -> Action IO [Document]
getAllCommentsOperation taskId = do rest =<< find (select ["taskId" =: taskId] "comments") {sort = []}
    
getOneCommentOperation :: String -> String -> Action IO [Document]
getOneCommentOperation taskId commentId = do rest =<< find (select ["taskId" =: taskId, "commentId" =: commentId] "comments") {sort = []}

insertRegister :: Action IO Value
insertRegister = insert "links" ["url" =: "/boards/BOARDid/taskId/", "id" =: "/1458"]

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