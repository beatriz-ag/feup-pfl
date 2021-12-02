import Data.List
import Data.Char

-- 1
demonst :: (a -> a) -> (a -> Bool) -> [a] -> [a]
demonst f p x = filter p (map(f) x)

-- 2
dec2int :: [Int] -> Int
dec2int x = foldl (\x y -> (x * 10 ) + y) 0 x

-- 3
zipWithRec :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWithRec f _ [] = []
zipWithRec f (x:xs) (y:ys) = [f x y] ++ zipWithRec f xs ys

-- 4
isort2 :: Ord a => [a] -> [a]
isort2 (x:xs) = foldr insert [x] xs

-- 7
  -- a
maisfoldr :: [a] -> [a] -> [a]
maisfoldr (x) (y) = foldr(:) y x

  -- b
concatfoldr :: [[a]] -> [a]
concatfoldr x = foldr (++) [] x

concatfoldr2 :: [[a]] -> [a]
concatfoldr2 x = foldr (\x y -> foldr(:) y x) [] x

  -- c
reversefoldr :: [a] -> [a]
reversefoldr x = foldr (\xs ys -> ys++[xs]) [] x

  -- d
reversefoldl :: [a] -> [a]
reversefoldl x = foldl (\xs ys -> ys:xs) [] x

  -- e
elemany :: Eq a => a -> [a] -> Bool
elemany n x = any (\xs -> xs == n) x

-- 8
  -- a
palavras :: String -> [String]
palavras s  | length s == 0 = []
            | rest == "" = [takeWhile (\x -> x /= ' ') s]
            | otherwise =  [takeWhile (\x -> x /= ' ') s] ++ palavras (tail rest)
           where rest = dropWhile (\x -> x /= ' ') s

  -- b
despalavras :: [String] -> String
despalavras [] = ""
despalavras (x:xs) = x ++ despalavras xs


-- 11
calcPi1 :: Int -> Double
calcPi1 n = sum (take n (zipWith (/) (cycle [4, -4])  [1,3..]))

calcPi2 :: Int -> Double
calcPi2 n = 3 + sum (take n (zipWith (/) (cycle [4, -4]) (zipWith (*) (zipWith (*) [2,4..] [3,5..]) [4,6..])))

-- 14
cifraChave :: String -> String -> String
cifraChave [] _ = ""
cifraChave (x:xs) (y:ys) = [chr ((mod (s1 + s2) 26) + 65)] ++ cifraChave xs ys
                          where s1 = mod (ord x) 65
                                s2 = mod (ord y) 65

binom :: Int -> Int -> Int
binom n k = div (product [1..n]) ((product [1..k]) * (product [1..(n-k)]))

-- 15
  -- a
pascal :: [[Int]]
pascal = [[binom n k | k <- [0..n]] | n <- [1,2..]]


  -- b
