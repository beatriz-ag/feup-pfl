-- 3 4 7 8 10 13 14 15 16 17 18 22 23 27 29 32 33 35 37 40 42 43
-- HO-3
-- a
applyN :: (a -> b -> c) -> (b -> a -> c)
applyN f = (\x y -> f y x)

ta :: (a-> b -> b) -> b -> a -> b
ta f b a = f a b

sortByCond :: Ord a => [a] -> (a -> a -> Bool) -> [a]
sortByCond [] _ = []
sortByCond (l:ls) f = sortByCond menores f ++ [l] ++ sortByCond maiores f
                      where menores = [x | x <- ls, f x l]
                            maiores = [x | x <- ls, not (f x l)]

myCaril:: ((a,b) -> c) -> (a -> b -> c)
myCaril f = (\x y -> f (x ,y))
