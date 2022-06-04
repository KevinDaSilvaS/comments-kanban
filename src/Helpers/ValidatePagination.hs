module Helpers.ValidatePagination where

import Database.MongoDB ( Limit )

defaultLimit = 50
defaultPage  = 0

obtainLimit :: (Maybe Limit) -> Limit
obtainLimit (Just limit)
    | limit < 0 = defaultLimit
    | otherwise = limit-1
obtainLimit _   = defaultLimit

obtainPage :: Maybe Limit -> Limit
obtainPage (Just page)
    | page <= 0 = defaultPage
    | otherwise = page
obtainPage _    = defaultPage