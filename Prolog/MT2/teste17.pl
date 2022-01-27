:- use_module(library(between)).
:- use_module(library(lists)).
:- dynamic played/4.

%player(Name, UserName, Age)
player('Manny', 'The Player', 14).
player('Danny', 'Best Player Ever', 27).
player('Annie', 'Worst Player Ever', 24).
player('Harry', 'A-Star Player', 26).
player('Jonny', 'A Player', 16).

%game(Name, Categories, MinAge)
game('5 ATG', [action, adventure, open-world, multiplayer], 18).
game('Carrier Shift: Game Over', [action, fps, multiplayer, shooter], 16).
game('Duas Botas', [action, free, strategy, moba], 16).
game('teste', [action, fps, multiplayer, shooter], 12).

%played(Player, Game, HoursPlayed, PercentUnlocked)
played('Best Player Ever', '5 ATG', 3, 83).
played('Worst Player Ever', '5 ATG', 52, 9).
played('The Player', 'Carrier Shift: Game Over', 44, 22).
played('A Player',  'Carrier Shift: Game Over', 48, 24).
played('A-Star Player', 'Duas Botas', 37, 16).
played('Best Player Ever', 'Duas Botas', 33, 22).
played('The Player', 'teste', 44, 22).

%1
achievedALot(Player):-
  played(Player, _Game, _HoursPlayed, Percentage),
  Percentage > 80.

%2
isAgeAppropriate(Name,Game):-
  game(Game,_Categories, MinAge),
  player(Name, UserName, Age),
  Age >= MinAge.


%3
timePlayingGames(Player, Games, ListOfTimes, SumTimes):-
  timePlayingGamesAux(Player, Games, ListOfTimes, SumTimes, 0).

timePlayingGamesAux(_Player, [], [], SumTimes, SumTimes).
timePlayingGamesAux(Player, [Game|Next], [HoursPlayed|ListOfTimes], SumTimes, Acc):-
  played(Player, Game, HoursPlayed, _),
  NewSum is Acc + HoursPlayed,
  timePlayingGamesAux(Player, Next, ListOfTimes, SumTimes, NewSum).

timePlayingGamesAux(Player, [Game|Next], [0|ListOfTimes], SumTimes, Acc):-
  timePlayingGamesAux(Player, Next, ListOfTimes, SumTimes, Acc).


playingGames2(Player, [Game|Rest], [Time|List], Sum):- !,
  playingGames2(Player, [Game|Rest], [Time|List], Sum, 0).

playingGames2(_, [], [], Sum, Sum).
playingGames2(Player, [Game|Rest], [Time|List], Sum, A):-
  played(Player, Game, Time, _),
  NA is A + Time,
  playingGames2(Player, Rest, List, Sum, NA).

%4
listGamesOfCategory(Cat):-
  game(Game, Categories, MinAge),
  member(Cat, Categories),
  format('~s (~d)\n',[Name,MinAge]),
  fail.

listgames(Cat):-
  findall(Game, (game(Game, Categories, _), member(Cat, Categories)), Categoriies),
  write(Categoriies).

%5
updatePlayer(Player, Game, Hours, Percentage):-
  played(Player, Game, PH, PP),
  retract(played(Player, Game, PH, PP)),
  NewH is PH + Hours,
  NewP is PP + Percentage,
  assert(played(Player, Game, NewH, NewP)).
  
%6
fewHours(Player, Games):-
  fewHours(Player, Games, []).

fewHours(Player, Games, Acc):-
  played(Player, Game, Hours, _),
  Hours < 10,
  \+ member(Game, Acc), 
  fewHours(Player, Games, [Game|Acc]).

  fewHours(Player, Games, Games).


%7
ageRange(MinAge, MaxAge, Players):-
  ageRange(MinAge, MaxAge, Players, []).
ageRange(MinAge, MaxAge, Players, Acc):-
  player(Player, _, Age),
  Age =< MaxAge,
  Age >= MinAge,
  \+ member(Player, Acc),
  ageRange(MinAge, MaxAge, Players, [Player|Acc]).

