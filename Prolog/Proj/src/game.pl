:-use_module(library(lists)).
:-use_module(library(random)).
:-use_module(library(system)).
:-[menu].
:-[board].

% valid_move(+Move, +PreviousMove)
% Validates if move is next to previous one 
valid_move(L-C, PL-PC):- PL is L - 1, PC = C.
valid_move(L-C, PL-PC):- PL is L + 1, PC = C.
valid_move(L-C, PL-PC):- PC is C - 1, PL = L.
valid_move(L-C, PL-PC):- PC is C + 1, PL = L.
valid_move(L-C, PL-PC):- PC is C - 1, PL is L - 1.
valid_move(L-C, PL-PC):- PC is C + 1, PL is L - 1.
valid_move(L-C, PL-PC):- PC is C - 1, PL is L + 1.
valid_move(L-C, PL-PC):- PC is C + 1, PL is L + 1.



% validator(+Move, +Board)
% Validates if move is within board size
validator(L-C, Board):-
    length(Board,Max),
    between(0, Max, L),
    between(0, Max, C).

% Verifies if the first move is valid
validator(L-C, (-1)-(-1), Board):-
    validator(L-C, Board).

% Verifies if the remaining moves are valid
validator(L-C, PL-PC, Board):-
    is_empty(L-C, Board),
    valid_move(L-C, PL-PC).



% Verifies if a specific position of the current board has a specific value
% verify_position(+Move, +GameState)
verify_position(L-C, gameState(Board, turn(_-Value), _)):-
    validator(L-C, Board),
    nth0(L, Board, Line),
    nth0(C, Line, Value).


% is_empty(+Pos,+Board)
% Verifies if a specific position of the board is empty 
is_empty(Pos, Board):-
    verify_position(Pos, gameState(Board, turn(_-empty), _)).

% is_white(+Pos,+Board)
% Verifies if a specific position of the board is black 
is_white(Pos, Board):-
    verify_position(Pos, gameState(Board, turn(_-black), _)).

% is_black(+Pos,+Board)
% Verifies if a specific position of the board is white
is_black(Pos, Board):-
    verify_position(Pos, gameState(Board, turn(_-white), _)).



% update_position(+Move, +Board, +Color, -NewBoard)
% Replaces a specific position of the board with a given color
update_position(L-C, Board, Color, NewBoard):-
    %get board line
    nth0(L, Board, Line),

    %remove empty from line in position C
    nth0(C, Line, _, RLine),
    %insert color in position C
    nth0(C,NewLine, Color, RLine),

    %replace new line
    nth0(L, Board,_, RBoard),
    nth0(L, NewBoard, NewLine, RBoard).

% end_game(+GameState, +Position, +Offset, +Incrementer, -Result)

% Base case
% Ends recursion when L-C board position doesn't match the gameState current value
end_game(GameState, L-C, _OffsetL-_OffsetC, Curr, Curr):-
    \+ verify_position(L-C, GameState).

% Goes through board in the direction specified by the offsets
% while board L-C position contains the gameState current value
end_game(GameState, L-C, OffsetL-OffsetC, Curr, Res):-
    verify_position(L-C, GameState),
    NewCurr is Curr + 1,
    LNext is L + OffsetL,
    CNext is C + OffsetC,
    end_game(GameState, LNext-CNext, OffsetL-OffsetC, NewCurr, Res).


% move(+GameState, +Move, -GameState)
% Validates a move, if valid, updates the board
move(gameState(Board, turn(Player-Color), PL-PC), L-C, gameState(NewBoard, turn(Player-Color), L-C)):-
    validator(L-C, PL-PC, Board),
    update_position(L-C, Board, Color, NewBoard).


% Checks if there are any line with 4 or more pieces of the same color in a row

% horizontal(+GameState, +CurrentMove)
horizontal(gameState(Board, Turn, Move)):-
    end_game(gameState(Board, Turn, Move), Move, 0-(-1), 0, Left),  
    end_game(gameState(Board, Turn, Move), Move, 0-1, 0, Right),  
    Horizontal is Left + Right - 1,
    Horizontal >= 4.

