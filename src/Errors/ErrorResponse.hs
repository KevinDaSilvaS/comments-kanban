module Errors.ErrorResponse where

import BaseTypes.SpockApi (Api, ApiAction)
import Data.Aeson (KeyValue ((.=)), Value (String), object)
import Data.Text (Text, pack)
import Web.Spock
import BaseTypes.Comment

errorJson :: Int -> Text -> ApiAction ()
errorJson code message =
  json $
    object
      [ pack "code" .= show code,
        pack "details" .= String message,
        pack "error" .= object [pack "code" .= show code, pack "message" .= String message]
      ]