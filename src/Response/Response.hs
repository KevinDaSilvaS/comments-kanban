module Response.Response where

import BaseTypes.SpockApi (Api, ApiAction)
import Data.Aeson (KeyValue ((.=)), Value (String), object, Object)
import Data.Text (Text, pack)
import Web.Spock 

response :: Int -> [Object] -> ApiAction ()
response code message =
  json $
    object
      [ pack "code" .= show code,
        pack "details" .= message
      ]

responseSimple :: Int -> Object -> ApiAction ()
responseSimple code message =
    json $
      object
        [ pack "code" .= show code,
          pack "details" .= message
        ]