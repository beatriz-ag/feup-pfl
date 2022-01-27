% 1 Relações Familiares

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

marry(jay,dede,'1968').
marry(jay,gloria,'2008').
divorce(jay,dede,'2003').

married(X,Y) :- marry(X,Y,_), \+ divorce(X,Y,_).
divorced(X,Y) :- divorce(X,Y,_), \+ marry(X,Y,_).


% 2 Professores e alunos
leciona(algoritmos, adalberto).
leciona('base de dados', bernardete).
leciona(compiladores, capitolino).
leciona(estatistica, diogenes).
leciona(redes, ermelinda).

frequenta(algoritmos, alberto).
frequenta(algoritmos, bruna).
frequenta(algoritmos, cristina).
frequenta(algoritmos, diogo).
frequenta(algoritmos, eduarda).
frequenta('bases de dados', antonio).
frequenta('bases de dados', bruno).
frequenta('bases de dados', cristina).
frequenta('bases de dados', duarte).
frequenta('bases de dados', eduardo).
frequenta(compiladores, alberto).
frequenta(compiladores, bernardo).
frequenta(compiladores, clara).
frequenta(compiladores, diana).
frequenta(compiladores, eurico).
frequenta(estatistica, antonio).
frequenta(estatistica, bruna).
frequenta(estatistica, 'cláudio').
frequenta(estatistica, duarte).
frequenta(estatistica, eva).
frequenta(redes, alvaro).
frequenta(redes, beatriz).
frequenta(redes, claudio).
frequenta(redes, diana).
frequenta(redes, eduardo).

aluno(X,Y) :- leciona(W,X), frequenta(W,Y).
professor(X,Y) :- aluno(Z,X), aluno(Z,Y).

% exc 6 - Backtracking e Árvores de Pesquisa 
/* 
    pairs(X,Y)
        d(X)
            X = 2
            q(Y)
                Y = 4      X=2, Y=4?;
            q(Y)
                Y = 16     X=2, Y=16?;
            -
        d(X)
            X=4
            q(Y)
                Y = 4      X=4, Y=4?;  
            q(Y)
                Y = 16     X=4, Y=16?;
            - 
        -
    pairs(X,X)
        u(X)
            X = 1          X=1, Y=1?;
            -
        -
    -
    no
*/










