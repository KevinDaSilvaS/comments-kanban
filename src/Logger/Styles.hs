module Logger.Styles where

_backgroundError :: [Char]
_backgroundError = "\x1b[41m"

_backgroundWarning :: [Char]
_backgroundWarning = "\x1b[43m " ++ _black

_backgroundInfo :: [Char]
_backgroundInfo = "\x1b[44m \x1b[37;1m"

_backgroundSuccess :: [Char]
_backgroundSuccess = "\x1b[42;1m "

_error :: [Char]
_error = "\x1b[31m [error] "

_warning :: [Char]
_warning = "\x1b[33m [warning] "

_info :: [Char]
_info = "\x1b[36m [info] "

_black :: [Char]
_black = "\x1b[30m"

_green :: [Char]
_green = "\x1b[32m"

_reset :: [Char]
_reset = "\x1b[0m"

format :: [Char] -> [Char] -> [Char]
format style log = style ++ log ++ _reset