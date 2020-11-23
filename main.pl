:- include('fact.pl').
:- include('map.pl').

/* Player memiliki parameter (Username, job, attack, defense, hp_now, hp_max, exp_now, exp_next, level, money) */
:- dynamic(player/10).
:- dynamic(statePlayer/1).

/* Menampilkan cerita dan command-command yang ada */
title :-
    write('[ Insert Cerita Here ]'), nl,
    help.

help :-
    write('Available command: '), nl,nl,
    write('start. --> start the game'), nl,
    write('map. --> open the map'), nl,
    write('help. --> open available commands'),nl,
    write('inventory. --> open inventory'),nl,
    write('A. --> move left'),nl,
    write('W. --> move up '),nl,
    write('S. --> move down'),nl,
    write('D. --> move right'),nl,
    write('status. --> open status pemain'), nl, nl.

/* Menampilkan Item */


/* Menampilkan status */
status :-
    player(Username, Job, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money),
    format('Username: %s\n', [Username]),
    format('Level: %d\n', [Level]),
    format('Job: %s\n', [Job]),
    format('Attack: %d\n', [Attack]),
    format('Defense: %d\n', [Defense]),
    format('Hp: %d/%d\n', [Hp_now, Hp_max]),
    format('Exp: %d/%d\n', [Exp_now, Exp_next]),
    format('Money: %d\n', [Money]), !.


 /* Menampilkan status setiap job */   
job_stat :-
    write('1. Achilles'),nl,
    write('Job : Warrior'),nl,
    write('Attack : 160'),nl,
    write('Defense: 130'),nl,
    write('HP : 500')
    ,nl,nl,
    write('2. Hawkeye '),nl,
    write('Job : Archer'),nl,
    write('Attack : 180'),nl,
    write('Defense: 100'),nl,
    write('HP : 500')
    ,nl,nl,
    write('3. Evius'),nl,
    write('Job : Sorcerer'),nl,
    write('Attack : 150'),nl,
    write('Defense: 150'),nl,
    write('HP : 500'),
    nl,nl.

initJob(Username) :-
    write('Silahkan pilih job yang kamu inginkan'), nl,
    write('Berikut informasi dari masing-masing job: '), nl,
    job_stat,
    Exp_now is 0,
    Exp_next is 100,
    Level is 1,
    Job_name = 'Warrior',
    Money is 100,
    State = 'berpetualang',
    asserta(statePlayer(State)),
    write('Job pilihan anda: '), read(Job),
    (
        Job =:= 1 ->
            job(swordsman, Attack, Defense, Hp_max),
            asserta(player(Username, Job_name, Attack, Defense, Hp_max, Hp_max, Exp_now, Exp_next, Level, Money));
        Job =:= 2 ->
            job(archer, Attack, Defense, Hp_max),
            asserta(player(Username, Job_name, Attack, Defense, Hp_max, Hp_max, Exp_now, Exp_next, Level, Money));
        Job =:= 3 ->
            job(sorcerer, Attack, Defense, Hp_max),
            asserta(player(Username, Job_name, Attack, Defense, Hp_max, Hp_max, Exp_now, Exp_next, Level, Money))
    ),
    nl, write('Selamat berpetualang!'), nl.




/* Main control */
start :-
    retractall(player(_, _, _, _, _, _, _, _, _, _)),
    write('Untuk memulai game pilih: '), nl,
    write('1. Load save file'), nl,
    write('2. New Game'), nl,
    write('> '),
    read(Pil),
    (
        Pil =:= 1 ->
            load;
        Pil =:= 2 ->
            title,
            write('Masukkan Username: '),
            read(Username),
            asserta(player(Username, _, _ , _, _, _, _, _, _, _)), initJob(Username), nl
    ).

    /* tampilkan map, acak posisi pemain */
    /* as long as, pemain tidak di boss/toko */

/* Quit */
quit :-
    write('Terimakasih telah bermain game ini'), nl,
    write('Apakah anda ingin menyimpan state saat ini? (y/n) : '),
    read(Pil),
    (
        Pil = 'y' -> 
            write('Berikan nama save file: '),
            read(SaveFileName),
            atom_concat(SaveFileName, '.txt', SaveFileName2),
            open(SaveFileName2, write, Stream),
            player(Username, Job, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money),
            statePlayer(State),
            write(Stream, [Username, Job, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money, State]),
            nl(Stream), close(Stream), write('State saat ini sudah tersimpan!'),nl, write('See you next time!'), nl,!;
        Pil = 'n' ->
            write('See you next time!'), nl, !
    ).

/* load save file */
/* Asumsikan file sudah ada */
load :- 
    write('Masukkan nama save file : '),
    read(SaveFileName),
    atom_concat(SaveFileName, '.txt', SaveFileName2),
    open(SaveFileName2, read, Stream),
    \+ at_end_of_stream(Stream),
    read(Stream, X),
    X = [Username, Job, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money, State|_],
    asserta(player(Username, Job, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
    asserta(statePlayer(State)), close(Stream);
    at_end_of_stream(Stream).