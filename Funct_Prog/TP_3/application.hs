unfold :: (a -> Bool) -> (a -> b) -> (a -> a) -> a -> [b]
unfold p h t x
    | p x = []
    | otherwise = h x : unfold p h t (t x)

fromZeroTo :: Integer -> [Integer]
fromZeroTo x = unfold (> x) id (+1) 0
-- id is the current value


map' :: (a -> b) -> [a] -> [b]
map' f = unfold null (f . head) tail

iterate' :: (a -> a) -> a -> [a]
iterate' f = unfold (const False) id f


-- altMap :: (a -> b) -> (a -> b) -> [a] -> [b]
-- altMap (+10) (*100) [1,2,3,4,5] -> [11,200,13,400,15]
altMap :: (a -> b) -> (a -> b) -> [a] -> [b]
altMap f1 f2 = unfold null (\x -> if even (length x) then f2 (head x) else f1 (head x)) tail


digits :: (Integral a) => a -> [a]
digits = reverse . unfold (== 0) (`mod` 10) (`div` 10)
