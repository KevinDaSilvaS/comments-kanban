import Test.Hspec

import Features.GetCommentSpec ( getCommentSpec )
import Features.CreateCommentSpec ( createCommentSpec )
import Features.GetAllCommentsSpec ( getAllCommentsSpec )

main :: IO ()
main = do 
       createCommentSpec
       getAllCommentsSpec
       getCommentSpec
