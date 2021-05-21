module Errors.ErrorMessages where

import Errors.ErrorResponse ( errorJson )
import Data.Text (Text, pack)

_TASK_NOT_FOUND = errorJson 404 (pack "Task Not Found")

_INTERNAL_SERVER_ERROR = errorJson 500 (pack "Internal Server Error")

_PARSING_POST_BODY = errorJson 400 (pack "Error parsing body request (request json body must contain the current fields: { content - String, taskId - Id from the task created in kanban service, boardId - Id from the board created in kanban service })")

_PARSING_PATCH_BODY = errorJson 400 (pack "Error parsing body request (probably the body is empty or dont have valid fields, the updatable fields for patch route are: {content - String}")

_COMMENT_NOT_FOUND = errorJson 404 (pack "Comment Not Found")

_ERROR_UPDATING_COMMENT = errorJson 400 (pack "Error Updating comment.(Check existence of comment)")

_ERROR_DELETING_COMMENT = errorJson 400 (pack "Error deleting comment.(Check existence of comment)")

_ERROR_SEARCHING_TASK = errorJson 400 (pack "Error searching for task.(Tasks service may be temporarily unavailable)")