ageRange(_, _, Players, Players).
%8
sumA([], Res, Res).
sumA([Player-Age |Next], Res, Acc):-
  N is Acc + Age,
  sumA(Next, Res, N).

averageAge(Game, AverageAge):-
  averageAge(Game, AverageAge, []).

averageAge(Game, AverageAge, A):-
  played(Player, Game, _, _),
  player(_, Player, Age),
  \+ member(Player-Age, A),
  averageAge(Game, AverageAge, [Player-Age| A]).

averageAge(Game, AverageAge, A):-
  length(A, Total),
  sumA(A, S, 0),
  AverageAge is S/Total.
% ------------------------------------------------------------------------------------
avg(Game, AverageAge):-
  findall(Age, (played(Player, Game, _, _), player(_, Player, Age)), Ages),
  length(Ages, L),
  sumlist(Ages, Total),
  AverageAge is Total / L.

% --------------------------------------------------------------------------------------

%9 
bestScore([], BestScore, BestScore).

bestScore([Player-Score | Next], CurScore, BestScore):-
  Score > CurScore, !,
  bestScore(Next, Score, BestScore).

bestScore([Player-Score | Next], CurrScore, BestScore):-
  bestScore(Next, CurrScore, BestScore).

getMostEffectivePlayers([], Score, []).
getMostEffectivePlayers([Player-Efficiency| Next], Score, [Player|Players]):-
  Efficiency == Score, !,
  getMostEffectivePlayers(Next, Score, Players).
getMostEffectivePlayers([Player-Efficiency| Next], Score, Players):-
  getMostEffectivePlayers(Next, Score, Players).

mostEffectivePlayers(Game, Players):-
  mostEffectivePlayers(Game, Players, []).

mostEffectivePlayers(Game, Players, A):-
  played(Player, Game, Hours, Percentage),
  Efficiency is Percentage/Hours,
  \+ member(Player-Efficiency, A), !,
  mostEffectivePlayers(Game, Players,[Player-Efficiency|A]).

mostEffectivePlayers(Game, Players, A):-
  bestScore(A, 0, Score),
  getMostEffectivePlayers(A, Score, Players).

% -----------------------------------------------------------------------------------------------------------------------
removeLess([E-Player, E1-Player1|Next],[Player|List]):-
  E = E1,
  removeLess([E1-Player1|Next], List).
removeLess([E-Player|Next],[Player]).

efective(Game, Players):-
  setof(Eff-Player, (Player, Game, H, P)^(played(Player, Game ,H,P), Eff is P/H), XPlayers),
  keysort(XPlayers, Sorted),
  reverse(Sorted, SSorted),
  removeLess(SSorted, Players).
% --------------------------------------------------------------------------------------------------------------------------

%10
whatDoesItDo(Nick):-
  player(_, Nick, Age), !,
  \+ (played(Nick, Game, Hours, Percentage),
      game(Game, _, MinAge),
      MinAge > Age).

% Com nick - Verifica se o jogador pode jogar todos os jogos que ele joga
% Sem nick - verica se o 1o jogador pode jogar todos os jogos que ele joga


% linha-coluna
matDist([[8],[8,2],[7,4,3],[7,4,3,1]]).
    
dist(E,E,0).
dist(L,C,Dist):-
    C > L,
    dist(C,L,Dist).
dist(L,C,Dist):-
    RealL is L - 1, matDist(X),
    nth1(RealL,X,Row),
    nth1(C,Row,Dist).

areClose(MaxDist,Pairs):-
    findall(L-C, (between(2,5,L),
                  between(1,4,C),
                  L \= C,
                  dist(L,C,D), 
                  D =< MaxDist), 
                 List), 
    removeSymmetrical(List,Pairs).

removeSymmetrical(List,Pairs):-
    removeSymmetrical(List,[],Pairs).

removeSymmetrical([],Pairs,Pairs).
removeSymmetrical([L-C|Rest],Acc,Pairs):-
    \+member(C-L,Acc),
    removeSymmetrical(Rest,[L-C|Acc],Pairs).
removeSymmetrical([_|Rest],Acc,Pairs):-
    removeSymmetrical(Rest,Acc,Pairs).


  %13