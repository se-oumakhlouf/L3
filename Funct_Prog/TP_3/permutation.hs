import Data.List

distrib :: a -> [a] -> [[a]]
distrib n x = init $ zipWith (++) (tails x) (inits x)