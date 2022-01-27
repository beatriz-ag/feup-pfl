:-use_module(library(between)).
:- use_module(library(lists)).
/*
 1.a
        X = 1?
        X = 2?
 1.b
        x = 1?
            y = 1?
            y = 2?
        x = 2?
            y = 1?
            y = 2?

1.c
        x = 1?
            y = 1?
        x = 2?
            y = 1?

1.d  
?- s(X), s(Y), !
        x = 1?
            y = 1?

2.a
Gerar todas as possibilidades de cut_test_a(X) e escrevemos na consola, new line, fail faz com que volte a repetir (responde sempre não)
one
two
three
`five´

2.b
one 

2.c
one-one
one-two
onw-three

3.a
Red cut - Se retirarmos o cut, os resultados serão diferentes.
Green cuts - Evitamos ir para ramos de computação onde sabemos que não são resultados possíveis. - eficiência - ou exclusivo
Para ser adulto, basta verificar se é pessoa, não é necessário verificar se é tartaruga etc

*/

% 4.a, b, d, e, i 5.a, d, e, h 6.a, b, e, g

%4.a
print_n(S,1) :- write(S).
print_n(S, N) :- write(S), 
                 NN is N-1, 
                 print_n(S, NN).

%4.b
print_string([]).
print_string([T|EXT]) :- put_code(T), print_string(EXT).

print_text(T, S, P) :- write(S),
                       print_n(' ', 4),
                       print_string(T),
                       print_n(' ', 4),
                       write(S).
%4.d

getInputConvert(I,R) :- peek_code(X),
                        X == 10,
                        reverse(I, P),
                        number_codes(R, P). 

getInputConvert(I,C) :- peek_code(X), 
                        between(47, 58, X),
                        get_code(X),
                        getInputConvert([X|I], C).


read_number(X) :- getInputConvert('',C),
                  X is C.

%5
female(grace).
female(dede).
female(claire).
female(haley).
female(poppy).
female(alex).
female(poppy).
female(lily).

male(mitchell).
male(frank).
male(phil).
male(jay).
male(dylan).
male(george).
male(luke).
male(frank).

parent(grace, phil).
parent(frank, phil).

parent(dede, claire).
parent(jay, claire).

parent(dede, mitchell).
parent(jay, mitchell).

parent(mitchell, lily).

parent(phil, haley).
parent(claire, haley).

parent(phil, alex).
parent(claire, alex).

parent(phil, luke).
parent(claire, luke).

parent(dylan, poppy).
parent(haley, poppy).

parent(dylan, george).
parent(haley, george).

father(X,Y) :- parent(X, Y), male(X).
mother(X,Y) :- parent(X, Y), female(X).
grandfather(X,Y) :- parent(X,Z), parent(Z,Y), male(X).
grandmother(X,Y) :- parent(X,Z), parent(Z,Y), female(X).
siblings(X,Y) :- parent(Z,X), parent(W,X),W\==X, parent(Z,Y), parent(W,Y).
halfSiblings(X,Y) :- parent(P,X), parent(M,X), parent(W,Y), P\==M, P\==W, M\==P, M\==W.
uncle(X,Y) :- parent(Z,Y), siblings(X,Z).
cousins(X,Y) :- parent(Z,X), uncle(Z,Y).

%5.a
children(Person, Children) :- findall(Child, parent(Person, Child), Children).
%5.d
couple(W-H) :- parent(W, Child), parent(H, Child), W @< H.
%5.e
couples(List) :- setof(W-H, Child^(parent(W, Child),parent(H, Child), W @< H), List).
%couples(List) :- setof(W-H, couple(W-H), List).
%5.h
parents_of_two(Parents) :- findall(W-H, (parent(W, Child1), parent(H, Child1), parent(W, Child2), parent(H, Child2), W @<H, Child1 @< Child2), Parents).
