import Data.List

distrib :: a -> [a] -> [[a]]
distrib x xs = [ take i xs ++ [x] ++ drop i xs | i <- [0..length xs] ]

permutations1 :: [a] -> [[a]]
permutations1 [] = [[]]
permutations1 (x:xs) = concatMap (distrib x) (permutations1 xs)


shuffles :: [a] -> [a] -> [[a]]
shuffles xs [] = [xs]
shuffles [] ys = [ys]
shuffles (x:xs) (y:ys) = 
    [x:z | z <- shuffles xs (y:ys)] ++ [y:z | z <- shuffles (x:xs) ys]