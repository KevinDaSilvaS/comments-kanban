module Logger.Logger where

import Logger.Styles--(format)
import Control.Concurrent
import Control.Monad(forever)

startLogger = do
    mvar <- newEmptyMVar
    forkIO $ consumeLogs mvar
    return mvar

consumeLogs mvar = do
    forever $ do
        _log <- takeMVar mvar
        putStrLn $ _log

logger mvar style logMessage = do
    let formattedLog = format style logMessage
    putMVar mvar formattedLog
    