module BigNumbers where

import Data.Char

-- 2.1 definition

-- true = positivo
-- false = negativo
type BigNumber = (Bool, [Int])

--                                                 Auxiliary functions 

getBiggerAux :: Bool -> [Int] -> [Int] -> [Int]
getBiggerAux isPositive [] [] = []
getBiggerAux isPositive (x:xs) (y:ys)
                          | x == y = x:getBiggerAux isPositive xs ys
                          | isPositive = if x > y then x:xs else y:ys
                          | otherwise = if x < y then x:xs else y:ys


getBigger :: BigNumber -> BigNumber -> BigNumber
getBigger (posX, (x:xs)) (posY, (y:ys))
            | posX && not posY = (posX, x:xs)                           -- x positivo, y negativo
            | not posX && posY = (posY, y:ys)                           -- x negativo, y positivo
            | posX && length xs > length ys = (posX, x:xs)              -- ambos positivos, x com mais casas unitárias
            | posX && length xs < length ys = (posY, y:ys)              -- ambos positivos, y com mais casas unitárias
            | not posX && length xs > length ys = (posY, y:ys)          -- ambos negativos, y com mais casas unitárias
            | not posX && length xs < length ys = (posX, x:xs)          -- ambos negativos, y com mais casas unitárias
            | otherwise = (posX, getBiggerAux  (posX) (x:xs) (y:ys))    -- x e y com o mesmo número de casas unitárias


-- 2.2 scanner

scanner :: String -> BigNumber
scanner [] = (True, [])
scanner (x:xs)
        | x == '-' = (False, converter xs)
        | otherwise = (True, converter (x:xs))
        where converter (x:xs)                                                                        -- Converte String só com dígitos para [Int]
                  | not (isDigit x) = error "This string cannot be converted into a BigNumber"
                  | length xs == 0 = [digitToInt x]
                  | otherwise = digitToInt x : converter xs                                           -- Converte dígito a dígito e acumula numa lista


-- 2.3 output

output ::  BigNumber -> String
output (positive, list)
                    | (length list == 1) && (head list == 0) = "0"                  -- (True, [0]) = (False, [0]) = "0"
                    | not positive = "-" ++ converter list
                    | otherwise = converter list
                    where converter (x:xs)                                          -- Converte [Int] para String
                                | length xs == 0 = [intToDigit x]
                                | otherwise = intToDigit x : converter xs           -- Converte um a um e acumula numa lista


-- 2.4 sum

auxSoma :: [Int] -> [Int] -> [Int]
auxSoma x [] = reverse x                                                            -- dado que a lista vem revertida (para facililar cálculos) o retorno deverá ser revertido
auxSoma [] y = reverse y
auxSoma (x:xs) (y:ys)
            | carry == 0 = auxSoma xs ys ++ [x + y]                                 -- não há carry
            | otherwise = auxSoma applyCarry ys ++ sumResult                        -- há carry
            where carry = div (x + y) 10
                  applyCarry = reverse (auxSoma xs [carry])
                  sumResult = [mod (x + y) 10]

somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN (posX, x) (posY, y)
            | posX == posY = (posX, auxSoma (reverse x) (reverse y))                -- sinais iguais, o sinal preserva-se e somam-se os valores [Int]
            | posX && not posY = subBN (posX, x) (not posY, y)                      -- {x + (-y)} <=> {x - y} -> subBN x y
            | otherwise = subBN (posY, y) (not posX, x)                             -- {(-x) + y} <=> {y - x} -> subBN y x


-- 2.5 sum

subBNaux :: [Int] -> [Int] -> [Int]
subBNaux x [] = reverse x                                                                                               -- dado que a lista vem em reverse - para facilitar cálculos - o retorno do resultado deverá ser em reverse
subBNaux x [0] = reverse x
subBNaux [0] y = reverse y
subBNaux [] y = reverse y
subBNaux (x:xs) (y:ys)
        | length ys > 0 = if (sub xs y_carry == [0]) then [result] else sub xs y_carry ++ [result]                      -- enquanto houver ys para subtrair irá ocorrer a recursao tendo um if para evitar [0,2,2]
        | otherwise = if (sub xs [carry] == [0]) then [result] else sub xs [carry] ++ [result]                          -- o subtraendo é apenas um número, apenas é necessário verificar carry
          where result = mod ((x - y) + 10) 10                                                                          -- resultado sem carry
                carry = if (x - y) < 0 then 1 else 0                                                                    -- carry - o carry na subtração ou é 1 ou é 0
                sub n z = subBNaux n z
                y_carry = [head ys + carry] ++ tail ys

