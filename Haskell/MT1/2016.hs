{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{- -- Exame 2016 -}

{- 1
### a
[2,3,1,4,4]
### b
[0,10,20,30,40]
### c
[[],[3,4],[5]]
### d
5
### e
[1,1,1,1,1,1]
### f
[(1,4),(2,3),(3,2)]
### g
[ 2 ^ x | x <- [0,6]
### h 
0
### i
Num a => [(Bool,a)]
### j
(a,b) -> (b,a)
### k
(Ord a, Num a) => a -> a -> a
### l
[([a],a)]
-}

-- 2
ttriangulo :: (Eq a, Num a) => a -> a -> a -> String
ttriangulo x y z | x == y && y  == z = "Equilatero"
                 | x /= y && x /= z && y /= z = "Escaleno"
                 | otherwise = "Isosceles"

pitagoras :: (Ord a, Num a) => a -> a -> a -> Bool
pitagoras x y z = (head c) ^2 + (last c) ^2 == h^2
                where h = max (max x y) z
                      c = [ca | ca <- [x,y,z], ca /= h]

maiores :: Ord a => [a] -> [a]
maiores [x] = []
maiores (x:xs) | x <= head xs = maiores xs
               | otherwise = x:maiores xs

maiores2 :: Ord a => [a] -> [a]
maiores2 l = [x | (x, y) <- zip l (tail l), x > y]

somapares2 :: (Num a) => [(a, a)] -> [a]
somapares2 = map (uncurry (+))

somaparesr :: (Num a) => [(a, a)] -> [a]
somaparesr [] = []
somaparesr (x : xs) = fst x + snd x : somaparesr xs

somapares :: (Num a) => [(a,a)] -> [a]
somapares l= [ x + y | (x,y) <- l]

itera :: Int -> a -> (a -> a) -> a
itera 0 n _ = n
itera l n f = itera (l-1) (f n) f 

mult :: Int -> Int -> Int
mult x n = itera 1 n (*x)

