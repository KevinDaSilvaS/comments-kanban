module Features.UpdateCommentSpec where

import Data.Maybe (isNothing)
import BaseTypes.Comment 
import Helpers.InsertComment ( insertComment )
import Helpers.UpdateComment 
import Control.Monad.Trans (liftIO)
import qualified Helpers.ResponseTypes.SuccessSingleResponse as RR
import qualified Helpers.ResponseTypes.ErrorResponse as RRE
import SpecHelper

updateCommentSuccessSpec :: IO ()
updateCommentSuccessSpec = hspec $
    describe "Success" $ do
      it "Should update one comment" $ do
        let id = "12s4f352j82sA8bB677"
        insertedComment <- liftIO (insertComment id)

        fst insertedComment `shouldBe` (201 :: Int)
        isNothing (snd insertedComment) `shouldBe` (False :: Bool)

        let (Just comment) = snd insertedComment
        let insertedCommentId = commentId (RR.details comment)

        response <- liftIO (updateComment insertedCommentId)
        response `shouldBe` (204 :: Int)


updateCommentErrorSpec :: IO ()
updateCommentErrorSpec = hspec $
    describe "Fail" $ do
        it "Should return error parsing body" $ do
            let id = "12s4f352j82sA8bB677"
            insertedComment <- liftIO (insertComment id)
        
            fst insertedComment `shouldBe` (201 :: Int)
            isNothing (snd insertedComment) `shouldBe` (False :: Bool)
        
            let (Just comment) = snd insertedComment
            let insertedCommentId = commentId (RR.details comment)
        
            response <- liftIO (
                updateCommentError insertedCommentId "not_a_valid_field" "not_a_valid_value")

            fst response `shouldBe` (400 :: Int)
    
            isNothing (snd response) `shouldBe` (False :: Bool)
            let (Just errorMsg) = snd response
            RRE.code errorMsg `shouldBe` ("400" :: String)
            RRE.details errorMsg `shouldBe` (
                "Error parsing body request (probably the body is empty or dont have valid fields, the updatable fields for patch route are: {content - String}" :: String)

        it "Should return error updating comment" $ do  
            response <- liftIO (updateCommentError "invalid_comment_id" "content" "any_content")
        
            fst response `shouldBe` (400 :: Int)
            
            isNothing (snd response) `shouldBe` (False :: Bool)
            let (Just errorMsg) = snd response
            RRE.code errorMsg `shouldBe` ("400" :: String)
            RRE.details errorMsg `shouldBe` (
                "Error Updating comment.(Check existence of comment)" :: String)

updateCommentSpec :: IO ()
updateCommentSpec = do
    updateCommentSuccessSpec
    updateCommentErrorSpec