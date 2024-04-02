import qualified Data.List as L
import Data.Foldable as F

data MTree a = MTree {rootLabel :: a, subForest :: MForest a}
    deriving (Eq, Ord)

type MForest a = [MTree a]

mTreeIndent :: Int
mTreeIndent = 4

mTreeBranchChar :: Char
mTreeBranchChar = '.'

mTreeNodeChar :: Char
mTreeNodeChar = '+'

instance (Show a) => Show (MTree a) where
    show = go 0
        where
            go nTabs MTree {rootLabel = rl, subForest = mts} =
                    L.replicate nTabs mTreeBranchChar ++
                    (if nTabs > 0 then " " else "") ++
                    mTreeNodeChar:" root label=" ++
                    show rl ++
                    "\n" ++
                    F.foldr f "" mts
                where
                    f mt acc = go (nTabs + mTreeIndent) mt ++ acc


mTreeMk :: a -> [MTree a] -> MTree a
mTreeMk rl mts = MTree {rootLabel = rl, subForest = mts}

mTreeMkLeaf :: a -> MTree a
mTreeMkLeaf rl = mTreeMk rl []

mTreeExample :: MTree Integer
mTreeExample = root
    where
        root = mt_01_01_6
            where
                -- writing convention : mt_level_left-to-right-index_value
                
                -- level 01
                mt_01_01_6 = mTreeMk 6 [mt_02_01_4, mt_02_02_2, mt_02_03_8]
                
                -- level 02
                mt_02_01_4 = mTreeMk 4 [mt_03_01_2, mt_03_02_5]
                mt_02_02_2 = mTreeMk 2 [mt_03_03_3]
                mt_02_03_8 = mTreeMk 8 [mt_03_04_7, mt_03_05_9, mt_03_06_2]
                
                -- level 03
                mt_03_01_2 = mTreeMk 2 [mt_04_01_1, mt_04_02_7, mt_04_03_3]
                mt_03_02_5 = mTreeMk 5 [mt_04_04_3, mt_04_05_9]
                mt_03_03_3 = mTreeMk 3 [mt_04_06_1]
                mt_03_04_7 = mTreeMk 7 [mt_04_07_8]
                mt_03_05_9 = mTreeMkLeaf 9
                mt_03_06_2 = mTreeMk 2 [mt_04_08_1, mt_04_09_2, mt_04_10_9, mt_04_11_7, mt_04_12_3]
                
                -- level 04
                mt_04_01_1 = mTreeMkLeaf 1
                mt_04_02_7 = mTreeMkLeaf 7
                mt_04_03_3 = mTreeMkLeaf 3
                mt_04_04_3 = mTreeMkLeaf 3
                mt_04_05_9 = mTreeMkLeaf 9
                mt_04_06_1 = mTreeMkLeaf 1
                mt_04_07_8 = mTreeMkLeaf 8
                mt_04_08_1 = mTreeMkLeaf 1
                mt_04_09_2 = mTreeMkLeaf 2
                mt_04_10_9 = mTreeMkLeaf 9
                mt_04_11_7 = mTreeMkLeaf 7 
                mt_04_12_3 = mTreeMkLeaf 3


mTreeCount :: Num b => MTree a -> b
mTreeCount (MTree _ []) = 1
mTreeCount (MTree _ forest) = 1 + sum (map mTreeCount forest)

mTreeIsLeaf :: MTree a -> Bool
mTreeIsLeaf (MTree _ []) = True
mTreeIsLeaf (MTree _ forest) = False

mTreeLeaves :: MTree a -> [a]
mTreeLeaves (MTree root []) = [root]
mTreeLeaves (MTree _ forest) = foldr recur [] forest
    where 
        recur cur acc = if mTreeIsLeaf cur then rootLabel cur : acc else acc ++ mTreeLeaves cur

mTreeCountLeaves :: Num b => MTree a -> b
mTreeCountLeaves arbre = foldr count 0 (mTreeLeaves arbre)
    where 
        count cur acc = acc + 1

mTreeSum :: Num a => MTree a -> a
mTreeSum (MTree root []) = root
mTreeSum (MTree root forest) = root + sum (map mTreeSum forest)

mTreeHeight :: (Num b, Ord b) => MTree a -> b
mTreeHeight (MTree _ []) = 1
mTreeHeight (MTree _ forest) = 1 + maximum (map mTreeHeight forest)

mTreeElem :: Eq a => a -> MTree a -> Bool
mTreeElem etiq (MTree root []) = root == etiq
mTreeElem etiq (MTree root forest) = root == etiq || any (mTreeElem etiq) forest

mTreeToList :: MTree a -> [a]
mTreeToList (MTree root forest) = root : foldr tolist [] forest
    where
        tolist forest acc = mTreeToList forest ++ acc

mTreeMin :: Ord a => MTree a -> a
mTreeMin arbre = minimum $ mTreeToList arbre

mTreeMax :: Ord a => MTree a -> a
mTreeMax arbre = maximum $ mTreeToList arbre

-- [6,4,2,1,7,3,5,3,9,2,3,1,8,7,8,9,2,1,2,9,7,3]
mTreeDepthFirstTraversal :: MTree a -> [a]
mTreeDepthFirstTraversal = mTreeToList

mforestBreadthFirstTraversal :: MForest a -> [a]
mforestBreadthFirstTraversal forest = bfs forest
  where
    bfs [] = []
    bfs (arbre : rest) = rootLabel arbre : bfs (rest ++ subForest arbre)


-- [6,4,2,8,2,5,3,7,9,2,1,7,3,3,9,1,8,1,2,9,7,3]
mTreeBreadthFirstTraversal :: MTree a -> [a]
mTreeBreadthFirstTraversal arbre = mforestBreadthFirstTraversal [arbre]

mTreeLayer :: Int -> MTree a -> [a]
mTreeLayer 0 _ = []