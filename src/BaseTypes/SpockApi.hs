module BaseTypes.SpockApi where

import Web.Spock (SpockM, SpockAction)

type Api = SpockM () () () ()

type ApiAction a = SpockAction () () () a