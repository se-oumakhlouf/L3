-- Question a

-- sum' [1, 2, 3, 4] > 10
-- sum :: Num a => [a] -> a
sum' [] = 0
sum' (x : xs) = x + sum' xs


-- Question b

-- maximum' [1, 2, 3, 4] > 4
maximum' :: Ord a => [a] -> a
maximum' [x] = x
maximum' (x : xs)
    | x > y = x
    | otherwise = y 
    where
        y = maximum' xs


-- Question c

-- length' [1, 2, 3, 4] > 4
-- length' [] > 0
length' :: [a] -> Int
length [] = 0
length' (x : xs) = 1 + length' xs


-- Question d

-- zip' [1, 2, 3, 4] [5, 6, 7, 8] > [(1, 5), (2, 6), (3, 7), (4, 8)]
-- zip' [1, 2, 3] ['a', 'b', 'c', 'd', 'e'] > [(1, 'a'), (2, 'b'), (3, 'c')]
-- zip' [] [5, 6, 7, 8] > []
zip' :: [a] -> [b] -> [(a, b)]
zip' [] _ = []
zip' _ [] = []
zip' (x : xs) (y : ys) = (x, y) : zip' xs ys


-- Question e

-- take' 2 [1, 2, 3, 4] > [1, 2]
-- take' 10 [1, 2, 3, 4] > [1, 2, 3, 4]
take' :: (Eq b, Num b) => b -> [a] -> [a]
take' 0 _ = []
take' _ [] = []
take' n (x : xs) = x : take' (n - 1) xs


-- Question f

-- drop' 2 [1, 2, 3, 4] > [3, 4]
-- drop' 10 [1, 2, 3, 4] > [] 
drop' :: (Eq b, Num b) => b -> [a] -> [a]
drop' 0 xs = xs
drop' _ [] = []
drop' n (x : xs) = drop' (n - 1) xs
-- need drop' :: (Ord b, Num b) => b -> [a] -> [a] to obtain
-- drop' (-1) [1, 2, 3, 4] > [1, 2, 3, 4]


-- Question g

-- elem' 3 [1..10] > True
-- elem' 7 [1..6] > False
elem' :: Eq a => a -> [a] -> Bool
elem' _ [] = False
elem' n (x : xs)
    | n == x = True
    | otherwise = elem' n xs
    

-- Question h

--- reverse' [1, 2, 3, 4] > [4, 3, 2, 1]
reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x : xs) = reverse' xs ++ [x]
