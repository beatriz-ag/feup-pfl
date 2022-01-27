:- use_module(library(lists)).

% participant(Id,Age,Performance).
participante(1234,17,'Pé coxinho').
participante(3423,21,'Programar com os pés').
participante(3788,20,'Sing a bit').
participante(4865,22,'Pontes esparguete').
participante(8937,19,'Pontes de pen-drives').
participante(2564,20,'Moodle hack').

% performance(Id,Times).
performance(1234,[120,120,120,120]).
performance(3423,[32,120,45,120]).
performance(3788,[110,2,6,43]).
performance(4865,[120,120,110,120]).
performance(8937,[97,101,105,110]).

%1
madeItThrough(Participant):-
  performance(Participant, Times),
  member(120, Times).

juriTimes(Participants, JuriMember, Times, Total):-
  juriTimes(Participants, JuriMember, Times, Total, 0).

juriTimes([], JuriMember, [], Total, Total).
juriTimes([Cur|Next], JuriMember, [Time|Times], Total, Ac):-
  performance(Cur,TimesP),
  nth1(JuriMember, TimesP, Time),
  NAc is Ac + Time,
  juriTimes(Next, JuriMember, Times, Total, NAc).

patientjuri(JuriMember):-
  patientjuri(JuriMember, [], 0).

patientjuri(_, _, 2).
patientjuri(JuriMember, Ac, N):-
  performance(Id, Times),
  \+ member(Id, Ac), !,
  nth1(JuriMember, Times, Time),
  (Time == 120 -> NN is N + 1; NN = N),
  patientjuri(JuriMember, [Id|Ac], NN).


sum([], 0).
sum([Cur|Next], T):-
  sum(Next, X),
  T is X + Cur.


bestParticipant(P1,P2,P):-
  performance(P1, Times1),
  performance(P2, Times2),
  sumlist(Times1, Time1),
  sumlist(Times2, Time2),
  Time1 \= Time2,
  (Time1>Time2 -> P is P1; P is P2).


allPerfs:-
  allPerfs([]).

allPerfs(A):-
  performance(Id, Times),
  \+ member(Id, A), !,
  participante(Id, _, Perf),
  write(Id), write(':'), write(Perf),write(':'), write(Times),nl,
  allPerfs([Id|A]).
allPerfs(_).

every([], _).
every([Cur|Next], Value):-
  Cur == Value,
  every(Next, Value).


nSuccessfulParticipants(T):-
  findall(Participant, (performance(Participant, Times), every(Times, 120)), Participants),
  length(Participants, T).
  
getJuris([], [], _).
getJuris([Cur|Next], [Idx|Juris], Idx):-
  Cur == 120, !,
  Nidx is Idx + 1,
  getJuris(Next, Juris, Nidx).
getJuris([Cur|Next], Juris, Idx):-
  Nidx is Idx + 1,
  getJuris(Next, Juris, Nidx).
  
juriFans(JuriFansList):-
  findall(Participant-Juris, (
                              performance(Participant, Times),
                              getJuris(Times,Juris, 1)), JuriFansList).

juriFans2(L):-
  findall(P-J,(performance(P,Times),
               length(Times,NJuris),
               findall(Juri,(between(1,NJuris,Juri),
                             nth1(Juri,Times,Time),
                             Time == 120),J)),L).


eligibleOutcome(Id,Perf,TT):-
  performance(Id, Times),
  madeItThrough(Id),
  participante(Id,_,Perf),
  sumlist(Times, TT).

nextPhase(N, Participants):-
  setof(TT-Id-Perf, eligibleOutcome(Id, Perf, TT), ParticipantsX),
  reverse(ParticipantsX, ParticipantsXX),
  sublist(ParticipantsXX, Participants, _, N).


pred(Q, [R|Rs], [P|Ps]):-
  participante(R,I,P), I =< Q, 
  pred(Q,Rs, Ps).
pred(Q, [R|Rs], Ps):-
  participante(R,I,_), I > Q,
  pred(Q,Rs, Ps).
pred(_, [], []).

impoe(X,L):-
  length(Mid, X),
  append(L1, [X|_], L), append(_, [X|Mid], L1).
