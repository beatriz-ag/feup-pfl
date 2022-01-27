:-use_module(library(lists)).

%1a
double(X, Y):- Y is X*2. 

map(Pred, L1, L2):- mapAux(Pred, L1, L2, []).

mapAux(_Pred, [], L2, L3):-
    reverse(L2,L3).
mapAux(Pred, [X|Next], L2, L3):-
    Res =.. [Pred, X, Y],
    Res,
    mapAux(Pred, Next, L2, [Y | L3]).

%1b

sum(A, B, S):- S is A+B.

fold(Pred, StartValue, [], FinalValue):-
    FinalValue = StartValue.
fold(Pred, StartValue, [X|Next], FinalValue):-
    Res =.. [Pred, StartValue, X, R],
    Res,
    fold(Pred, R, Next, FinalValue).

%1c
even(X):- 0 =:= X mod 2.

separate([], Pred, [], []).
separate([X|Next], Pred, [X|L1], No):-
    Res =.. [Pred, X],
    Res,
    separate(Next, Pred, L1, No).
separate([X|Next], Pred, Yes, [X|L2]):-
    separate(Next, Pred, Yes, L2).


%1d
ask_execute:-
    write('Insira o que deseja executar\n'),
    read(Func),
    Func.


%2a

my_arg(Index, Term, Arg):-
    Term =.. G,
    nth0(Index, G, Arg).




/* 3
--- a

    ra
a       b
      na   c

--- b
impossível

--- c

        la
    na      c
a       b

--- d
impossível

--- e
impossível

--- f
        la
    la      c
a       b

--- g
    ra
a       b
    ra      c
    
*/

%4

%6
:-op(600, xfx, exists_in).

exists_in(Elem, List):-
    member(Elem, List).

:-op(1200, yfx, results).
:-op(600, yfx, to).
:-op(600, fx, append).

:-op(800, yfx, from).
:-op(800, fx, remove).

/*
results(AB, C):-
    AB =.. Lista,
    append(Lista, [C], NewList),
    Term =.. NewList,
    Term.

to(X, Y, Res):-
    X =.. List,
    append([Y], [Res], List2),
    append(List, List2, FinalList),
    Term =.. FinalList,
    Term.
*/

results(AB, C):-
    AB =.. Lista,
    append(Lista, [C], NewList),
    Term =.. NewList,
    Term.

from(RemElem,List,Result):-
    RemElem =.. Rem,
    append(Rem, [List], NewList),
    append(NewList, [Result], NewNewList),
    Term =.. NewNewList,
    Term.

remove(Elem, List, Res):-
    delete(List, Elem, Res).
    
    

:- usemodule(library(lists)).

connected(porto, lisbon).
connected(lisbon, madrid).
connected(lisbon, paris).
connected(lisbon, porto).
connected(madrid, paris).
connected(madrid, lisbon).
connected(paris, madrid).
connected(paris, belgium).

% procura(lisbon, belgium, Path) ?

procura(Start, End, TruePath):-
    procura([[Start]], End, [], Path),
    reverse(Path, TruePath).

procura([[Fim|Path]|], Fim, , [Fim|Path]).

procura([[X|From]|Res], Fim, Visitados, Path):-
    findall([Node,X|From],
        (
            connected(X, Node),
            +member(Node, Visitados),
            +member([Node|], [[X|_]|Res])
        ),
        Nodes),
    append(Res, Nodes, NewNodes),
    procura(NewNodes, Fim, [X|Visitados], Path).