% vetical(+GameState, +CurrentMove)
vertical(gameState(Board, Turn, L-C)):-
    transpose(Board, NewBoard),
    horizontal(gameState(NewBoard, Turn, C-L)).

% diagonal_up(+GameState, +CurrentMove)
diagonal_up(gameState(Board, Turn, Move)):-
    end_game(gameState(Board, Turn, Move), Move, 1-(-1), 0, DownLeft),     
    end_game(gameState(Board, Turn, Move), Move, (-1)-1, 0, UpRight),
    diagonal_up is DownLeft + UpRight - 1,
    diagonal_up >= 4.

% diagonal_down(+GameState, +CurrentMove)
diagonal_down(gameState(Board, Turn, Move)):-
    end_game(gameState(Board, Turn, Move), Move, (-1)-(-1), 0, UpLeft),    
    end_game(gameState(Board, Turn, Move), Move, 1-1, 0, DownRight),
    diagonal_down is UpLeft + DownRight - 1,
    diagonal_down >= 4.

% value(+GameState, +Position, +Offset, +Value, -Res)
% count gameState board's number of empty and gameState's value
value(gameState(Board, turn(Player-Color), _PM), L-C, OffsetL-OffsetC, Value, Res):- 
    verify_position(L-C, gameState(Board, turn(Player-Color), _PM)),
    NewValue is Value + 2,
    LNext is L + OffsetL,
    CNext is C + OffsetC,
    value(gameState(Board, turn(Player-Color), _PM), LNext-CNext, OffsetL-OffsetC, NewValue, Res).
value(gameState(Board, turn(Player-Color), _PM), L-C, OffsetL-OffsetC, Value, Res):- 
    verify_position(L-C, gameState(Board, turn(Player-empty), _PM)),
    NewValue is Value + 1,
    LNext is L + OffsetL,
    CNext is C + OffsetC,
    value(gameState(Board, turn(Player-Color), _PM), LNext-CNext, OffsetL-OffsetC, NewValue, Res).
value(_,_,_, Value, Value).



% end_game(+GameState, +CurrentMove)
% Verifies if the current move is a final move
% final move when one of the directions from the played move has 4 or more positions with the 
% game state value
end_game(GameState):- horizontal(GameState).
end_game(GameState):- vertical(GameState).
end_game(GameState):- diagonal_down(GameState).
end_game(GameState):- diagonal_up(GameState).


% play_game(+Player, +Size)
% Singeplayer game version
play_game((singleplayer-Level), Size):- 
    initial_state(Size, Board),
    GameState = gameState(Board, turn(human-white), (-1)-(-1)),
    display_game(GameState), !,
    \+ game_cycle(GameState, turn((computer-Level)-black)).

% Singeplayer game version
play_game((singleplayer-Level), Size):- 
    initial_state(Size, Board),
    GameState = gameState(Board, turn(human-white), (-1)-(-1)),
    display_game(GameState), !,
    \+ game_cycle(GameState, turn((computer-Level)-black)).


% Multiplayer game version
play_game(multiplayer, Size):- 
    initial_state(Size, Board),
    GameState = gameState(Board, turn(human-white), (-1)-(-1)),
    display_game(GameState), !,
    \+ game_cycle(GameState, turn(human-black)).

% BotvsBot game version
play_game(botvsbot-(Level1-Level2), Size):-
    initial_state(Size, Board),
    write((Level1, Level2)),
    GameState = gameState(Board, turn((computer-Level1)-white), (-1)-(-1)),
    display_game(GameState), !,
    \+ game_cycle(GameState, turn((computer-Level2)-black)).


% initial_state(+Size, -Board)
% Creates a new board with a specific size
initial_state(Size, Board):-
    create_board(Size, Board).


% game_over(+GameState, +Move, +PossibleMoves)
% Verifies if a move ends the game. If true, leaves the game to the congratulation page
game_over(_GameState, []):- 
    score_menu(draw).
