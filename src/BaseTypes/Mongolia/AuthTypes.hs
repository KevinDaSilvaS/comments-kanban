{-# LANGUAGE DeriveGeneric #-}

module BaseTypes.Mongolia.AuthTypes where

import GHC.Generics ( Generic )
import Data.Aeson ( FromJSON, ToJSON )

newtype AuthToken = AuthToken {
    mongolia_auth_token:: String
} deriving(Generic, Show)
instance ToJSON AuthToken
    
instance FromJSON AuthToken
    
data AuthResponse = AuthResponse {
    code :: Int,
    details::AuthToken
}deriving(Generic, Show)
instance ToJSON AuthResponse
    
instance FromJSON AuthResponse

serializeAuth :: AuthResponse -> String
serializeAuth AuthResponse { code = code, details=details } = token
    where 
        token =  mongolia_auth_token details  