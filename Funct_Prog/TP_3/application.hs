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