{-# LANGUAGE OverloadedStrings #-}

module Services.DeleteComment where

import Web.Spock
import Network.HTTP.Types

import BaseTypes.SpockApi ( Api, ApiAction )

deleteComment :: Api
deleteComment = do
    delete ("comments" <//> var) $ \commentId -> do
        let v = commentId ++ "!"
        setStatus noContent204
    