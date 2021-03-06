module Errors.ErrorResponse where

import BaseTypes.SpockApi (Api, ApiAction)
import Data.Aeson (KeyValue ((.=)), Value (String), object)
import Data.Text (Text, pack)
import Web.Spock

errorJson :: Int -> Text -> ApiAction ()
errorJson code message =
  json $
    object
      [ pack "code" .= show code,
        pack "details" .= String message
      ]