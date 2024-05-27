import qualified Data.Foldable as F
import qualified Data.List     as L
import qualified Data.Tuple    as T

-- cell index
type Cell = Int

-- vehical index
type VehicleI = Int

-- vehicle (from cell to cell): 2 consecutive cells for a car and 3 for a truck
newtype Vehicle = Vehicle (Cell,Cell) deriving (Show,Eq)

-- rush hour grid (only the vehicles)
newtype Grid = Grid { vehicles :: [Vehicle] } deriving (Show,Eq)

-- move vehicle to some adjacent cell (one cell distance)
newtype Move = Move (VehicleI, Cell) deriving (Show)

-- a path is a sequence of moves together with the resulting grid
newtype Path = Path ([Move], Grid) deriving (Show)

-- a frontier is a list of paths  (waiting to to be explored further)
newtype Frontier = Frontier [Path]

-- .   .   .   .   .   .
--
-- .   .   .   .   .   o
--                     |
-- .   .   o - o   .   o
--                     |
-- .   .   .   .   .   o
--
-- .   .   .   .   .   .
--
-- .   .   .   .   .   .
grid1 :: Grid
grid1 = Grid {vehicles = specialVehicle:otherVehicles}
  where
    specialVehicle = Vehicle (17,18)
    otherVehicles  = L.map Vehicle [(13,27)]

-- o   o   o   o   o - o
-- |   |   |   |
-- o   o   o   o   o   o
-- |               |   |
-- o   .   o - o   o   o
--                     |
-- .   .   o - o - o   o
--
-- .   .   o   .   o - o
--         |
-- o - o   o   .   o - o
grid2 :: Grid
grid2 = Grid {vehicles = specialVehicle:otherVehicles}
  where
    specialVehicle = Vehicle (17,18)
    otherVehicles  = L.map Vehicle [(13,27),(1,15),(2,9),(3,10),(4,11),(5,6),(12,19),(24,26),(31,38),(33,34),(36,37),(40,41)]

-- o   .   .   o   .   o
-- |           |       |
-- o   .   .   o   .   o
-- |                   |
-- o   .   o - o   .   o
--
-- o - o   o   .   o   o
--         |       |   |
-- .   .   o   .   o   o
--
-- o - o   o - o   .   .
grid3 :: Grid
grid3 = Grid {vehicles = specialVehicle:otherVehicles}
  where
    specialVehicle = Vehicle (17,18)
    otherVehicles  = L.map Vehicle [(4,11),(6,20),(27,34),(36,37),(1,15),(22,23),(26,33),(24,31),(38,39)]

-- o   .   .   o - o - o
-- |
-- o   o - o   o   .   .
--             |
-- o - o   o   o   .   o
--         |           |
-- .   .   o   .   .   o
--                     |
-- .   .   o   o - o   o
--         |
-- .   .   o   o - o - o

vehicleRearCell :: Vehicle -> Cell
vehicleRearCell (Vehicle (r, _)) = r

vehicleFrontCell :: Vehicle -> Cell
vehicleFrontCell (Vehicle (_, f)) = f

specialVehicle :: Grid -> Vehicle
specialVehicle = L.head . vehicles

isHorizontalVehicle :: Vehicle -> Bool
isHorizontalVehicle (Vehicle (r, f)) = r > f-7

isVerticalVehicle :: Vehicle -> Bool
isVerticalVehicle = not . isHorizontalVehicle

exitCell :: Cell
exitCell = 20

leftmostCellInRow :: Cell -> Cell
leftmostCellInRow c = 1 + 7*(c `div` 7)

rightmostCellInRow :: Cell -> Cell
rightmostCellInRow c = 5 + leftmostCellInRow c

topmostCellInColumn :: Cell -> Cell
topmostCellInColumn c = c `mod` 7

bottommostCellInColumn :: Cell -> Cell
bottommostCellInColumn c = 35 + topmostCellInColumn c

validCellPath :: Cell -> Bool
validCellPath c = c > 0 && (c `mod` 7) /= 0 && c < 42

-- show grid functions

emptyGridStr :: [String]
emptyGridStr = L.intersperse iLine lines
  where
    iLine = L.concat (L.replicate 21 " ") ++ "\n"
    line  = L.intercalate "   " (L.replicate 6 ".") ++ "\n"
    lines = L.replicate 6 line

