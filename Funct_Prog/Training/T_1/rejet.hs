isUpperChar :: Char -> Bool
isUpperChar c = c >= 'A' && c <= 'Z'

rejectNullOrUpperFirstChar1 :: [String] -> [String]
rejectNullOrUpperFirstChar1 [] = []
rejectNullOrUpperFirstChar1 (x : xs)
    | x == ""                           = rejectNullOrUpperFirstChar1 xs
    | head x >= 'A' && head x <= 'Z'    = rejectNullOrUpperFirstChar1 xs
    | otherwise                         = x : rejectNullOrUpperFirstChar1 xs

rejectNullOrUpperFirstChar2 :: [String] -> [String]
rejectNullOrUpperFirstChar2 (x : xs) = [x | x <- xs, x /= "", head x < 'A' || head x > 'Z']

rejectNullOrUpperFirstChar3 :: [String] -> [String]
rejectNullOrUpperFirstChar3 (x : xs) = filter (\x -> x /= "" && (head x < 'A' || head x > 'Z')) (x : xs)

rejectNullOrUpperFirstChar4 :: [String] -> [String]
rejectNullOrUpperFirstChar4 xs = foldr (\x acc -> if x /= ""  && (head x < 'A' || head x > 'Z') then x : acc else acc) [] xs