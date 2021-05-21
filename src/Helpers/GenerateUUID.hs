module Helpers.GenerateUUID where

import Data.UUID
import Data.UUID.V1 ( nextUUID )

generateUUID = do
    uuid <- nextUUID
    let (Just sanitizedUUID) = uuid
    let strUUID = toString sanitizedUUID
    return strUUID