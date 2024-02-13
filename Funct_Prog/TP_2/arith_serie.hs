-- Question a

-- isArithSerie [2, 5, 8, 11] > True
-- isArithSerie [2, 5, 7, 11] > False
isArithSerie :: (Eq a, Num a) => [a] -> Bool
isArithSerie []             = False -- [] > False
isArithSerie [x]            = False -- [2] > False
isArithSerie [x, y]         = True  -- [2, 5] > True
isArithSerie (x : y : z : xs) = (y - x) == (z - y) && isArithSerie (y : z: xs)


-- Question b

-- isConstant [1, 1, 1, 1] > True
-- isConstant [1, 2, 1] > False
isConstant :: Eq a => [a] -> Bool
isConstant []           = False
isConstant [x]          = True
isConstant (x : y : xs) = x == y && isConstant (y : xs)


-- Question c

-- mkArithSerie 10 5 4 > [10, 15, 20, 25]
mkArithSerie :: (Eq a, Num a) => a -> a -> a -> [a]
mkArithSerie _ _ 0 = []
mkArithSerie u0 r n = u0 + r : mkArithSerie (u0 + r) r (n - 1)

-- version with iterate from data.list iterate
mkArithSerie' :: Num a => a -> a -> Int -> [a]
mkArithSerie' u0 r n = take n $ iterate (+r) u0