updateGridStr :: (Int,Int) -> Char -> [String] -> [String]
updateGridStr (r,c) ch ss = lss ++ [l] ++ rss
  where
    (lss,s:rss) = L.splitAt (r-1) ss
    (lcs,_:rcs) = L.splitAt (c-1) s 
    l = lcs ++ [ch] ++ rcs

hVehicleUpdateGridStr :: Vehicle -> [String] -> [String]
hVehicleUpdateGridStr (Vehicle (r,f)) = go r
  where 
    go c ss
      | c < f     = go (c+1)
                    . updateGridStr (i, j+2) '-'
                    . updateGridStr (i, j) 'o'
                    $ ss 
      | otherwise = updateGridStr (i,j) 'o' ss
        where
          i = 2*(r `div` 7)+1
          j = 4*((c-1) `mod` 7)+1

vVehicleUpdateGridStr :: Vehicle -> [String] -> [String]
vVehicleUpdateGridStr (Vehicle (r,f)) = go r
  where 
    go c ss
      | c < f     = go (c+7)
                    . updateGridStr (i+1, j) '|'
                    . updateGridStr (i, j) 'o'
                    $ ss 
      | otherwise = updateGridStr (i,j) 'o' ss
        where
          i = 2*(c `div` 7)+1
          j = 4*((c-1) `mod` 7)+1

vehicleUpdateGridStr :: Vehicle -> [String] -> [String]
vehicleUpdateGridStr v@(Vehicle (r,f)) ss
  | isHorizontalVehicle v = hVehicleUpdateGridStr v ss
  | otherwise             = vVehicleUpdateGridStr v ss

toString :: Grid-> String
toString = L.concat . F.foldr vehicleUpdateGridStr emptyGridStr . vehicles



countVehicles :: Grid -> Int
countVehicles = L.length . vehicles

isCar :: Vehicle -> Bool
isCar (Vehicle (r,f)) = if isHorizontalVehicle (Vehicle (r,f)) then r == f - 1 else r == f - 7

isTruck :: Vehicle -> Bool
isTruck (Vehicle (r,f)) = if isHorizontalVehicle (Vehicle (r,f)) then r == f - 2 else r == f - 14

allCell :: [Cell]
allCell = [1..42] L.\\ [7,14,21,28,35,42]

fillCels :: Vehicle -> [Cell]
fillCels (Vehicle (r, f)) = if (isCar (Vehicle (r,f))) then [r,f] else if isHorizontalVehicle (Vehicle (r,f)) then [r,r+1,f] else [r,r+7,f]

occupiedCells :: Grid -> [Cell]
occupiedCells = L.concatMap fillCels . vehicles

freeCells :: Grid -> [Cell]
freeCells g = allCell L.\\ occupiedCells g

adjCells :: Vehicle -> [Cell]
adjCells v@(Vehicle (r,f)) 
    | isHorizontalVehicle v = [c | c <- [r-1, f+1], validCellPath c]
    | otherwise             = [c | c <- [r-7, f+7], validCellPath c]

legalMoves :: Grid -> [Move]
legalMoves g = [Move (i, c) |  i <- [ 0..(countVehicles g) - 1], c <- adjCells (vehicles g !! i), c `elem` freeCells g]

moveVehicleTowards :: Vehicle -> Cell -> Vehicle
moveVehicleTowards v@(Vehicle (r,f)) c
  | isHorizontalVehicle v = if c > r then Vehicle(r + 1, c) else Vehicle(c, r)
  | otherwise             = if c > r then Vehicle(r + 7, c) else Vehicle(c, r + 7)

move :: Grid -> Move -> Grid
move g (Move (i, c)) = Grid $ L.take i vs ++ [moveVehicleTowards (vs !! i) c] ++ L.drop (i + 1) vs
  where
    vs = vehicles g

isSolved :: Grid -> Bool
isSolved g = (vehicleFrontCell $ L.head (vehicles g)) == exitCell

succPaths :: Path -> [Path]
succPaths (Path (ms, g)) = [Path (m:ms, move g m) | m <- legalMoves g]

bfsSearch :: [Grid] -> Frontier -> Maybe [Move]
bfsSearch _ (Frontier []) = Nothing
bfsSearch visited (Frontier (p@(Path (ms, g)):ps))
  | isSolved g = Just (reverse ms)
  | g `elem` visited = bfsSearch visited (Frontier ps)
  | otherwise = bfsSearch (g:visited) (Frontier (ps ++ succPaths p))

bfsSolve :: Grid -> Maybe [Move]
bfsSolve g = bfsSearch [] (Frontier [Path ([], g)])
