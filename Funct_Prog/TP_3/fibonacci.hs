-- fibonacciSeq1 is in O(2^n)
fibonacciSeq1 :: [Integer]
fibonacciSeq1 = [f n | n <- [0..]]
    where
        f 0 = 0
        f 1 = 1
        f n = f (n-1) + f (n-2)

-- using iterate
fibonacciSeq3 :: [Integer]
fibonacciSeq3 = map fst $ iterate (\(x, y) -> (y, x + y)) (0, 1)

fibonacciSeq4 :: [Integer]
fibonacciSeq4 = 0 : zipWith (+) (1 : fibonacciSeq4) fibonacciSeq4