{- -- Exame 2014 1 -}

-- 1
insert :: Ord a => a -> [a] -> [a]
insert n (x:xs) | null xs  && n > x = x:[n]
                | null xs && x > n = n:[x]
                | n > x = x:insert n xs
                | otherwise = n:x:xs

insert2 :: Ord a => a -> [a] -> [a]
insert2 x xs = takeWhile (<x) xs ++ [x] ++ dropWhile (<x) xs

{- 2
0
1 +  tamanho esq + tamanho dir)

0
1 + max (altura esq) (altura dir)
-}