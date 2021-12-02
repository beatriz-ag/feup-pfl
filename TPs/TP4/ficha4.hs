-- 7 9 10 11 12

data Arv a = Vazia | No a (Arv a) (Arv a) deriving (Show)

-- 4.7
sumArv :: Num a => Arv a -> a
sumArv Vazia = 0
sumArv (No a esq dir) = a + sumArv esq + sumArv dir

-- 4.8
listar :: Arv a -> [a]
listar Vazia = []
listar (No a esq dir) = listar dir ++ [a] ++ listar esq

-- 4.9
nivel :: Int -> Arv a -> [a]
nivel 0 (No a esq dir) = [a]
nivel n (No a esq dir) = nivel (n-1) esq ++ nivel (n-1) dir

-- 4.10
mapArv :: (a -> b) -> Arv a -> Arv b
mapArv f Vazia = Vazia
mapArv f (No a esq dir) = No (f a) (mapArv f esq) (mapArv f dir)

-- 4.11
inserir :: Ord a => a -> Arv a -> Arv a
inserir x Vazia = No x Vazia Vazia
inserir x (No y esq dir)
        | x==y = No y esq dir -- já ocorre; não insere
        | x<y = No y (inserir x esq) dir -- insere à esquerda
        | x>y = No y esq (inserir x dir) -- insere à direita

construir :: Ord a => [a] -> Arv a
construir [] = Vazia
construir (x:xs) = inserir x (construir xs)

construirPart :: [a] -> Arv a
construirPart [] = Vazia
construirPart list = No x (construirPart xs) (construirPart xs)
    where n = length list `div` 2 -- ponto médio
          xss = take n list
          x:xs = drop n list

    -- a
calcAltura :: Arv a -> Int
calcAltura Vazia = 0
calcAltura (No a esq dir) = 1 + max (calcAltura esq)  (calcAltura dir)

alturaPart :: Int -> Int
alturaPart n = calcAltura (construirPart [1..n])

  -- b
alturaSimp :: Int -> Int
alturaSimp n = calcAltura (construir [1..n])


-- 4.12
  -- a
maisDir :: Arv a -> a
maisDir (No x _ Vazia) = x
maisDir (No _ _ dir) = maisDir dir

  -- b
removeDir :: Ord a => a -> Arv a -> Arv a
removeDir x Vazia = Vazia
removeDir x (No y Vazia dir)
              | x == y = dir
removeDir x (No y esq Vazia)
              | x == y = esq
removeDir x (No y esq dir)
              | x<y  = No y (removeDir x esq) dir
              | x>y  = No y esq (removeDir x dir)
              | x==y = let z = maisDir esq in No z (removeDir z esq) dir
