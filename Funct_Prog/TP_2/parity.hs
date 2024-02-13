-- Question a
-- only using the fact that 0 is Even and 1 is Odd

isEven :: (Eq a, Num a) => a -> Bool
isEven n
    | n == 1    = False
    | n == 0    = True
    | otherwise = isEven (n - 2)

isOdd :: (Eq a, Num a) => a -> Bool
isOdd n 
    | n == 1    = True
    | n == 0    = False
    | otherwise = isOdd (n - 2)


-- Question b

-- isEvenOddAlternating [1..10] > False
-- isEvenOddAlternating [2..11] > True
isEvenOddAlternating :: Integral a => [a] -> Bool
isEvenOddAlternating []         = False
isEvenOddAlternating [x]        = even x
isEvenOddAlternating [x, y]     = (even x) && (odd y)
isEvenOddAlternating (x : y : xs) = (even x) && (odd y) 
            && isEvenOddAlternating xs

-- isOddEvenAlternating [1..10] > True
-- isOddEvenAlternating [2..10] > False
isOddEvenAlternating :: Integral a => [a] -> Bool
isOddEvenAlternating []         = False
isOddEvenAlternating [x]        = odd x
isOddEvenAlternating [x, y]     = (odd x) && (even y)
isOddEvenAlternating (x : y : xs) = (odd x) && (even y) 
            && isOddEvenAlternating xs

-- isAlternating [1..100] > True
-- isAlternating [1, 3..10] > False
isAlternating :: Integral a => [a] -> Bool
isAlternating x = isEvenOddAlternating x || isOddEvenAlternating x