type Nat = Int

data Tree a = Leaf a | Node Nat (Tree a) (Tree a) deriving Show

data Digit a = Zero | One (Tree a) deriving Show

newtype RAList a = RAList { getDigits :: [Digit a] }

mkRA_ABCDE = RAList { getDigits = [ One (Leaf 'A')
                                  , Zero
                                  , One (Node 4 (Node 2 (Leaf 'B') (Leaf 'C'))
                                   (Node 2 (Leaf 'D') (Leaf 'E')))
                                  ] }

mkRA_ABCDEF = RAList { getDigits = [ Zero
                                   , One (Node 2 (Leaf 'A') (Leaf 'B'))
                                   , One (Node 4 (Node 2 (Leaf 'C') (Leaf 'D'))
                                                 (Node 2 (Leaf 'E') (Leaf 'F')))
                                   ] }

fetch :: Int -> [a] -> a
fetch _ []       = error "index too large"
fetch 0 (x :_)   = x
fetch k (_ : xs) = fetch (k-1) xs

-- the number of leaves in the binary tree.
sizeT :: Tree a -> Nat
sizeT (Leaf _)     = 1
sizeT (Node s _ _) = s

-- smart constructor
mkNodeT t1 t2 = Node (sizeT t1 + sizeT t2) t1 t2


nilRA :: RAList a
nilRA = RAList { getDigits = [] }

nullRA :: RAList a -> Bool
nullRA (RAList { getDigits = [] }) = True
nullRA _                           = False

sizeRA :: RAList a -> Nat
sizeRA (RAList { getDigits = [] }) = 0
sizeRA (RAList { getDigits = (Zero : xs) }) = sizeRA (RAList { getDigits = xs })
sizeRA (RAList { getDigits = (One t : xs) }) = sizeT t + sizeRA (RAList { getDigits = xs })

fromT :: Tree a -> [a]
fromT (Leaf x) = [x]
fromT (Node _ t1 t2) = fromT t1 ++ fromT t2

fromRA :: RAList a -> [a]
fromRA (RAList { getDigits = [] }) = []
fromRA (RAList { getDigits = (Zero : xs) }) = fromRA (RAList { getDigits = xs })
fromRA (RAList { getDigits = (One t : xs) }) = fromT t ++ fromRA (RAList { getDigits = xs })

-- mkRA_ABCDEF
-- -> RA{["ABDCE"]}
-- -> RA{["A", "", "BCDE"]}
instance Show a => Show (RAList a) where
    show (RAList { getDigits = a }) = "-> RA{" ++ show (fromRA (RAList { getDigits = a })) ++ "}" ++ "\n" ++ "-> RA{" ++ show (showFull (RAList { getDigits = a })) ++ "}"

showFull :: RAList a -> [[a]]
showFull (RAList { getDigits = [] }) = []
showFull (RAList { getDigits = (Zero : xs) }) = [] : showFull (RAList {getDigits = xs })
showFull (RAList { getDigits = (One t : xs) }) = fromT t : showFull (RAList { getDigits = xs })

headRA' :: RAList a -> Maybe a
headRA' (RAList { getDigits = [] }) = Nothing
headRA' (RAList { getDigits = (Zero : xs) }) = headRA' (RAList { getDigits = xs })
headRA' (RAList { getDigits = (One t : xs) }) = Just (head (fromT t))

consRA :: a -> RAList a -> RAList a
consRA x (RAList { getDigits = digits }) = (RAList { getDigits = consT (Leaf x) digits })

consT :: Tree a -> [Digit a] -> [Digit a]
consT t [] = [One t]
consT t (Zero : xs) = One t : xs
consT l1@(Leaf x) (One l2@(Leaf y) : xs) =  Zero : consT (Node 2 l1 l2) xs
consT t1 (One t2 : xs) = consT (mkNodeT t1 t2) xs