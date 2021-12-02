import Stack

-- 1
parentAux :: String -> Stack Char -> Bool
parentAux [] stk = isEmpty stk
parentAux (x:xs) stk
          | x == '(' || x == '[' || x == '{' = parentAux xs (push x stk)
          | x == ']' = not (isEmpty stk) && top stk == '[' && parentAux xs (pop stk)
          | x == ')' = not (isEmpty stk) && top stk == '(' && parentAux xs (pop stk)
          | x == '}' = not (isEmpty stk) && top stk == '{' && parentAux xs (pop stk)

parent :: String -> Bool
parent str = parentAux str empty


-- 2
calc :: Stack Float -> String -> Stack Float
calc stk [] = stk
calc stk x
      | head x == '+' =  push  ((n1) + (n2)) stk
      | head x == '*' =  push  ((n1) * (n2)) stk
      | head x == '-' =  push  ((n1) - (n2)) stk
      | head x == '/' =  push  ((n1) / (n2)) stk
      | otherwise = push (read x::Float) stk
      where n2 = top stk
            n1 = top (pop stk)


calcularAux :: Stack Float -> [String] -> Stack Float
calcularAux stk [] = stk
calcularAux stk (x:xs) = calcularAux (calc stk x) xs

calcular :: String -> Float
calcular x = top (calcularAux empty (words x))

calcularP :: IO ()
calcularP = do
            putStr "Insira a expressão: "
            exp <- getLine
            putStr (show (calcular(exp)))


-- 4

data Set a = Empty
-- conjunto vazio
| Node a (Set a) (Set a)
-- elemento, sub-conjunto dos
