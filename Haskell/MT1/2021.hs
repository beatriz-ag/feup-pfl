{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
{-Exame 2021-}

{- 1
### a
[4,3,2,1]
### b
[4,7,10]
### c
[(1,4),(2,2)]
### d
(3,'c')
### e
2
### f
[(Int,[Int])]
### g
Num a => [a] -> [a]
### h
(a -> Bool) -> [a] -> [a]
-}

primo :: Int -> Bool
primo x = length [y | y <- [1 .. floor (sqrt (fromIntegral x))], mod x y == 0] == 1

gemeos :: Integer -> (Integer, Integer)
gemeos n = head (take 1 [(x,x+2) | x <- [n..], primo (fromIntegral x) && primo (fromIntegral (x+2))])

-- 3
type Point = (Double, Double)

boundingBox :: [Point] -> (Point, Point)
boundingBox l = ((minimum x, minimum y),(maximum x, maximum y))
            where x = [xs | (xs,_) <-l]
                  y = [ys | (_,ys) <-l]

-- 4
data Set a = Empty | Node a (Set a) (Set a) deriving Show

insert :: Ord a => a -> Set a -> Set a
insert x Empty = Node x Empty Empty
insert x (Node y esq dir) | x == y = Node y esq dir
                          | x < y = Node y (insert x esq) dir
                          | otherwise = Node y esq (insert x dir)

exists :: (a -> Bool) -> Set a -> Bool
exists f Empty = False
exists f (Node y esq dir) = f y || exists f esq || exists f dir
