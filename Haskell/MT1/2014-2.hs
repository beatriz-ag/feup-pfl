{- -- Exame 2014 2 -}

{- 1
### a
[1,3,3,4,5]
### b
7
### c
[""."c"]
### d
4
### e
[1,4,7]
### f
"CDEF"
### g
[(Int,String)]
### h
[a] -> [a] -> [a]
### i
Int -> [a] -> [a]
### j
(a -> Bool) -> [a] -> [a]
-}

-- 2
intersperse :: a -> [a] -> [a]
intersperse _ [] = []
intersperse c (x:xs) | null xs = [x]
                     | otherwise = x:c:intersperse c xs

intersperse2 :: a -> [a] -> [a]
intersperse2 n [x] = [x]
intersperse2 n (x:xs) = x:n:intersperse2 n xs

group :: String -> [String]
group "" = []
group (x:xs) = l:group r
    where l = takeWhile (==x) (x:xs)
          r = dropWhile (==x) xs

-- Eq a => [a] -> [a]