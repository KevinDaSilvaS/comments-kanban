import Test.Hspec

import Features.GetCommentSpec ( getCommentSpec )
import Features.CreateCommentSpec ( createCommentSpec )
import Features.GetAllCommentsSpec ( getAllCommentsSpec )
import Features.UpdateCommentSpec ( updateCommentSpec )
import Features.DeleteCommentSpec ( deleteCommentSpec )

main :: IO ()
main = do 
       createCommentSpec
       getAllCommentsSpec
       getCommentSpec
       updateCommentSpec
       deleteCommentSpec
