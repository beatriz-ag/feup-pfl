{-Exame 2018-}

{- 1
### a 
[[1,2,3],[4],[5]]
### b
5
### c 
[8,6,4,2,0]
### d 
9
### e 
[(1,1),(2,1),(3,1),(4,1),(2,2),(3,2),(4,2)]
### f 
[2,4,8,16,32]
### g 
[2^x - 1 | x <- [1..10]]
### h 
15
### i 
([Bool],[Char])
### j
a -> b -> (a,b)
### k
Eq a => [a] -> [a] -> [a]
### l
Eq a => [a] -> Bool
-}

-- 3
niguaisr :: Int -> a -> [a]
niguaisr 0 _ = []
niguaisr n x = x:niguaisr (n-1) x

niguais :: Int -> a -> [a]
niguais n x = [x | y <- [1..n]]

-- 4
merge :: Ord a =>  [a] -> [a] -> [a]
merge [] x = x
merge x [] = x
merge lx@(x:xs) ly@(y:ys) | y < x = y:merge lx ys
                          | otherwise = x:merge xs ly

-- 5
length_zip :: [a] -> [(a,Int)]
length_zip x = zip x [(length x),(length x -1)..1]

-- 6
--Joni
decompor :: Int -> [Int] -> [[Int]]
decompor n l = aux n l []

aux :: Int -> [Int] -> [Int] -> [[Int]]
aux 0 n l = [l]
aux v n l = [z | (f, s) <- [(v - x, x) | x <- n, v - x >= 0], z <- aux f n (s : l)]

-- Tigas
decomporAux :: Int -> [Int] -> [Int] -> [[Int]]
decomporAux _ [] _ = []
decomporAux 0 _ change = [change]
decomporAux v lst@(x : xs) change
  | v < 0 = []
  | otherwise = decomporAux (v - x) lst (x : change) ++ decomporAux v xs change

decompor2 :: Int -> [Int] -> [[Int]]
decompor2 v lst = decomporAux v lst []


decompor3 :: Int -> [Int] -> [[Int]]
decompor3 0 x = [x]
decompor3 _ [] = [[]]
decompor3 x l= [take n l ++ v | n <-[1..length l], v <- decompor3 (x - sum l) (drop n l)]
