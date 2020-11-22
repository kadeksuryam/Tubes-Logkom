:- dynamic(player/2).

/* Menampilkan cerita dan command-command yang ada */
title :-
    write('[ Insert Cerita Here ]'), nl,
    write('Available command: '), nl,
    write('start. --> start the game'), nl,
    write('map. --> open the map'), nl.

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

initJob :-
    write('Silahkan pilih job yang kamu inginkan'), nl,
    write('Berikut status awal dari masing-masing job: '), nl,nl,
    /* buatlah rule untuk menampilkan status job */
    job_stat,
    write('Job pilihan anda: '), read(Job),
    asserta(player(Job)), write('Selamat berpetualang!'), nl.



/* Main control */
start :-
    title,
    write('Masukkan Username: '),
    read(Username),
    asserta(player(Username)), write('Halo, '),
    write(Username), nl, initJob.
    /* tampilkan map, acak posisi pemain */
    /* as long as, pemain tidak di boss/toko */

