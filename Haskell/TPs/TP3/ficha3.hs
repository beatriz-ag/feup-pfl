import Data.Char
import Data.List

-- 1
-- está errada
demonst :: (a -> a) -> (a -> Bool) -> [a] -> [a]
demonst f p x = filter p (map (f) x)

demonst2 :: (a -> a) -> (a -> Bool) -> [a] -> [a]
demonst2 f p = map (f) . filter p

-- 2
dec2int :: [Int] -> Int
dec2int x = foldl (\x y -> (x * 10) + y) 0 x

-- 3
zipWithRec :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWithRec f _ [] = []
zipWithRec f (x : xs) (y : ys) = [f x y] ++ zipWithRec f xs ys

-- 4
isort2 :: Ord a => [a] -> [a]
isort2 (x : xs) = foldr insert [x] xs

isort3 :: Ord a => [a] -> [a]
isort3 = foldr insert []

-- 5
maxx, minn :: Ord a => [a] -> a
maxx = foldr1 max
minn = foldr1 min

maxx2, minn2 :: Ord a => [a] -> a
maxx2 = foldr1 max
minn2 = foldr1 min

--6
mdc :: (Int, Int) -> Int
mdc (a, b) = fst (until (\(_, b) -> b == 0) (\(a, b) -> (b, mod a b)) (a, b))

-- 7
-- a
maisfoldr :: [a] -> [a] -> [a]
maisfoldr x y = foldr (:) y x

-- bconcatfoldr :: [[a]] -> [a]
concatfoldr x = foldr (++) [] x

concatfoldr2 :: [[a]] -> [a]
concatfoldr2 x = foldr (\x y -> foldr (:) y x) [] x

concat2 :: [[a]] -> [a]
concat2 = foldr (++) []

-- c
reversefoldr :: [a] -> [a]
reversefoldr x = foldr (\xs ys -> ys ++ [xs]) [] x

-- d
reversefoldl :: [a] -> [a]
reversefoldl x = foldl (\xs ys -> ys : xs) [] x

-- e
elemany :: Eq a => a -> [a] -> Bool
elemany n x = any (\xs -> xs == n) x

elem2 :: Eq a => a -> [a] -> Bool
elem2 x = any (== x)

-- 8
-- a
palavras :: String -> [String]
palavras s
  | length s == 0 = []
  | rest == "" = [takeWhile (\x -> x /= ' ') s]
  | otherwise = [takeWhile (\x -> x /= ' ') s] ++ palavras (tail rest)
  where
    rest = dropWhile (\x -> x /= ' ') s

palavras2 :: String -> [String]
palavras2 str = if s /= "" then takeWhile (/= ' ') s : palavras2 (dropWhile (/= ' ') s) else []
  where
    s = dropWhile (== ' ') str

-- b
despalavras :: [String] -> String
despalavras [] = ""
despalavras (x : xs) = x ++ despalavras xs

despalavras2 :: [String] -> String
despalavras2 x= tail (foldl (\x y -> x ++ " " ++ y) "" x)

-- 9
scanl2 :: (a -> a -> a) -> a -> [a] -> [a]
scanl2 _ z [] = [z]
scanl2 f z (x:xs) = z:scanl2 f (f z x) xs

-- 11
calcPi1 :: Int -> Double
calcPi1 n = sum (take n (zipWith (/) (cycle [4, -4]) [1, 3 ..]))

calcPi2 :: Int -> Double
calcPi2 n = 3 + sum (take n (zipWith (/) (cycle [4, -4]) (zipWith (*) (zipWith (*) [2, 4 ..] [3, 5 ..]) [4, 6 ..])))

-- 14
cifraChave :: String -> String -> String
cifraChave [] _ = ""
cifraChave (x : xs) (y : ys) = [chr ((mod (s1 + s2) 26) + 65)] ++ cifraChave xs ys
  where
    s1 = mod (ord x) 65
    s2 = mod (ord y) 65

binom :: Int -> Int -> Int
binom n k = div (product [1 .. n]) ((product [1 .. k]) * (product [1 .. (n - k)]))

-- 15
-- a
pascal :: [[Int]]
pascal = [[binom n k | k <- [0 .. n]] | n <- [1, 2 ..]]

-- b
