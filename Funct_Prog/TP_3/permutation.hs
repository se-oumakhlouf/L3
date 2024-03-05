import Data.List

distrib :: a -> [a] -> [[a]]
distrib x [] = [[x]]
distrib x (y : ys) = (x:y:ys) : map (y:) (distrib x ys)

permutations1 :: [a] -> [[a]]
permutations1 [] = [[]]
permutations1 (x:xs) = concatMap (distrib x) (permutations1 xs)


shuffles :: [a] -> [a] -> [[a]]
shuffles xs [] = [xs]
shuffles [] ys = [ys]
shuffles (x:xs) (y:ys) = 
    [x:z | z <- shuffles xs (y:ys)] ++ [y:z | z <- shuffles (x:xs) ys]