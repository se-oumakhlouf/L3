-- Question a

-- head' :: [a] -> a
-- head' [2, 3, 4] > 2
head' []        = error "empty list"
head' (x : _)   = x


-- Question b

-- tail' :: [a] -> [a]
-- tail' [2, 3, 4] > [3, 4]
tail' []        = error "empty list"
tail' (_ : x)   = x


-- Question c

-- last' :: [a] -> a
-- last' [2, 3, 4] > 4
last' []        = error "empty list" 
last' [x]       = x
last' (_ : xs)  = last' xs


-- Question d

{-
    *** Exception: warmup.hs:13:1-19
            Non-echauxstive patterns in function tail'
-}


-- Question e - f - g

-- interval 0 > []
-- interval 3 > [1, 2, 3]
interval :: Int -> [Int]
interval k  = [1..k]

{- 
    interval :: (Num a, Enum a) => a -> [a]
-}


-- Question h - i

-- interval' 2 5 > [2, 3, 4, 5]
-- interval' 5 2 > []
interval' :: Int -> Int -> [Int]
interval' s k   = [s..k]