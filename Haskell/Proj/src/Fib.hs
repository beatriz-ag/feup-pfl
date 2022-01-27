import BigNumbers

-- 1.1
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec(n - 2) + fibRec(n - 1)

-- 1.2
fibLista :: (Integral a) => a -> a
fibLista n = (!!) lista (fromIntegral n)
            where lista = 0:1:[get(x-2) + get(x-1) | x<-[2..n]]
                  get x = (!!) lista (fromIntegral x)

-- 1.3
fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = (!!) lista (fromIntegral n)
                   where lista = 0:1:zipWith (+) lista (tail lista)

-- 1.4
fibRecBN :: BigNumber -> BigNumber
fibRecBN (posX, [0]) = (posX, [0])
fibRecBN (posX, [1]) = (posX, [1])
fibRecBN n = somaBN (fibRecBN n2) (fibRecBN n1)
                   where n2 = subBN n (True, [2])
                         n1 = subBN n (True, [1])

--                                                 Auxiliary function 

selectBN :: [BigNumber] -> BigNumber -> BigNumber
selectBN (x:xs) (signal, [0]) = x
selectBN (_:xs) n = selectBN xs (subBN n (True, [1]))


-- 3
fibListaBN :: BigNumber -> BigNumber
fibListaBN n = selectBN lista n
           where lista = (True, [0]):(True, [1]):[somaBN (get (n2 x)) (get (n1 x)) | x<-limit (somaBN n (True, [1]))]
                 get x = selectBN lista x
                 n2 x = subBN x (True, [2])
                 n1 x = subBN x (True, [1])

limit :: BigNumber -> [BigNumber]
limit n = takeWhile (\x -> (getBigger n x) /= x) l
        where l = (True, [2]):zipWith (somaBN) l (cycle [(True, [1])])

fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN n = selectBN lista n
                  where lista = (True, [0]):(True, [1]):zipWith (somaBN) lista (tail lista)
