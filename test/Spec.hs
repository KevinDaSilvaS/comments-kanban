import Test.Hspec

--import Features.GetCommentSpec (getCommentSpec)
import Features.CreateCommentSpec
import Features.GetAllCommentsSpec

main :: IO ()
main = do 
       createCommentSpec
       getAllCommentsSpec
       --getCommentSpec
