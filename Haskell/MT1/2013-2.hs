{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

{- -- Exame 2013 2 -}

-- 1
nodups :: Eq a => [a] -> [a]
nodups [] = []
nodups (x : xs)
  | null xs = [x]
  | x == head xs = nodups xs
  | otherwise = x : nodups xs

--  Eq a => [a] -> [a]

{- 2
Ord a => a -> Arv a -> Arv a
(No x Vazia Vazia)
No y esq dir
No y (inserir x esq) dir
No y esq (inserir x dir)
-}

data Box
  = Text String
  | Horiz Box Box
  | Vert Box Box

-- 3
altura, largura :: Box -> Int
altura (Text _) = 1
altura (Horiz x y) = max (altura x) (altura y)
altura (Vert x y) = 1 + max (altura x) (altura y)
largura (Text x) = length x
largura (Horiz x y) = largura x + largura y
largura (Vert x y) = max (largura x) (largura y)
