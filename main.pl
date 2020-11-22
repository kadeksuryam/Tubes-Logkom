:- include('fact.pl').

/* Player memiliki parameter (Username, attack, defense, hp_now, hp_max, exp_now, exp_next)*/
:- dynamic(player/7).

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
    write('quit. --> quit the game'),nl,
    write('A. --> move left'),nl,
    write('W. --> move up '),nl,
    write('S. --> move down'),nl,
    write('D. --> move right'),nl.

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
    write('Job pilihan anda: '), read(Job),
    (
        Exp_now is 0,
        Exp_next is 100,
        Job =:= 1 ->
            job(swordsman, Attack, Defense, Hp_max),
            asserta(player(Username, Attack, Defense, Hp_max, Hp_max, Exp_now, Exp_next));
        Exp_now is 0,
        Exp_next is 100,
        Job =:= 2 ->
            job(archer, Attack, Defense, Hp_max),
            asserta(player(Username, Attack, Defense, Hp_max, Hp_max, Exp_now, Exp_next));
        Exp_now is 0,
        Exp_next is 100,
        Job =:= 3 ->
            job(sorcerer, Attack, Defense, Hp_max),
            asserta(player(Username, Attack, Defense, Hp_max, Hp_max, Exp_now, Exp_next))

    ),
    nl, write('Selamat berpetualang!'), nl.

/* Main control */
start :-
    retractall(player(_, _, _, _, _, _, _)),
    title,
    write('Masukkan Username: '),
    read(Username),
    asserta(player(Username, _, _ , _, _, _, _)),initJob(Username),
        player(User, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next),
        write('--------------------------------------------------------------'), nl,
        write('[Username, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next]'), nl,
        write('--------------------------------------------------------------'), nl,nl,
        write([User, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next]), nl.
    /* tampilkan map, acak posisi pemain */
    /* as long as, pemain tidak di boss/toko */

