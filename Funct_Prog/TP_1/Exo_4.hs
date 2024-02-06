-- :load Exo_4.hs dans le ghci

-- ########## Partie a ########## 

myAverage :: Float -> Float -> Float -> Float
myAverage x y z = (x + y + z) / 3

-- ########## Partie b ##########

myMin2 :: Int -> Int -> Int
myMin2 x y 
    | x < y = x 
    | otherwise = y

myMin3 :: Int -> Int -> Int -> Int
myMin3 x y z
    | x < y && x < z = x
    | y < x && y < z = y
    | otherwise = z

-- ########## Partie c ##########

myAdd :: Int -> Int -> Int
myAdd x y
    | x == 0 && y == 0 = 0
    | x/= 0 && y == 0 = x
    | x == 0 && y /= 0 = y
    | otherwise = myAdd (succ x) (pred y)
    -- x + y = (x + 1) + (y - 1)

-- ########## Partie d ##########    

myMult :: Int -> Int -> Int
myMult x y
    | x == 0 || y == 0 = 0
    | otherwise = myAdd (myMult x (pred y)) x 
    -- x * y = x * (y - 1) + x 

-- ########## Partie e ##########

myFact :: Int -> Int
myFact n
    | n == 0 = 1
    | otherwise = n * myFact(n - 1)