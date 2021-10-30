module Features.GetAllCommentsSpec where

import BaseTypes.Comment (Comment (boardId, taskId))
import Control.Monad.Trans (liftIO)
import Data.Maybe (isNothing)
import Helpers.GetComment
import qualified Helpers.ResponseTypes.SuccessResponse as SR
import SpecHelper

getAllCommentsSpec :: IO ()
getAllCommentsSpec = hspec $ do
  describe "Success" $ do
    it "Should get all comments" $ do
      let id = "12s4f352j82sA8bB677"
      comments <- liftIO (getAllComments id)
      fst comments `shouldBe` (200 :: Int)

      isNothing (snd comments) `shouldBe` (False :: Bool)
      let (Just comment) = snd comments
      SR.code comment `shouldBe` ("200" :: String)
      length (SR.details comment) `shouldSatisfy` (> 0)

    it "Should get one comment using pagination" $ do
      let id = "12s4f352j82sA8bB677"
      comments <- liftIO (getAllCommentsPaginated id 1 1)
      fst comments `shouldBe` (200 :: Int)

      isNothing (snd comments) `shouldBe` (False :: Bool)
      let (Just comment) = snd comments
      SR.code comment `shouldBe` ("200" :: String)
      length (SR.details comment) `shouldSatisfy` (== 1)

  it "Should get en empty list when taskId doesnt exist" $ do
    let id = "non_existent_taskId"
    comments <- liftIO (getAllComments id)
    fst comments `shouldBe` (200 :: Int)

    isNothing (snd comments) `shouldBe` (False :: Bool)
    let (Just comment) = snd comments
    SR.code comment `shouldBe` ("200" :: String)
    length (SR.details comment) `shouldSatisfy` (== 0)