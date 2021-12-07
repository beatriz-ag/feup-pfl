module Set
(Set, insert, member) where

data Set a = Empty
-- conjunto vazio
  | Node a (Set a) (Set a)
-- elemento, sub-conjunto dos

member :: Ord a => a -> Set a -> Bool
member x Empty = False
member x (Node y left right)
  | x == y = True
  | x > y = member x right
  | x < y = member x left

insert :: Ord a => a -> Set a -> Set a
insert x Empty = Node x Empty Empty
insert x (Node y left right)
  | x == y = Node y left right
  | x > y = Node y left (insert x right)
  | x < y = Node y (insert x left) right

union :: Ord a => Set a -> Set a -> Set a
union x empty = x
union x (Node y left right) = if (member y x) then union (union x left) (union x right) else union (union nx right ) (union nx left)
        where nx = insert y x

intersect :: Ord a => Set a -> Set a -> Set a
intersect x empty = x
interset x (Node y left right) = if ( member x y ) then insert emp
