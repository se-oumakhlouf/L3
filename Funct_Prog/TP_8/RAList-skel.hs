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

