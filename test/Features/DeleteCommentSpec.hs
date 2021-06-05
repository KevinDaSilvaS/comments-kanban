module Features.DeleteCommentSpec where

import BaseTypes.Comment
import Control.Monad.Trans (liftIO)
import Data.Maybe (isNothing)
import Helpers.DeleteComment
import Helpers.InsertComment (insertComment)
import qualified Helpers.ResponseTypes.SuccessSingleResponse as RR
import SpecHelper

deleteCommentSpec :: IO ()
deleteCommentSpec = hspec $
  describe "Success" $ do
    it "Should delete one comment" $ do
      let id = "12s4f352j82sA8bB677"
      insertedComment <- liftIO (insertComment id)

      fst insertedComment `shouldBe` (201 :: Int)
      isNothing (snd insertedComment) `shouldBe` (False :: Bool)

      let (Just comment) = snd insertedComment
      let insertedCommentId = commentId (RR.details comment)

      response <- liftIO (deleteComment insertedCommentId)
      response `shouldBe` (204 :: Int)

    it "Should call delete route successfully using non existent commentId" $ do
      response <- liftIO (deleteComment "non_existent_commentId")
      response `shouldBe` (204 :: Int)