game_over(gameState(Board, turn(Player-Color), PM), _PossibleMoves):- 
    end_game(gameState(Board, turn(Player-Color), PM)),
    sleep(2),
    score_menu(Color).


% game_cycle(+GameState, + NextPlayer, + PreviousMove)
game_cycle(gameState(Board, turn(Player-Color), PreviousMove), NextPlayer):-
    get_move(gameState(Board, turn(Player-Color), PreviousMove), NextPlayer, Move),
    move(gameState(Board, turn(Player-Color), PreviousMove), Move, GameState),
    display_game(GameState),!,
    valid_moves(GameState, Moves),
    \+game_over(GameState, Moves),
    next_player(GameState, NextPlayer, NewGameState), !,
    game_cycle(NewGameState, turn(Player-Color)).

% In case of game_cycle failed, calls game cycle again
game_cycle(GameState, NextPlayer) :- 
    game_cycle(GameState, NextPlayer).


% get_move(+ GameState, + Opponent, +PM, -Move)
% Get the move chosen by the level 1 bot
get_move(gameState(Board, turn((computer-1)-Color), PM), _Opponent, Move):-
    valid_moves(gameState(Board, turn((computer-1)-Color), PM), Moves),
    random_move(gameState(Board, turn((computer-1)-Color), PM), Moves, Move),
    sleep(1),
    write('The computer played at '), write(Move), nl.


% 1st strategy
% Check wether or not current player can block the opponent from winning with one of the next possible moves
% if so, choose that move
get_move(gameState(Board, turn((computer-2)-Color), PM), Opponent, Move):-
    write('The computer is thinking...'), nl,
    %check if can prevent user from winning in the next play

    %gets all possible bot moves
    findall((gameState(Board, turn((computer-2)-Color), PM), Opponent, CurrMove), move(gameState(Board, turn((computer-2)-Color), PM), CurrMove, _NewGameState), Moves),
    %check if bot's move can inibit opponent from winning
    check_opponent_win(Moves, Move), !,
    write('Too easy m8.\n'),
    write('The computer played at '), write(Move), nl.

% 2nd strategy
% Minimax implemented with bfs to get the best possible move with the Depth of 5
get_move(gameState(Board, turn((computer-2)-Color), PM), Opponent, Move):-
    Depth is 1000,
    findall((gameState(Board, turn((computer-2)-Color), PM), Opponent, [PM], CurrMove), move(gameState(Board, turn((computer-2)-Color), PM), CurrMove, _NewGameState), Moves),
    choose_move(Moves, Color, Move, Depth), !,
    sleep(1),
    write('Careful. Ive got everything under control.\n'),
    write('The computer played at '), write(Move), nl.

% 3rd strategy
% Greedy algorithm
get_move(gameState(Board, turn((computer-2)-Color), PM), _Opponent, Move):-
    findall((gameState(Board, turn((computer-2)-Color), PM), CurrMove, NewGameState), move(gameState(Board, turn((computer-2)-Color), PM), CurrMove, NewGameState), Moves),
    % write((Moves, bestPosition(((-1)-(-1))-0), Move)),
    sweet_tooth(Moves, bestPosition(((-1)-(-1))-0), Move),
    write('Im tired of thinking. Ill just go with the most obvious one.\n'),
    write('The computer played at '), write(Move), nl.


% Waits for an human move input
get_move(_GameState, _Opponent, L-C):-
    write('Where do you want to play [format: line-column]:'), nl,
    read_move(L-C), !.


% Check_opponent_win(+GameStates, +Move)
%no possible move prevents the player to immediatly win
check_opponent_win([], _Move):- fail.
check_opponent_win([(gameState(Board, turn(Player-_Color), PM), _Opponent, CurrMove)|_Next], Move):-
    move(gameState(Board, Player, PM), CurrMove, TempPlayer),
    %CurrMove generates win 
    end_game(TempPlayer),
    Move = CurrMove.
