cls :- write('\33\[2J').

read_number(Res, Final, Res):-
    peek_code(Final), get_code(Final).

read_number(_Curr, _Final, -1):-
    peek_code(10), get_code(10).

read_number(Curr, Final, Res):-
    get_code(Value),
    between(48, 57, Value), !,
    number_codes(Number, [Value]),
    NewCurr is Curr * 10 + Number,
    read_number(NewCurr, Final, Res).

read_number(_Curr, _Final, _Res):- skip_line, fail.

read_move(L-C):-
    read_number(0, 45, L), !, L >= 0,
    read_number(0, 10, C), !, C >= 0.

read_move(_Move):- fail.
