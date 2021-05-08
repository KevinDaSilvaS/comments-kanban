{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Operations.Mongo.MongoDBOperations where

import qualified Data.Text as T
import Database.MongoDB
import Control.Monad.Trans (liftIO)
import Data.AesonBson
--https://github.com/mongodb-haskell/mongodb/blob/master/doc/Example.hs
--https://subscription.packtpub.com/book/big_data_and_business_intelligence/9781783286331/1/ch01lvl1sec19/using-mongodb-queries-in-haskell
    
data LinkT = LinkT {
    objid:: ObjectId,
    url:: String
} deriving (Show)
    
server = do
    pipe <- connect (host "127.0.0.1")
    isAuthenticated <- access pipe master (T.pack "admin") (auth (T.pack "kevin") (T.pack "kevin"))
    if isAuthenticated then do
        --print "Auth"
        --g <- access pipe master "admin" insertRegister
        e <- access pipe master "admin" execute
        return $ map aesonify  e
        --e <- access pipe master "admin" run
        --print e
    else
        --print "Not Auth"
        error "Unable to fetch data from database"
    
dcp :: Document -> String
dcp = typed . (valueAt "url")
    
getString :: Label -> Document -> String
getString label = typed . (valueAt label)
    
getObjId :: Document -> ObjectId
getObjId = typed . (valueAt "_id") 
    
    {- parsePure :: [LinkT]
    parsePure = map props docs
      where
        docs = findData -}
        
props doc = link
    where
        url = dcp doc
        objId = getObjId doc
        link = LinkT {
          url=url,
          objid=objId
        }
    
printDocs :: String -> [Document] -> Action IO ()
printDocs title docs = liftIO $ putStrLn title >> mapM_ (print {- . exclude ["_id"] -}) (map dcp docs)
    
findData :: Action IO [Document]
findData = do rest =<< find (select [] "links") {sort = []}
    
run :: Action IO ()
run = do
        v <- insertRegister
        l <- findData
        liftIO $ mapM_ print l
    
execute = findData
    
insertRegister :: Action IO Value
insertRegister = insert "links" ["url" =: "/boards/BOARDid/taskId/", "id" =: "/1458"]