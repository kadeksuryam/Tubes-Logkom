:- include('map.pl'). 
:- include('player.pl').

/* Main control */
start :-
    retractall(player(_, _, _, _, _, _, _, _, _, _)),
    write('Welcome to This Game!'), nl,
    write('1. Load save file'), nl,
    write('2. New Game'), nl,
    write('> '),
    read(Pil),
    (
        Pil =:= 1 ->
            load;
        Pil =:= 2 ->
            write('What is your name, Adventurer? : '),
            read(Username),
            asserta(player(Username, _, _ , _, _, _, _, _, _, _)), initJob(Username), nl
    ), initmap, map, infomap.

/* Quit */
quit :-
    write('Thank you playing this game!'), nl,
    write('Do you want to save current stat? (y/n) : '),
    read(Pil),
    (
        Pil = 'y' -> 
            write('Give a name to the save file: '),
            read(SaveFileName),
            atom_concat(SaveFileName, '.txt', SaveFileName2),
            open(SaveFileName2, write, Stream),
            player(Username, Job, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money),
            statePlayer(State),
            write(Stream, [Username, Job, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money, State]), write(Stream, '.'),
            nl(Stream), close(Stream), write('Current stat has already saved!'),nl, write('See you next time!'), nl,!;
        Pil = 'n' ->
            write('See you next time!'), nl, !
    ).
    /*halt(0). */

/* load save file */
/* Asumsikan file sudah ada */
load :- 
    write('Input the save file name : '),
    read(SaveFileName),
    atom_concat(SaveFileName, '.txt', SaveFileName2),
    open(SaveFileName2, read, Stream),
    \+ at_end_of_stream(Stream),
    read(Stream, X),
    X = [Username, Job_name, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money, State|_],
    asserta(player(Username, Job_name, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
    asserta(statePlayer(State)),
    read(Stream, PosPemain),
    write(PosPemain),
     close(Stream), !;
    at_end_of_stream(Stream).