airport('Aeroporto Francisco Sá Carneiro','LPPR','Portugal').
airport('Aeroporto Humberto Delgado','LPPT','Portugal').
airport('Aeroporto Adolfo Suarez Madrid-Barajas','LEMD','Spain').
airport('Aeroporto de Paris-Charles-de-Gaule Roissy Airport','LFPG','France').
airport('Aeroporto Internazionale di Roma-Fiumicino - Leonardo da Vinci','LIRF','Italy').

company('TAP','TAP Air Portugal',1945,'Portugal').
company('RYR','Ryanair',1984,'Ireland').
company('AFR','Société Air France, S.A.',1933,'France').
company('BAW','British Airways',1974,'United Kingdom').

flight('TP1923','LPPR','LPPT',1115,55,'TAP').
flight('AF1025','LPPT','LFPG',1310,155,'AFR').
flight('TP1968','LPPT','LPPR',2235,55,'TAP').
flight('TP842','LPPT','LIRF',1450,195,'TAP').
flight('TP843','LIRF','LPPT',1935,195,'TAP').
flight('FR5483','LPPR','LEMD',630,105,'RYR').
flight('FR5484','LEMD','LPPR',1935,105,'RYR').
flight('AF1024','LFPG','LPPT',940,155,'AFR').

%1
short(Flight):-
  flight(Flight,_,_,_,D,_),
  D<130.

%2
shorter(Flight1, Flight2, ShorterFlight):-
  flight(Flight1, _, _, _, D1, _),
  flight(Flight2, _, _, _, D2, _),
  D1  > D2,
  ShorterFlight = Flight2.
shorter(Flight1, Flight2, ShorterFlight):-
  flight(Flight1, _, _, _, D1, _),
  flight(Flight2, _, _, _, D2, _),
  D2  > D1,
  ShorterFlight = Flight1.
shorter(Flight1, Flight2, ShorterFlight):-
  fail.

%3
arrivalTime(Flight, ArrivalTime):-
  flight(Flight, _, _, DepT, Dur, _),
  ReMin is Dur mod 60,
  ReH is (Dur div 60) * 100,
  T is ReH + ReMin,
  TArrivalTime is  T + DepT,
  Min is TArrivalTime mod 100,
  RemMin is Min mod 60,
  RemHour is (Min div 60)*100,
  Hours is (TArrivalTime div 100)*100,
  ArrivalTime is Hours +  RemHour + RemMin.

%4
countries(Company, List):-
  countries(Company, List, []).

countries(Company, List, A):-
  flight(_, From, _, _, _, Company),
  airport(_, From, Country),
  \+ member(Country, A), !,
  countries(Company, List, [Country|A]).
countries(Company, List):-
  flight(_, _, To, _, _, Company),
  airport(_, To, Country),
  \+ member(Country, List), !,
  countries(Company, List, [Country|A]).
countries(Company, A, A).

%5
pairableFlights:-
  pairableFlights([]).

pairableFlights(A):-
  flight( F1, From, To, T1, Dur, _),
  flight( F2, To, Next, T2, _, _),
  arrivalTime(F1, ArrT),
  Delta is T2 - ArrT,
  Delta >= 30,
  Delta =< 130,
  \+member(F1-F2,A), !,
  write(From), write(' - '), write(F1), write(' \\ '), write(F2),nl,
  pairableFlights([F1-F2|A]).

pairableFlights(A).

%6
tripDays([_], _, [], Days, Days).

tripDays(List, Time, FlightTimes, Days):-
  tripDays(List, Time, FlightTimes, Days, 1).

tripDays([Cur,Next|Rest], Time, [H | FlightTimes], Days, Ac):-
  airport( _, From, Cur),
  airport(_, To, Next),
  flight( F, From, To, H, D, _),
  arrivalTime(F, AT),
  (AT<Time -> NAc is Ac + 1; NAc = Ac),
  NewTime is AT + 30,
  tripDays([Next|Rest], NewTime, FlightTimes,Days, NAc).

%7
:- use_module(library(lists)).

avgFlightLengthFromAirport(Airport, AvgLength):-
  findall(Dur, flight( _, Airport, _, _, Dur, _), Times),
  length(Times, Length),
  sumlist(Times, Total),
  AvgLength is Total / Length.

%8
concat([Cur], Res, List):-
  append(Cur, List, NewList),
  remove_dups(NewList, Res).
concat([Cur|Next], Res, List):-
  append(List,Cur, NewList),
  concat(Next, Res, NewList).

getMaxCountries([], _, ListOfCompanies, ListOfCompanies).
getMaxCountries([(Company,List)|Next], Cur, ListOfCompanies, CList):-
  length(List, Length),
  Length > Cur, !,
  getMaxCountries(Next, Length, ListOfCompanies, [Company]).
getMaxCountries([(Company,List)|Next], Cur, ListOfCompanies, CList):-
  length(List, Length),
  (Length == Cur -> append([Company], CList, NewList) ; NewList = CList),
  getMaxCountries(Next, Cur, ListOfCompanies, NewList).


getCompanyCountries(Companies):-
  findall((Company, Res), (company(Company, _, _, _),
                    setof([Country1, Country2], 
                            (From, A, B, C , D, E, F, To)^(flight(A, From, To, C,D, Company),
                            airport(E, From, Country1), airport(F, To, Country2)),
                            Countries),
                            concat(Countries, Res, [])),
          Companies).

mostInternational(ListOfCompanies):-
  getCompanyCountries(Res),
  getMaxCountries(Res, 0,ListOfCompanies, []).


%9 10
:- use_module(library(Lists)).

make_pairs(L, P, [X-Y|Zs]):-
  select(X, L, L2),
  select(Y, L2, L3),
  G =.. [P,X,Y], G,
  make_pairs(L3, P, Zs).
make_pairs(_, _, []).
make_pairs([], _, []).

dif_max_2(X,Y):- X < Y, X >= Y - 2.

%11

get_max_pair([], S, _, S).
get_max_pair([Cur|Next], S, Counter, Temp):-
  length(Cur, Length),
  Length > Counter,
  get_max_pair(Next, S, Length, Cur).
get_max_pair([Cur|Next], S, Counter, Temp):-
  get_max_pair(Next, S, Counter, Temp).
  
make_max_pairs(L, P, S):-
  setof(Res, make_pairs(L,P, Res), SS),
  get_max_pair(SS, S, 0, Temp).







%12

stateMachine(N, 2-3, [(NewX, NewY), (NewY, NewX)|List], (X,Y)):-
  NewX is X + 2,
  NewY is Y + 3,
  NewX =< N,
  NewY =< N,
  stateMachine(N, 1-2, List, (NewX, NewY)).
stateMachine(N, 1-2, [(NewX, NewY), (NewY, NewX)|List], (X,Y)):-
  NewX is X + 1,
  NewY is Y + 2,
  NewX =< N,
  NewY =< N,
  stateMachine(N, 2-3, List, (NewX, NewY)).

stateMachine(_, _, [], _).


whitoff(N, [(1,1)|W]):-
  stateMachine(N, 1-2, W, (1,1)).

