-- Question a

-- msplit [] > ([] ,[])
-- msplit [1,2,3,4] > ([1, 3], [2, 4])
-- msplit :: [a] -> ([a], [a])
msplit [] = ([], [])
msplit [x] = ([x], [])
msplit (x : y : xs) = (x : zs, y : ws)
  where
    (zs, ws) = msplit xs


-- Question b

-- merge [] [1, 3, 4, 5] > [1, 3, 4, 5]
-- merge [1, 2, 3, 4] [] > [1, 2, 3, 4]
-- merge [1, 3, 4, 5] [2, 6, 7, 8] > [1, 2, 3, 4, 5, 6, 7, 8]
merge :: Ord a => [a] -> [a] -> [a]
merge [] ys = ys
merge xs [] = xs
merge (x : xs) (y : ys)
  | x <= y      = x : merge xs (y : ys)
  | otherwise   = y : merge (x : xs) ys


-- Question c

-- mergeSort [1, 3, 4, 5, 2, 6, 7, 8] > [1, 2, 3, 4, 5, 6, 7, 8]
mergeSort :: Ord a => [a] -> [a]
mergeSort [] = []
mergeSort [x] = [x]
mergeSort xs = merge (mergeSort zs) (mergeSort ws)
  where
    (zs, ws) = msplit xs


-- Question d

-- quickSort [1, 3, 4, 5, 2, 6, 7, 8] > [1, 2, 3, 4, 5, 6, 7, 8]
quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x : xs) = quickSort [y | y <- xs, y <= x] ++ [x] ++ quickSort [y | y <- xs, y > x]