-- 1.1
testaTriangulo :: Float -> Float -> Float -> Bool
testaTriangulo a b c = a < sum [b,c] && b < sum [a,c] && c < sum [a,b]

-- 1.2
areaTriangulo :: Float -> Float -> Float -> Float
areaTriangulo a b c = sqrt s*(s - a)*(s - b)*(s-c)
                      where s = (a + b + c)/2
-- 1.3
metades1 :: [a] -> ([a],[a])
metades1 x = (take (div (length x) 2) x, drop (div (length x) 2) x)

metades2 :: [a] -> ([a],[a])
metades2 x = (take l x, drop l x)
            where l = div (length x) 2

metades3 :: [a] -> ([a],[a])
metades3 x = let l = div (length x) 2
             in (take l x, drop l x)

-- 1.4
  -- a
lastv2 :: [a] -> a
lastv2 x = head (reverse x)

lastv3 :: [a] -> a
lastv3 x = head (drop size  x)
          where size = length x - 1

  --b
initv2 :: [a] -> [a]
initv2 x = reverse (tail (reverse x))

initv3 :: [a] -> [a]
initv3 x = reverse (drop 1 (reverse x))

initv4 :: [a] -> [a]
initv4 x = take (length x - 1) x

-- 1.5
  -- to do

-- 1.6
raizes :: Float -> Float -> Float -> (Float, Float)
raizes a b c = ((-b + sqrt s) / (2 * a), (-b - sqrt s) / (2 * a))
               where s = if (b^2 >= (4*a*c)) then b^2 - (4 * a * c) else 0

-- 1.7
  --a
  -- [Char]
  --b
  -- (Char, Char, Char)
  --c
  -- [(Bool, Char)]
  --d
  -- ([Bool], [Char])
  --e
  -- [[a] -> [a]]
  --f
  -- [Bool -> Bool]

-- 1.8
    --a
      -- segundo :: [a] -> a
    --b
      -- trocar :: (a,b) -> (b,a)
    --c
      -- par :: a -> b -> (a,b)
    --d
      -- dobro :: Num a => a -> a
    --e
      -- metade :: Fractional a => a -> a
    --f
      -- minuscula :: [Char] -> Bool
    --g
      -- intervalo :: Ord a => a -> a -> a ->  Bool
    --h
      -- palindromo :: Eq a => [a] -> Bool
    --i
      -- twice :: (a -> a) -> a -> a

-- 1.9
classifica :: Int -> String
classifica x | x <= 9 = "reprovado"
             | x <= 12 = "suficente"
             | x <= 15 = "bom"
             | x <= 18 = "muito bom"
             | x <= 20 = "muito bom com distinção"
             | otherwise = "invalido"
-- 1.12
xor :: Bool -> Bool -> Bool
xor True False = True
xor True True = False
xor False False = False
xor False True = True

-- 1.14
  --a
curtav1 :: [a] -> Bool
curtav1 x = l == 0 || l == 1 || l == 2
        where l = length x

curtav2 :: [a] -> Bool
curtav2 x = length x == 0
curtav2 x = length x == 1
curtav2 x = length x == 2

-- 1.15
  --a
medianav1 :: Ord a => a -> a -> a -> a
medianav1 a b c | (a < b) && (b < c) = b
                | (b < c) && (c < a) = c
                | otherwise = a

  --b
medianav2 :: Int ->  Int -> Int -> Int
medianav2 a b c = sum [a,b,c] - mi - ma
                  where ma = max (max a b) (max b c)
                        mi = min (min a b) (min b c)

-- 1.16
converte100 :: Int -> String
converte100 1 = "um"
converte100 2 = "dois"
converte100 3 = "tres"
converte100 4 = "quatro"
converte100 5 = "cinco"
converte100 6 = "seis"
converte100 7 = "sete"
converte100 8 = "oito"
converte100 9 = "nove"
converte100 10 = "dez"
converte100 20 = "vinte"
converte100 30 = "trinta"
converte100 40 = "quarenta"
converte100 50 = "cinquenta"
converte100 60 = "sessenta"
converte100 70 = "setenta"
converte100 80 = "oitenta"
converte100 90 = "noventa"
converte100 100 = "cem"
converte100 x  = if (x <= 100) then converte100 (x-r) ++ " e " ++ converte100 (r) else "invalido"
                where r = mod x 10

converte1000 :: Int -> String
converte1000 100 = "cento"
converte1000 200 = "duzentos"
converte1000 300 = "trezentos"
converte1000 400 = "quatrocentos"
converte1000 500 = "quinhentos"
converte1000 600 = "seiscentos"
converte1000 700 = "setecentos"
converte1000 800 = "oitocentos"
converte1000 900 = "novecentos"
converte1000 x | x <= 100 = converte100 x
               | x < 1000 = converte1000 (x - r) ++ " e " ++ converte100 (mod x 100)
               | otherwise = "invalido"
               where r = mod x 100

converte :: Int -> String
converte x | x < 1000 = converte1000 x
           | otherwise = converte1000 (div x 1000) ++ " mil e " ++ converte1000 (mod x 1000)
