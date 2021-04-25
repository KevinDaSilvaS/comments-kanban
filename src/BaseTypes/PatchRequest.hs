{-# LANGUAGE DeriveGeneric #-}
module BaseTypes.PatchRequest where

import BaseTypes.BaseTypes ( Content )
import Data.Aeson ( FromJSON, ToJSON )
import GHC.Generics ( Generic )

newtype PatchCommentRequest = PatchCommentRequest {
                                    content :: Content
                              } deriving(Generic, Show)

instance ToJSON PatchCommentRequest

instance FromJSON PatchCommentRequest