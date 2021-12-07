import Data.Char

{- 
# Exame 2013 1
## 1
### a
1
### b
[3,2,1,5,4]
### c
2
### d
9
### e
6
### f
4
### g
([Int],[String])
### h
 Num a => a -> a -> a
### i
(a -> b) -> [a] -> [b]
### j
Int -> [a] -> [a]
-}

-- 2
countr :: (a -> Bool) -> [a] -> Int
countr _ [] = 0
countr f (x : xs)
  | f x = 1 + countr f xs
  | otherwise = countr f xs

count :: (a -> Bool) -> [a] -> Int
count f l = length (filter f l)

extras :: String -> Int
extras = count (not . isLetter)

-- 3

split :: Char -> String -> [String]
split c x
  | aux == x = [aux]
  | otherwise = aux : split c (tail (dropWhile (/= c) x))
  where
    aux = takeWhile (/= c) x