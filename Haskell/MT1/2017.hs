{- -- Exame 2017-}

{- 1
### a
[1,5,4,3]
### b
[5,6,9]
### c
[2]
### d
[0,3,6,9,12]
### e
4
### f
[1,2,3,3,6,9]
### g
[1,2,3]
### h
[if mod x 2 == 0 then x else -x | x <- [0..10]]
### i
8
### j
([Char],[Float])
### k
(a,b) -> a
### l
Ord a => a -> a -> a -> Bool
### m
[a] -> a
-}

-- 2
numEqual :: (Eq a, Num a) => a -> a -> a -> Int
numEqual n m p
  | n == p && p == m = 3
  | n /= p && p /= m && n /= m = 0
  | otherwise = 2

-- 3
area :: Floating a => a -> a -> a -> a -> a -> a -> a
area a b c d p q = 1.0 / 4.0 * sqrt (4 * p^2 * q^2 - (b^2 + d^2 - a^2 - c^2)^2)

-- 4
enquantoPar :: [Int] -> [Int]
enquantoPar [] = []
enquantoPar l | even (head l) = head l : enquantoPar (tail l)
              | otherwise = []

-- 5
nat_zip :: [a] -> [(Int, a)]
nat_zip = zip [1..]

-- 6
-- a 
quadrados :: [Int] -> [Int]
quadrados xs = map (^ 2) xs

quadrados2 :: [Int] -> [Int]
quadrados2 l = [x^2 | x <- l]

aux2 :: Int -> [Int] -> [Int]
aux2 0 _ = []
aux2 n l = s:aux2 (n - s) nl
        where nl = takeWhile (<=n) l
              s = last nl


partes :: Int -> [[Int]]
partes 0 = []
partes x = filter crescente (aux x [])

aux :: Int -> [Int] -> [[Int]]
aux 0 l = [l]
aux v l = [z | (f, s) <- [(v - x, x) | x <- [1 .. v], v - x >= 0], z <- aux f (s : l)]
 
crescente :: [Int] -> Bool
crescente [] = False
crescente [a] = True
crescente (x : y : xs)
  | x > y = False
  | otherwise = crescente (y : xs)
  