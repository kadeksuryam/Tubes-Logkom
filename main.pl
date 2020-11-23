:- include('fact.pl').

/* Player memiliki parameter (Username, job, attack, defense, hp_now, hp_max, exp_now, exp_next, level, money) */
:- dynamic(player/10).
:- dynamic(state/1).

/* Menampilkan cerita dan command-command yang ada */
title :-
    write('[ Insert Cerita Here ]'), nl,
    write('Available command: '), nl,
    write('start. --> start the game'), nl,
    write('map. --> open the map'), nl, 
    write('items. --> melihat items yang ada'), nl,
    write('status. --> melihat status pemain'), nl.

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
    write('Defense': 130),nl,
    write('HP : 500')
    ,nl,nl,
    write('2. Hawkeye '),nl,
    write('Job : Archer'),nl,
    write('Attack : 180'),nl,
    write('Defense': 100),nl,
    write('HP : 500')
    ,nl,nl,
    write('3. Evius'),nl,
    write('Job : Sorcerer'),nl,
    write('Attack : 150'),nl,
    write('Defense': 150),nl,
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
        Level is 1,
        Job_name = 'Warrior',
        Money is 100,
        Job =:= 1 ->
            job(swordsman, Attack, Defense, Hp_max), 
            asserta(player(Username, Job_name, Attack, Defense, Hp_max, Hp_max, Exp_now, Exp_next, Level, Money))
    ),
    nl, write('Selamat berpetualang!'), nl.


/* Main control */
start :-
    retractall(player(_, _, _, _, _, _, _, _, _, _)),
    title,
    write('Masukkan Username: '),
    read(Username),
    asserta(player(Username, _, _ , _, _, _, _, _, _, _)), initJob(Username), nl.
    /* tampilkan map, acak posisi pemain */
    /* as long as, pemain tidak di boss/toko */

