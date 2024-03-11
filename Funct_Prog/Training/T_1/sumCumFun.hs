sumCumFun1 :: (Int -> Int) -> Int -> [Int]
sumCumFun1 f n = [sum [f x | x <- [1..i]] | i <- [1..n]]

-- ~
sumCumFun2 :: (Int -> Int) -> Int -> [Int]
sumCumFun2 _ 0 = []
sumCumFun2 f n = sumCumFun2 f (n-1) ++ [sum (map f [1..n])]

-- ~
sumCumFun3 :: (Int -> Int) -> Int -> [Int]
sumCumFun3 f n = scanl1 (+) (map f [1..n])