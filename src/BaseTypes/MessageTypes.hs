{-# LANGUAGE DeriveGeneric #-}

module BaseTypes.MessageTypes where

import Data.Aeson ( FromJSON, ToJSON )
import GHC.Generics ( Generic )
import BaseTypes.BaseTypes
    
newtype BodyWhenTaskIsDeletedConsumer = 
    BodyWhenTaskIsDeletedConsumer { 
        taskId :: TaskId } deriving (Generic, Show)
    
instance ToJSON BodyWhenTaskIsDeletedConsumer
    
instance FromJSON BodyWhenTaskIsDeletedConsumer

newtype BodyWhenBoardIsDeletedConsumer = 
    BodyWhenBoardIsDeletedConsumer { 
        boardId :: BoardId } deriving (Generic, Show)
    
instance ToJSON BodyWhenBoardIsDeletedConsumer
    
instance FromJSON BodyWhenBoardIsDeletedConsumer