subBN :: BigNumber -> BigNumber -> BigNumber
subBN x (signalY, []) = x
subBN (signalX, []) (signalY, y) = (not signalY, subBNaux [] y)                                                         -- Qualquer número que seja subtraido a 0 resultará no seu simétrico 0 - x = -x
subBN (signalX, x) (signalY, y)
       | not signalX || not signalY = somaBN (signalX, x) (not signalY, y)                                              -- se um dos operandos for negativo vai ser realizada a soma
       -- A partir daqui ambos os operandos são positivos
       | (getBigger (signalX, x) (signalY, y)) /= (signalX, x) = (not signalY, (subBNaux (reverse y) (reverse x)))      -- se y (subtraendo) for maior que x (minuendo) a conta será {y - x}
                                                                                                                        -- com o sinal contrário do subtraendo {4 - 7} <=> {-(7 - 4)}
       | otherwise = (signalX, (subBNaux (reverse x) (reverse y)))                                                      -- ambos os operandos são positivos e minuendo > subtraendo


-- 2.6 multiplication

verifyCarry :: [Int] -> [Int]
verifyCarry [x] = if (div x 10 /= 0) then [div x 10] ++ [mod x 10] else [x]                     -- Se a lista só tiver um dígito, e este for > 10, é preciso decompô-lo, pois
verifyCarry x                                                                                   --    BigNumbers são formados por uma lista constituída por elementos menores que 10
            | carry == 0 = verifyCarry xs ++ [last x]                                           -- Não há problemas de carry no último elemento da lista x
            | otherwise = verifyCarry (init xs ++ [last xs + carry]) ++ [m]                     -- É preciso formatar o último elemento da lista, pois este é superior a 10. O resultado
            where xs = init x                                                                   --    final irá ser dado por verifyCarry(xs + carry) ++ [elementoFormatado]
                  carry = div (last x) 10                                                       -- Como todos os elementos da lista dos BigNumbers são menores que 10, o carry será o número de
                  m = mod (last x) 10                                                           --    vezes que o elemento a observar é maior que 10, enquanto que o valor formatado que irá ficar,
                                                                                                --    vai ser o resto da sua divisão inteira por 10

multBN :: BigNumber -> BigNumber -> BigNumber
multBN (_, [0]) _ = (True, [0])
multBN _ (_, [0]) = (True, [0])
multBN (posX, x) (posY, [y]) = (posX == posY, verifyCarry(map (y*) x))                          -- O resultado final será positivo se os sinais forem iguais, negativo caso contrário
multBN (posX, x) (posY, y) = somaBN (signal, actualMult) (signal, restMult ++ [0])              -- Aplica o método da multiplicação, a começar pelo elemento menos significativo e a
                             where signal = posX == posY                                        --    somar os resultados da multiplicação de todos os elementos (Adicionando um 0 à
                                   actualMult = map ((last y)*) x                               --    direita cada vez que passamos para o próximo elemento)
                                   restMult = snd (multBN (posX, x) (posY, init y))


removeLeft0 :: BigNumber -> BigNumber
removeLeft0 (_, []) = (True, [0])                                                               -- Se a lista estiver vazia, o BigNumber era 0
removeLeft0 (signal, (0:xs)) = removeLeft0 (signal, xs)                                         -- Remove 0 à esquerda
removeLeft0 x = x                                                                               -- BigNumber não possui 0's à esquerda

-- 2.7 division

division :: Int -> BigNumber -> BigNumber -> (BigNumber, BigNumber)
division n totalX y
            | x == y = ((True, [1]), (True, [0]))
            | getBigger x y == y = ((True, [0]), x)
            | otherwise = (somaBN (True, [1]) q,  r)
            where (q, r) = division (length (snd x)) (subBN x y) y                             -- o quociente q é a quantidade de vezes passível de se subtrair y a x, sendo que o resto r é o que sobra das subtrações
                  x = (fst totalX, take n (snd totalX))                                        -- só é necessário ter em consideração as n casas unitárias mais significaivas de totalX

divAux :: Int -> BigNumber -> BigNumber -> (BigNumber, BigNumber)
divAux n (posX, x) (posY, y)
            | n == length x = (partialQ, partialR)
            | otherwise = ((True, snd partialQ ++ snd quotient), rest)                          -- O resultado final será a concatenação dos quocientes parciais e o resto da última divisão parcial
            where (partialQ, partialR) = division n (posX, x) (posY, y)
                  nextX = if snd partialR == [0]                                                -- se resto da divisão parcial é 0
                          then (posX, drop n x)                                                 -- zero à esquerda não tem influência no valor
                          else (posX, snd partialR ++ drop n x)                                 -- partialR /= 0
                  (quotient, rest) = if snd partialR == [0] && n /= length x
                                     then divAux 1 nextX (posY, y)                              -- Como o resto da divisão parcial foi 0 e o número ainda não chegou ao fim, a contagem de n recomeça
                                     else divAux (length (snd partialR) + 1) nextX (posY, y)    -- A contagem continua

divBN :: BigNumber-> BigNumber -> (BigNumber, BigNumber)
divBN x y = (removeLeft0 quotient, rest)
        where (quotient, rest) = divAux 1 x y

-- 5 safe division

safeDivBN :: BigNumber -> BigNumber -> Maybe (BigNumber, BigNumber)
safeDivBN x y
              | y == (fst y, [0]) = Nothing
              | otherwise = Just (divBN x y)
