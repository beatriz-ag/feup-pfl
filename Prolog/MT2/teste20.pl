jogo(1, sporting, porto, 1-2).
jogo(1, maritimo, benfica, 2-0).
jogo(2, sporting, benfica, 0-2).
jogo(2, porto, maritimo, 1-0).
jogo(3, maritimo, sporting, 1-1).
jogo(3, benfica, porto, 0-2).

treinadores(porto, [[1-3]-sergio_conceicao]).
treinadores(sporting, [[1-2]-silas, [3-3]-ruben_amorim]).
treinadores(benfica, [[1-3]-bruno_lage]).
treinadores(maritimo, [[1-3]-jose_gomes]).

%1
n_treinadores(Equipa, Numero):-
  treinadores(Equipa, Treinadores),
  length(Treinadores, Numero).
  
%2
n_jornadas_treinador(Treinador, NumeroJornadas):-
  n_jornadas_treinador(Treinador, NumeroJornadas, 0, []).

n_jornadas_treinador(Treinador, NumeroJornadas, Acc, Visited):-
  treinadores(Team, Treinadores),
  \+ member(Team, Visited),
  member([I-F]-Treinador, Treinadores),
  Delta is F-I,
  NDelta is Delta + 1,
  NAcc is Acc + NDelta,
  n_jornadas_treinador(Treinador, NumeroJornadas, NAcc, [Team | Visited]).

n_jornadas_treinador(_, NumeroJornadas, NumeroJornadas, _).

%kkkk o treinador afinal só pode treinar uma equipa
n_jornadas_treinador_x(Treinador, NumeroJornadas):-
  treinadores(_, Treinadores),
  member([I-F]-Treinador, Treinadores),
  NumeroJornadas is F - I + 1.

%3 4 5 6
:-op(1200, xfx, venceu).
:-op(500, fx, o).

venceu(OA,OB):-
  OA =.. [O|A],
  OB =.. [O|B],
  append([ganhou, Jornada], A, PT1),
  append(PT1, B, PT2),
  Term =.. PT2,
  Term.
  
ganhou(Jornada, EquipaVencedora, EquipaDerrotada):-
  jogo(Jornada, EquipaVencedora, EquipaDerrotada, V-D),
  V>D.
ganhou(Jornada, EquipaVencedora, EquipaDerrotada):-
  jogo(Jornada, EquipaDerrotada, EquipaVencedora, D-V),
  V>D.

%7
% o predicado verifica se N está entre A e B
% ou entao retorna as varias possibilidades que N pode ter

%cut verde, nao altera resultado

%8
checkLost(I,I,_).
checkLost(I,B,Team):-
  jogo(B,Team,_,T-O),
  T<O, !,
  fail.
checkLost(I,B, Team):-
  jogo(B, _, Team, O-T),
  T<O, !,
  fail.
checkLost(I,B,Team):-
  NewB is B - 1,
  checkLost(I,NewB, Team).


treinador_bom(Treinador):-
  treinadores(Team, Treinadores),
  member([I-B]-Treinador, Treinadores),
  checkLost(I,B,Team), !.


%9
imprime_totobola(1,'1').
imprime_totobola(0,'X').
imprime_totobola(-1,'2').

imprime_texto(X, 'vitoria da casa'):- X = 1.
imprime_texto(X, 'empate'):- X = 0.
imprime_texto(X, 'derrota da casa'):- X = -1.

imprime_jogos(F):-
  jogo(Jornada, Casa, Oponente, C-O),
  C>O,
  Term =.. [F,1, X],
  Term,
  write('Jornada '),write(Jornada), write(': '), write(Casa), write(' x '), write(Oponente), write(' - '), write(X), nl,
  fail.
imprime_jogos(F):-
  jogo(Jornada, Casa, Oponente, C-O),
  C<O,
  Term =.. [F,-1, X],
  Term,
  write('Jornada '),write(Jornada), write(': '), write(Casa), write(' x '), write(Oponente), write(' - '), write(X),nl, fail.
imprime_jogos(F):-
  jogo(Jornada, Casa, Oponente, C-O),
  C==O,
  Term =.. [F,0, X],
  Term,
  write('Jornada '),write(Jornada), write(': '), write(Casa), write(' x '), write(Oponente), write(' - '), write(X),nl,fail.



%12
getTreinadores([],[]).
getTreinadores([_-Treinador|Next],[Treinador|List]):-
  getTreinadores(Next,List ).


concat([], A, A).
concat([Cur|Next], L, A):-
  append(Cur,A, NewA),
  concat(Next, L, NewA).


lista_treinadores(L):-
  findall( Treinadores, (treinadores(_, Treinador), getTreinadores(Treinador,Treinadores)), XL),
  concat(XL, L, []).

%13

getTreinadoresEpocas([], []).
getTreinadoresEpocas([[B-E]-Treinador|Next], [Value-Treinador|List]):-
  Value is E - B + 1,
  getTreinadoresEpocas(Next, List).

insert_into(Cur,[], [Cur]).
insert_into(Ep-Trei,[E-T|Next], [Ep-Trei,E-T|Next]):-
  Ep>=E.
insert_into(Curr,[E|Next], [E|Res]):-
  insert_into(Curr,Next, Res).  

sortS([],Res, Res).
sortS([Cur|Next], A, Res):-
  insert_into(Cur, A, NewA),
  sortS(Next, NewA, Res).



duracao_treinadores(L):-
  findall( Treinadores, (treinadores(_, Treinador), getTreinadoresEpocas(Treinador,Treinadores)), XL),
  concat(XL, XXL, []),
  keysort(XXL, XXXL),
  reverse(XXXL, L).

