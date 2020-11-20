:- dynamic(player/2).

/* Menampilkan cerita dan command-command yang ada */
title :- 
    write('[ Insert Cerita Here ]'), nl,
    write('Available command: '), nl,
    write('start. --> start the game'), nl,
    write('map. --> open the map'), nl.

initJob :-
    write('Silahkan pilih job yang kamu inginkan'), nl,
    write('Berikut status awal dari masing-masing job: '), nl,
    /* buatlah rule untuk menampilkan status job */
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
    