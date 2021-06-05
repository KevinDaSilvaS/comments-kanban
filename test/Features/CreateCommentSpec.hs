module Features.CreateCommentSpec where

import BaseTypes.Comment (Comment (boardId, taskId))
import Control.Monad.Trans (liftIO)
import Data.Maybe (isNothing)
import Helpers.InsertComment ( insertComment, insertCommentError )
import qualified Helpers.ResponseTypes.ErrorResponse as RRE
import qualified Helpers.ResponseTypes.SuccessSingleResponse as RR
import SpecHelper

createCommentSuccessSpec :: IO ()
createCommentSuccessSpec = hspec $
  describe "Success" $ do
  it "Should create one comment" $ do
    let id = "12s4f352j82sA8bB677"
    insertedComment <- liftIO (insertComment id)
    fst insertedComment `shouldBe` (201 :: Int)

    isNothing (snd insertedComment) `shouldBe` (False :: Bool)
    let (Just comment) = snd insertedComment
    RR.code comment `shouldBe` ("201" :: String)
    taskId (RR.details comment) `shouldBe` (id :: String)
    boardId (RR.details comment) `shouldBe` (id :: String)

createCommentFailSpec :: IO ()
createCommentFailSpec = hspec $
  describe "Fail" $ do
    it "Should return error 400 when mini-kanban is not deployed" $ do
      let id = "err500"
      insertedComment <- liftIO (insertCommentError id)
      fst insertedComment `shouldBe` (400 :: Int)

      isNothing (snd insertedComment) `shouldBe` (False :: Bool)
      let (Just errorMsg) = snd insertedComment
      RRE.code errorMsg `shouldBe` ("400" :: String)
      RRE.details errorMsg `shouldBe` (
        "Error searching for task.(Tasks service may be temporarily unavailable)" :: String)

    it "Should return error 404 when task or board doesnt exist in mini-kanban" $ do
      let id = "any_taskId"
      insertedComment <- liftIO (insertCommentError id)
      fst insertedComment `shouldBe` (404 :: Int)

      isNothing (snd insertedComment) `shouldBe` (False :: Bool)
      let (Just errorMsg) = snd insertedComment
      RRE.code errorMsg `shouldBe` ("404" :: String)
      RRE.details errorMsg `shouldBe` ("Task Not Found" :: String)

createCommentSpec :: IO ()
createCommentSpec = do
  createCommentSuccessSpec
  createCommentFailSpec