import Data.List

elem' :: (Foldable t, Eq a) => a -> t a -> Bool
elem' x = foldr (\y acc -> y == x || acc) False
-- acc = True if y == x, otherwise acc = False


map1 :: (a -> b) -> [a] -> [b]
map1 _ [] = []
map1 f (x : xs) = f x :map1 f xs

map2 :: (a -> b) -> [a] -> [b]
map2 _ [] = []
map2 f xs = [f x | x <- xs]

map3 :: (a -> b) -> [a] -> [b]
map3 f = foldr (\x acc -> f x : acc) []

{-
    The returned list is reversed

    map4 :: (a -> b) -> [a] -> [b]
    map4 f = foldl (\acc x -> f x : acc) []
    
-}

-- map4 is in O(n²)
map4 :: (a -> b) -> [a] -> [b]
map4 f = reverse . foldl (\acc x -> f x : acc) []

-- (++) add an element at the end of the list
-- goes through the whole list for each element
-- map5 is in O(n²)
map5 :: (a -> b) -> [a] -> [b]
map5 f = foldl (\acc x -> acc ++ [f x]) []


{-
    take 5 $ map1 (2^) [1..] > [2, 4, 8, 16, 32]
    take 5 $ map2 (2^) [1..] > [2, 4, 8, 16, 32]
    take 5 $ map3 (2^) [1..] > [2, 4, 8, 16, 32]
    take 5 $ map4 (2^) [1..] > infinite loop (tries to process the whole list before returning it)
    take 5 $ map5 (2^) [1..] > infinite loop (tries to process the whole list before returning it)

    foldr is "lazy" and can be used with infinite lists
    foldl isn't and can cause infinite loops
-}


filter1 :: (a -> Bool) -> [a] -> [a]
filter1 _ [] = []
filter1 p (x : xs)
    | p x       = x : filter1 p xs
    | otherwise = filter1 p xs

filter2 :: (a -> Bool) -> [a] -> [a]
filter2 p xs = [x | x <- xs, p x]

filter3 :: (a -> Bool) -> [a] -> [a]
filter3 p = foldr (\x acc -> if p x then x : acc else acc) []


takeWhile1 :: (a -> Bool) -> [a] -> [a]
takeWhile1 _ [] = []
takeWhile1 p (x : xs)
    | p x       = x : takeWhile1 p xs
    | otherwise = []


takeWhile2 :: (a -> Bool) -> [a] -> [a]
takeWhile2 p = foldr (\x acc -> if p x then x : acc else []) []


dropWhile1 :: (a -> Bool) -> [a] -> [a]
dropWhile1 _ [] = []
dropWhile1 p (x : xs)
    | p x = dropWhile1 p xs
    | otherwise = x : xs

-- dropWhile2 with foldl


zipWith1 :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith1 _ [] _ = []
zipWith1 _ _ [] = []
zipWith1 f (x : xs) (y:ys) = f x y:zipWith1 f xs ys

-- zipWith2 using high order functions


reverse1 :: [a] -> [a]
reverse1 [] = []
reverse1 (x : xs) = reverse1 xs ++ [x]

reverse2 :: [a] -> [a]
reverse2 (x : xs) = foldl (\acc x -> x : acc) [] xs

{-

    Does not work
    reverse3 :: [a] -> [a]
    reverse3 (x : xs) = foldr (\x acc -> x : acc) [] xs
-}