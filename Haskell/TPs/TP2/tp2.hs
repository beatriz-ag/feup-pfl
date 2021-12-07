-- 2.1
somaQuadrados = sum [ i^2 | i <- [1..100]]

-- 2.2
  --a
aprox1 :: Int -> Double
aprox1 n = 4 * (sum [((-1)^n)/fromIntegral((2*n) + 1) | n <- [0..n]])

  --b
aprox2 :: Int -> Double
aprox2 n = sqrt (12 * (sum [((-1)^n)/fromIntegral((n+1)^2)]))

-- 2.4
divprop :: Integer -> [Integer]
divprop n = [i | i <- [1..n - 1], (mod n i == 0)]

-- 2.5
perfeitos :: Integer -> [Integer]
perfeitos n = [x | x <- [1..n], sum (divprop x) == x]

-- 2.6
pitagoricos :: Integer -> [(Integer, Integer, Integer)]
pitagoricos n = [(x,y,z) | x <- l, y <- l, z <- l, (x^2 + y^2 == z^2)]
              where l = [1..n]

-- 2.7
primo :: Integer -> Bool
primo n = length (divprop n) == 1

-- 2.8
binom :: Integer -> Integer -> Integer
binom n k = div (product [1..n]) ((product [1..k]) * (product [1..(n-k)]))

pascal :: Integer -> [[Integer]]
pascal n = [[binom n k | k <- [1..n]] | n <- [1..n]]

-- 2.10
  -- a
myand :: [Bool] -> Bool
myand (x:xs) = x && myand xs
myand [] = True

  --b
myor :: [Bool] -> Bool
myor (x:xs) = x || myor(xs)
myor [] = True

  --c
myconcat :: [[a]] -> [a]
myconcat (x:xs) =  x ++ ( myconcat xs )
myconcat [] = []

  --d
myreplicate :: Int -> a -> [a]
myreplicate 0 n = []
myreplicate n x = [x] ++ (myreplicate (n-1) x)

  --e
my :: [a] -> Int -> a
my (x:xs) n = if n == 0 then x else (my xs (n-1))

  --f
myelem :: Eq a => a -> [a] -> Bool
myelem n (x:xs) = if (n == x) then True else myelem n xs
myelem n [] = False

-- 2.11
myconcat2 :: [[a]] -> [a]
myconcat2 x = [i | y <- x, i <- y]

myreplicate2 :: Int -> a -> [a]
myreplicate2 n x = [x | z <- [1..n]]

my2 :: [a] -> Int -> a
my2 x n = head (reverse [i | i <- x, z <-[1..n]])

-- 2.12
forte :: String -> Bool
forte s =  size && min && mas && algo
          where size = length s >= 8
                min = or [(i > 'a' && i < 'z') | i <- s]
                mas = or [(i >'A' && i < 'Z') | i <- s]
                algo = or [(i > '0') | i <- s]

-- 2.14
nubrecursivo :: Eq a => [a] -> [a]
nubrecursivo [] = []
nubrecursivo (x:xs) = [x] ++ nubrecursivo newlist
                    where newlist = [i | i <- xs, (i /= x)]

-- 2.15
myintersperse :: a -> [a] -> [a]
myintersperse n (x:xs) | length xs > 0 =  [x] ++ [n] ++ myintersperse n xs
                       | otherwise = [x]

-- 2.16
algarismosAux :: Int -> [Int]
algarismosAux n | n > 0 = [uni] ++ algarismosAux resto
                | otherwise = []
                where uni = mod n 10
                      resto = div n 10
algarismos :: Int -> [Int]
algarismos n = reverse (algarismosAux n)

algarismos2 :: Int -> [Int]
algarismos2 0 = []
algarismos2 n = [mod n 10] ++ algarismos2 (div n 10)

-- 2.20
  --a
insert :: Ord a => a -> [a] -> [a]
insert n x = menores ++ [n] ++ maiores
                where menores = [y | y <- x, y <= n]
                      maiores = [y | y <- x, y > n]

  --b
insort :: Ord a => [a] -> [a]
insort [] = []
insort (x:xs) = insert x (insort xs)

-- 2.23
  --a
addPoly1 :: [Int] -> [Int] -> [Int]
addPoly1 x y = zipWith (+) x y

addPoly2 :: [Int] -> [Int] -> [Int]
addPoly2 (x:xs) (y:ys) = [x + y] ++ addPoly2 xs ys
addPoly2 [] [] = []
addPoly2 [] (y:ys)  = [y] ++ addPoly2 [] ys
addPoly2 (x:xs) [] = [x] ++ addPoly2 xs []

  --b
multPoly :: [Int] -> [Int] -> [Int]
multPoly [] _ = [0]
multPoly (x:xs) y = addPoly2 (( map (*x) y))  (0: multPoly xs y)

-- Falta fazer o 22, 21, 19, 18, 17, 13, 12, 11
