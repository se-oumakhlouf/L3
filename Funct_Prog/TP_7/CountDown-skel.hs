module Countdown where

import qualified Data.Foldable as F
import qualified Data.List     as L

-- Inner type
type Value = Int

-- Arithmetic expression
data AExpr = Num Value | App BOp AExpr AExpr

-- binary operator
data BOp = Add | Sub | Mul | Div

-- Computation (i.e., valued arithmetic expression)
newtype VAExpr = VAExpr (AExpr,Value)

instance Show BOp where
  show Add = "+"
  show Sub = "-"
  show Mul = "x"
  show Div = "/"

instance Show AExpr where
  show (Num x) = show x
  show (App op e1 e2) = "("      ++
                        show e1  ++
                        " "      ++
                        show op  ++
                         " "     ++
                        show e2  ++
                        ")"

instance Show VAExpr where
  show (VAExpr (e,v)) = show e ++ " = " ++ show v

sublists' :: [a] ->  [[a]]
sublists' [] = [[]]
sublists' (x : xs) = map (x :) (sublists' xs) ++ sublists' xs

-- get rids of empty lists
sublists :: [a] -> [[a]]
sublists all = filter (not . null) (sublists' all)

legal1 :: BOp -> Value -> Value -> Bool
legal1 Add _ _ = True
legal1 Sub x y = (y > x) == False
legal1 Div _ 0 = False
legal1 Div x y = mod x y == 0
legal1 Mul _ _ = True

-- might need to use legal1
apply :: BOp -> Value -> Value -> Value
apply Add x y = x + y
apply Sub x y = if legal1 Sub x y then x - y else error "Illegal operation"
apply Div x y = if legal1 Div x y then div x y else error "Illegal operation"
apply Mul x y = x * y

value :: AExpr -> Value
value (Num x) = x
value (App op e1 e2) = apply op (value e1) (value e2)

-- merge [1, 4, 7] [2, 3, 5, 6]
merge :: Ord a => [a] -> [a] -> [a]
merge xs [] = xs
merge [] ys = ys
merge xs@(x : xs') ys@(y : ys')
  | x <= y = x : merge xs' ys
  | otherwise = y : merge xs ys'

-- not complete
unmerges1 :: [a] -> [([a], [a])]
unmerges1 [x, y] = [([x], [y])]
unmerges1 (x : xs) = [([x], xs)] ++ [(x : ls, rs) | (ls, rs) <- unmerges1 xs]