check_opponent_win([(gameState(Board, turn(_Player-_Color), PM), Opponent, CurrMove)|_Next],Move):-
    move(gameState(Board, Opponent, PM), CurrMove, TempOpponent),
    end_game(TempOpponent),
    %CurrMove blocks a possible win 
    Move = CurrMove.
check_opponent_win([(gameState(Board, turn(_Player-_Color), PM), Opponent, CurrMove)|Next],Move):-
    move(gameState(Board, Opponent, PM), CurrMove, Temp),
    \+ end_game(Temp),
    check_opponent_win(Next, Move).


% sweet_tooth(+GameStates, +BestPosition, -BestMove)
% Greedy algorithm that receives all of the moment's possible plays and
% goes over all of them, saving the best one in bestPosition's bestMove
% and returning it in BestMove
sweet_tooth([], bestPosition(BestMove-_Score), BestMove).

sweet_tooth([(gameState(_Board, turn((computer-2)-_Color), _PM), Move, gameState(NewBoard, turn(_NewPlayer-NewColor), _NPM))| Next], bestPosition(_BestMove-Score), FinalMove):-
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, 0-(+1), 0, HorizontalScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, 0-(-1), HorizontalScore, TotalHScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, 1-0, 0, VerticalScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, -1-0, VerticalScore, TotalVScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (+1)-(+1), 0, DiagonalDScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (-1)-(-1), DiagonalDScore, TotalDDScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (-1)-(+1), 0, DiagonalUScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (+1)-(-1), DiagonalUScore, TotalDUScore),
    TotalHScore >= Score,
    TotalHScore >= TotalDDScore,
    TotalHScore >= TotalVScore,
    TotalHScore >= TotalDUScore,!,
    NewBestMove = Move,
    sweet_tooth(Next, bestPosition(NewBestMove-TotalHScore), FinalMove).

sweet_tooth([(gameState(_Board, turn((computer-2)-_Color), _PM), Move, gameState(NewBoard, turn(_NewPlayer-NewColor), _NPM))| Next], bestPosition(_BestMove-Score), FinalMove):-
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, 0-(+1), 0, HorizontalScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, 0-(-1), HorizontalScore, TotalHScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, 1-0, 0, VerticalScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, -1-0, VerticalScore, TotalVScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (+1)-(+1), 0, DiagonalDScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (-1)-(-1), DiagonalDScore, TotalDDScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (-1)-(+1), 0, DiagonalUScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (+1)-(-1), DiagonalUScore, TotalDUScore),
    TotalDDScore >= Score,
    TotalDDScore >= TotalHScore,
    TotalDDScore >= TotalVScore,
    TotalDDScore >= TotalDUScore,!,
    NewBestMove = Move,
    sweet_tooth(Next, bestPosition(NewBestMove-TotalDDScore), FinalMove).

sweet_tooth([(gameState(_Board, turn((computer-2)-_Color), _PM), Move, gameState(NewBoard, turn(_NewPlayer-NewColor), _NPM))| Next], bestPosition(_BestMove-Score), FinalMove):-
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, 0-(+1), 0, HorizontalScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, 0-(-1), HorizontalScore, TotalHScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, 1-0, 0, VerticalScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, -1-0, VerticalScore, TotalVScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (+1)-(+1), 0, DiagonalDScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (-1)-(-1), DiagonalDScore, TotalDDScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (-1)-(+1), 0, DiagonalUScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (+1)-(-1), DiagonalUScore, TotalDUScore),
    TotalDUScore >= Score,
    TotalDUScore >= TotalHScore,
    TotalDUScore >= TotalVScore,
    TotalDUScore >= TotalDDScore,!,
    NewBestMove = Move,
    sweet_tooth(Next, bestPosition(NewBestMove-TotalDUScore), FinalMove).

