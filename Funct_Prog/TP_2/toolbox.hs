-- Question a

-- isPalindrome [] > True
-- isPalindrome [1] > True
-- isPalindrome [1, 2, 1] > True
-- isPalindrome [1, 1, 2] > False
isPalindrome :: Eq a => [a] -> Bool
isPalindrome xs = xs == reverse xs


-- Question b

-- pairs [] > []
-- pairs [1] > []
-- pairs [1, 2, 3, 4] > [(1, 2), (2, 3), (3, 4)]
pairs :: [a] -> [(a, a)]
pairs xs 
    | length xs < 2     = []
    | otherwise         = (xs!!0, xs!!1) : pairs (tail xs)
-- [1, 2, 3]!!0 > 1


-- Question c

-- prefixes [1, 2, 3] > [[1], [1, 2], [1, 2, 3]]
prefixes :: [a] -> [[a]]
prefixes [] = []
prefixes xs = prefixes (init xs) ++ [xs]


-- Question d

-- factors [] > [[]]
-- factors [1] > [[1]]
-- factors [1, 2, 3] > [[1], [1, 2], [1, 2, 3], [2], [2, 3], [3]]
factors :: [a] -> [[a]]
factors [] = [[]]
factors xs = prefixes xs ++ factors (tail xs)


-- Question e

-- subseqs [] > [[]]
-- subseqs [1] > [[1], []]
-- subseqs [1, 2, 3] > [[1, 2, 3], [1, 2], [1, 3], [1], [2, 3], [2], [3], []]
