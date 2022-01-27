:-use_module(library(between)).
:-[utils].
% char_code(Symbol, 9552) ==
% char_code(Symbol, 9553) ||
% char_code(Symbol, 9556) :''
% char_code(Symbol, 9559) '':
% char_code(Symbol, 9565) _||
% char_code(Symbol, 9568) ||-
% char_code(Symbol, 9571) -||
% char_code(Symbol, 9574)  T
% char_code(Symbol, 9577) _||_
% char_code(Symbol, 9580) -||-

% Display the number of rows/columns
display_number(N):- 
    N < 10, write(0), write(N), !.
display_number(N):- 
    X is div(N, 10),
    write(X),
    NewX is mod(N, 10),
    write(NewX).

% Print a specific symbol N times
print_symbol(N, Symbol):- 
    between(1, N, _),
    write(Symbol),
    fail.
print_symbol(_N, _Symbol).

% Print the N times the symbol == 
print_cells_space(N):- 
    char_code(Symbol, 9552),
    print_symbol(N, Symbol).

% Display the column identifier
display_col_numbers(Number):-
    between(0, Number, Curr),
    write('       '),
    display_number(Curr),
    fail.
display_col_numbers(_Number):- nl.

% Print the top/bottom rows
print_TB_rows(L, N, Divider, _End):- 
    between(1, N, _),
    print_cells_space(L),
    write(Divider),
    fail.
print_TB_rows(L, _, _, End):- 
    print_cells_space(L), write(End).

display_TB(Length, B, D, E):- 
    write('   '),
    char_code(Begin, B),
    write(Begin),
    char_code(Divider, D),
    char_code(End, E),
    print_TB_rows(8, Length, Divider, End), nl.

% Display the symbol of a cell
display_cell_symbol(Symbol, Div):- 
    write(' '),
    write(Symbol), write(Symbol),
    write(Symbol), write(Symbol),
    write(Symbol), write(Symbol),
    write(' '), write(Div).

display_cells([], _).
% Display a white cell
display_cells([white|Next], Div):- 
    char_code(Symbol, 9617),
    display_cell_symbol(Symbol, Div),
    display_cells(Next, Div).

% Display a black cell
display_cells([black|Next], Div):- 
    char_code(Symbol, 9608),
    display_cell_symbol(Symbol, Div),
    display_cells(Next, Div).

% Display an empty cell
display_cells([empty|Next], Div):- 
    write('        '), write(Div),
    display_cells(Next, Div).

% Display a board row
display_row(Index, Row, Div):- 
    write('   '), write(Div), display_cells(Row, Div), nl,
    display_number(Index), write(' '), write(Div), display_cells(Row, Div), nl,
    write('   '), write(Div), display_cells(Row, Div), nl.

display_rows_division_end(_,0, _).
display_rows_division_end(L,N, Divider):- 
    N > 0,
    write(Divider),
    print_cells_space(L),
    New_N is N - 1,
    display_rows_division_end(L, New_N, Divider).
display_rows_division_en(L, N, Divider):-
    between(1, N, _),
    write(Divider),
    print_cells_space(L),
    fail.
% display_rows_division_end(_,0, _).
% display_rows_division_end(L,N, Divider):- 
%     N > 0,
%     write(Divider),
%     print_cells_space(L),
%     New_N is N - 1,
%     display_rows_division_end(L, New_N, Divider).

display_rows_division(L, N):- 
    char_code(Begin, 9568),
    char_code(Divider, 9580),
    write('   '), write(Begin),
    print_cells_space(L),
    display_rows_division_end(L, N, Divider).

display_board_rows(_, Index, [Row|[]]):- 
    char_code(Div, 9553), display_row(Index, Row, Div).
display_board_rows(Length, Index, [Row|Next]):- 
    char_code(Div, 9553),
    display_row(Index, Row, Div),
    display_rows_division(8, Length),
    char_code(End, 9571), write(End), nl,
    NewIndex is Index + 1,
    display_board_rows(Length, NewIndex, Next).

% Display the board of a specific game state
display_game(gameState(Board, turn(_Player-_Color), _PM)):- 
    header,
    length(Board, Length),
    L is Length - 1,
    display_col_numbers(L),
    display_TB(L, 9556, 9574, 9559),
    display_board_rows(L, 0, Board),
    display_TB(L, 9562, 9577, 9565).

% Fill a line with empty cells
fill_line([]).
fill_line([empty|Template]):- 
    fill_line(Template).

% Fill the board with empty lines
fill_board(_, []).
fill_board(Template, [Template|Board]):- 
    fill_board(Template, Board).

% Create an empty Size x Size board
create_board(Size, Board):- 
    length(Template, Size),
    length(Board, Size),
    fill_line(Template),
    fill_board(Template, Board).