sweet_tooth([(gameState(_Board, turn((computer-2)-_Color), _PM), Move, gameState(NewBoard, turn(_NewPlayer-NewColor), _NPM))| Next], bestPosition(_BestMove-Score), FinalMove):-
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, 0-(+1), 0, HorizontalScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, 0-(-1), HorizontalScore, TotalHScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, 1-0, 0, VerticalScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, -1-0, VerticalScore, TotalVScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (+1)-(+1), 0, DiagonalDScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (-1)-(-1), DiagonalDScore, TotalDDScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (-1)-(+1), 0, DiagonalUScore),
    value(gameState(NewBoard-turn(_Player-NewColor), _PM), Move, (+1)-(-1), DiagonalUScore, TotalDUScore),
    TotalVScore >= Score,
    TotalVScore >= TotalHScore,
    TotalVScore >= TotalDUScore,
    TotalVScore >= TotalDDScore,!,
    NewBestMove = Move,
    sweet_tooth(Next, bestPosition(NewBestMove-TotalVScore), FinalMove).

sweet_tooth([(gameState(_Board, turn((computer-2)-_Color), _PM), _NPM, gameState(_NewBoard, turn(_NewPlayer-_NewColor), _NPM))| Next], bestPosition(BestMove-Score), FinalMove):-
    sweet_tooth(Next, bestPosition(BestMove-Score), FinalMove).

    
% choose_move(+Moves, +PlayIdColor, -ChosenMove, +Depth)
% Reached the final depth
choose_move(_Moves, _PlayIdColor, _ChosenMove, 0):- fail.

% Reached the final depth
choose_move([(_GameState, _Opponent, _PreviousMoves, _CurrMove, 0)|_Next], _PlayIdColor, _ChosenMove, _Depth):- fail.

% Ran out of possible moves
choose_move([], _PlayIdColor, _ChosenMove, _Depth):- fail.

% Reaches the 1st complete play (set of moves) that allows the current player to win
% 1st complete play equals the fastest, hence smaller, play - its a bfs
choose_move([(gameState(Board, turn(Player-Color), PM), _Opponent, PreviousMoves, CurrMove)|_Next], PlayIdColor, ChosenMove, Depth):-
    Depth >= 0,
    move(gameState(Board, turn(Player-Color), PM), CurrMove, CurrGameState),
    end_game(CurrGameState), Color = PlayIdColor, !,
    reverse([CurrMove|PreviousMoves], Result),
    nth0(1, Result, ChosenMove).

choose_move([(gameState(Board, turn(Player-Color), PM), _Opponent, _PreviousMoves, CurrMove)|Next], PlayIdColor, ChosenMove, Depth):-
    Depth >= 0,
    move(gameState(Board, turn(Player-Color), PM), CurrMove, CurrGameState),
    end_game(CurrGameState), !,
    choose_move(Next, PlayIdColor, ChosenMove, Depth).

choose_move([(gameState(Board, Player, PM), Opponent, PreviousMoves, CurrMove)|Next], PlayIdColor, Result, Depth):-
    Depth >= 0,
    move(gameState(Board, Player, PM), CurrMove, TempGameState),
    next_player(TempGameState, Opponent, CurrGameState),
    findall((CurrGameState, Player, [CurrMove|PreviousMoves], Move), move(CurrGameState, Move, _NewGameState), Moves),
    append(Next, Moves, NewArray),
    NewDepth is Depth - 1,
    choose_move(NewArray, PlayIdColor, Result, NewDepth).


% random_move(+GameState, +Moves, -Move)
% Randomly selects a valid position
random_move(gameState(_Board, turn((computer-_Level)-_Color), _PM), Moves, Move):-
    random_select(Move, Moves, _Rest).


% valid_moves()
% Get all current valid moves
valid_moves(gameState(Board,_, PM), Moves):-
    findall(Move, validator(Move, PM, Board), Moves).


% Changes the turn to the other player
next_player(gameState(Board, _CurrPlayer, PM), NextPlayer, gameState(Board, NextPlayer, PM)).
