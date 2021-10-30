{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Operations.Mongo.MongoDBOperations where

import qualified Data.Text as T
import Database.MongoDB
import Control.Monad.Trans (liftIO)
import Data.AesonBson
import qualified BaseTypes.Comment as Com
import LoadEnv
import Data.Aeson (Object)
import System.Environment (lookupEnv)
import Control.Exception
import Data.Word
--https://github.com/mongodb-haskell/mongodb/blob/master/doc/Example.hs
--https://subscription.packtpub.com/book/big_data_and_business_intelligence/9781783286331/1/ch01lvl1sec19/using-mongodb-queries-in-haskell
--https://github.com/mongodb-haskell/mongodb/blob/master/doc/tutorial.md

insertComment :: (Pipe, Database) -> Com.Comment -> IO Object
insertComment (pipe, dbName) body = do
    insertedCommentId <- access pipe master dbName
        (insertCommentOperation body)
    insertedComment <- access pipe master dbName
        (findCommentsOperation ["_id" =: insertedCommentId] 0 1)
    return $ (aesonify . exclude ["_id"]) $ head insertedComment

getAllComments :: (Pipe, Database) -> String -> Limit -> Limit-> IO [Object]
getAllComments (pipe, dbName) taskId page limit = do
    comments <- access pipe master dbName (findCommentsOperation
        ["taskId" =: taskId] page limit)
    return $ map (aesonify . exclude ["_id"]) comments

getComment :: (Pipe, Database) -> String -> String -> IO [Object]
getComment (pipe, dbName) taskId commentId = do
    comment <- access pipe master dbName
        (findCommentsOperation [
            "taskId" =: taskId, "commentId" =: commentId
            ] 0 1)
    return $ map (aesonify . exclude ["_id"]) comment

updateComment :: (Pipe, Database) -> String -> String -> IO (Maybe SomeException)
updateComment (pipe, dbName) commentId content = do
    updatedComments <- try
        (access pipe master dbName
        (updateCommentsOperation commentId content))
        :: IO (Either SomeException ())

    case updatedComments of
        Left ex -> return $ Just ex
        Right _ -> return Nothing

deleteComment :: (Pipe, Database) -> String -> String -> IO (Maybe SomeException)
deleteComment (pipe, dbName) field value = do
    deletedComments <- try $
        access pipe master dbName
        (deleteCommentsOperation
        (T.pack field) value) :: IO (Either SomeException ())
    case deletedComments of
        Left ex -> return $ Just ex
        Right _ -> return Nothing

findCommentsOperation :: Selector -> Limit -> Limit -> Action IO [Document]
findCommentsOperation query page limit = do
    rest =<< find
        (select query "comments")
        {sort = [], limit = limit, skip = page}

insertCommentOperation :: Com.Comment -> Action IO Value
insertCommentOperation Com.Comment {
    Com.content    = content,
    Com.boardId    = boardId,
    Com.taskId     = taskId,
    Com.commentId  = commentId
} = insert "comments" [
    "content" =: content, "boardId" =: boardId,
     "taskId" =: taskId, "commentId" =: commentId]

updateCommentsOperation :: String -> String -> Action IO ()
updateCommentsOperation commentId content = fetch (select [
    "commentId" =: commentId] "comments") >>= save "comments" . merge [
        "content" =: content]

deleteCommentsOperation :: T.Text -> String -> Action IO ()
deleteCommentsOperation field value = delete (select [
    field =: value] "comments")