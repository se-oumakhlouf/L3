
import qualified Data.List as L

data BSTree a = Node (BSTree a) a (BSTree a) | Empty
                deriving (Eq, Ord)

branchChar :: Char
branchChar = '-'

splitChar :: Char
splitChar = '+'

branchIndent :: Int
branchIndent = 5

branchNil :: Char
branchNil = '⊥'

instance Show a => Show (BSTree a) where
  show = showBSTree 0
    where
      drawBranch 0 = ""
      drawBranch n = L.replicate (n - branchIndent) branchChar ++ [splitChar] ++ L.replicate (branchIndent-1) branchChar

      showBSTree n Empty          = drawBranch n ++ branchNil:"\n"
      showBSTree n (Node lt x rt) = showBSTree (n + branchIndent) rt ++
                                    drawBranch n ++ show x           ++ "\n" ++
                                    showBSTree (n + branchIndent) lt


-- Exo 1 : Warmup

mkExampleBSTree :: BSTree Integer
mkExampleBSTree =
    Node        (Node (Node (Node Empty 1 Empty) 2 (Node Empty 3 Empty)) 4 (Node Empty 5 Empty))
            6  
                (Node (Node Empty 7 Empty) 8 (Node Empty 9 Empty))


countNodesBSTree :: Num b => BSTree a -> b
countNodesBSTree Empty          = 0
countNodesBSTree (Node lt x rt) = 1 + countNodesBSTree lt + countNodesBSTree rt


countLeavesBSTree :: Num b => BSTree a -> b
countLeavesBSTree (Node Empty x Empty)  = 1
countLeavesBSTree (Node lt x rt)        = countLeavesBSTree lt + countLeavesBSTree rt


heightBSTree ::  (Num b, Ord b) => BSTree a -> b
heightBSTree Empty = 0
heightBSTree (Node lt x rt) = 1 + max(heightBSTree lt) (heightBSTree rt)


leavesBSTree :: BSTree a -> [a]
leavesBSTree (Node Empty x Empty) = [x]
leavesBSTree (Node lt x rt)       = leavesBSTree lt ++ leavesBSTree rt


elemBSTree :: Ord a => a -> BSTree a -> Bool
elemBSTree  _ Empty = False
elemBSTree n (Node lt x rt)
  | n == x      = True
  | n < x       = elemBSTree n lt
  | otherwise   = elemBSTree n rt


-- Exo 2 : Parcours

-- [1,2,3,4,5,6,7,8,9]
inOrderVisitBSTree :: BSTree a -> [a]
inOrderVisitBSTree Empty = []
inOrderVisitBSTree (Node lt x rt) = inOrderVisitBSTree lt ++ [x] ++ inOrderVisitBSTree rt


-- [6,4,2,1,3,5,8,7,9]
preOrderVisitBSTree :: BSTree a -> [a]
preOrderVisitBSTree Empty = []
preOrderVisitBSTree (Node lt x rt) = [x] ++ preOrderVisitBSTree lt ++ preOrderVisitBSTree rt


-- [1,3,2,5,4,7,9,8,6]
postOrderVisitBSTree :: BSTree a -> [a]
postOrderVisitBSTree Empty = []
postOrderVisitBSTree (Node lt x rt) = postOrderVisitBSTree lt ++ postOrderVisitBSTree rt ++ [x]


-- Exo 3 : Fusion et Insertion

insertBSTree :: (Ord a) => BSTree a -> a -> BSTree a
insertBSTree Empty a = Node Empty a Empty
insertBSTree (Node lt x rt) a
  | a > x     = Node lt x (insertBSTree rt a)
  | otherwise = Node (insertBSTree lt a) x rt


fromListBSTree :: Ord a => [a] -> BSTree a
fromListBSTree xs = foldl constructor Empty xs
  where 
      constructor acc cur = insertBSTree acc cur


toListBSTree :: BSTree a -> [a]
toListBSTree = preOrderVisitBSTree


mergeBSTree :: Ord a => BSTree a -> BSTree a -> BSTree a
mergeBSTree first second = fromListBSTree (toListBSTree first ++ toListBSTree second)


-- Exo 4 : Suppression

leftmostBSTree :: BSTree a -> Maybe a
leftmostBSTree Empty = Nothing
leftmostBSTree (Node Empty x Empty) = Just x
leftmostBSTree (Node lt x rt) = leftmostBSTree lt


minBSTree :: BSTree a -> Maybe a
minBSTree = leftmostBSTree


rightmostBSTree :: BSTree a -> Maybe a
rightmostBSTree Empty = Nothing
rightmostBSTree (Node Empty x Empty) = Just x
rightmostBSTree (Node lt x rt) = rightmostBSTree rt

maxBSTree :: BSTree a -> Maybe a
maxBSTree = rightmostBSTree