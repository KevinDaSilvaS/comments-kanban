module Features.GetCommentSpec where
import SpecHelper
import Helpers.InsertComment
import Control.Monad.Trans (liftIO)
import Data.Maybe (isNothing)
import BaseTypes.Comment 
import Helpers.InsertComment ( insertComment )
import qualified Helpers.ResponseTypes.SuccessSingleResponse as RR
import qualified Helpers.ResponseTypes.ErrorResponse as RRE
import Helpers.GetComment

getCommentSuccessSpec :: IO ()
getCommentSuccessSpec = hspec $ do
    describe "Success" $ do
      it "Should get one comment successfully" $ do
        let id = "12s4f352j82sA8bB677"
        insertedComment <- liftIO (insertComment id)

        fst insertedComment `shouldBe` (201 :: Int)
        isNothing (snd insertedComment) `shouldBe` (False :: Bool)

        let (Just comment) = snd insertedComment
        let insertedCommentId = commentId (RR.details comment)

        response <- liftIO (getComment id insertedCommentId)
        fst response `shouldBe` (200 :: Int)
  
        isNothing (snd response) `shouldBe` (False :: Bool)
        let (Just comment) = snd response
        RR.code comment `shouldBe` ("200" :: String)
        taskId (RR.details comment) `shouldBe` (id :: String)
        boardId (RR.details comment) `shouldBe` (id :: String)
        commentId (RR.details comment) `shouldBe` (insertedCommentId :: String)

getCommentFailSpec :: IO ()
getCommentFailSpec = hspec $ do
  describe "Fail" $ do
    it "Should get 404 comment not found" $ do
        response <- liftIO (getCommentError "any_taskId" "any_commentId")
        fst response `shouldBe` (404 :: Int)
  
        isNothing (snd response) `shouldBe` (False :: Bool)
        let (Just errorMsg) = snd response
        RRE.code errorMsg `shouldBe` ("404" :: String)
        RRE.details errorMsg `shouldBe` ("Comment Not Found" :: String)

getCommentSpec :: IO ()
getCommentSpec = do
  getCommentSuccessSpec
  getCommentFailSpec