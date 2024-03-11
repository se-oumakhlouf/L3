chunk3 :: [a] -> [[a]]
chunk3 []       = [[]]
chunk3 [x]      = [[x]]
chunk3 [x, y]   = [[x, y]]
chunk3 (x : y : z : xs) = [[x, y, z]] ++ chunk3 xs

pairsOfConsecutiveEvens :: Integral a => [a] -> [(a, a)]
pairsOfConsecutiveEvens []              = []
pairsOfConsecutiveEvens [_]             = []
pairsOfConsecutiveEvens (x : y : xs)
    | odd x                     = pairsOfConsecutiveEvens (y : xs)
    | even x && even y          = (x, y) : pairsOfConsecutiveEvens (xs)
    | otherwise                 = pairsOfConsecutiveEvens (y : xs)

pairAndSwapConsecutives :: [a] -> [(a, a)]
pairAndSwapConsecutives [] = []
pairAndSwapConsecutives [_] = []
pairAndSwapConsecutives (x : y : xs) = [(y, x)] ++ pairAndSwapConsecutives (y : xs)

runs :: Ord a => [a] -> [[a]]
runs [] = []
runs [x] = [[x]]
runs (x : y : xs)
    | x < y         = (x : head (runs (y : xs))) : tail (runs (y : xs))
    | otherwise     = [x] : runs (y : xs)