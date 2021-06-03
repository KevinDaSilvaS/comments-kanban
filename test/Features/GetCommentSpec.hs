module Features.GetCommentSpec where
import SpecHelper
import Helpers.InsertComment
import Control.Monad.Trans (liftIO)
import Data.Maybe (isNothing)
import BaseTypes.Comment ( Comment(taskId, boardId) )

getCommentSpec = hspec $ do
    describe "Success" $ do
      it "Should get one comment" $ do
        insertedComment <- (liftIO insertComment)
        print insertedComment
        (fst insertedComment) `shouldBe` (201 :: Int)
        
        isNothing (snd insertedComment) `shouldBe` (False :: Bool)
        let (Just comment) = snd insertedComment
        code comment `shouldBe` ("201" :: String)
        taskId (details comment) `shouldBe` ("12s4f352j82sA8bB677" :: String)
        boardId (details comment) `shouldBe` ("12s4f352j82sA8bB677" :: String)

