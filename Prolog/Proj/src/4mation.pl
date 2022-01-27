:-[game].

display_menu(1):-
    cls, 
    play_menu,    
    sleep(3),
    fail.
display_menu(2):-
    cls,
    instructions_menu,
    sleep(3),
    fail.
display_menu(3).

play:- 
    main_menu(Option),
    display_menu(Option).
play:- play.