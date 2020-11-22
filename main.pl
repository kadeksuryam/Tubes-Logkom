:- include('fact.pl').

/* Player memiliki parameter (Username, attack, defense, hp_now, hp_max, exp_now, exp_next)*/
:- dynamic(player/7).

/* Menampilkan cerita dan command-command yang ada */
title :- 
    write('[ Insert Cerita Here ]'), nl,
    write('Available command: '), nl,
    write('start. --> start the game'), nl,
    write('map. --> open the map'), nl.

infoJob :-
    write('1. Swordsman'), nl,
    write('Attack : 1'), nl,
    write('Defense: 2'), nl,
    write('hp_max : 3'), nl,
    write('2. Archer'), nl,
    write('Attack : 4'), nl,
    write('Defense: 5'), nl,
    write('hp_max : 6'), nl,
    write('3. Sorcerer'), nl,
    write('Attack : 7'), nl,
    write('Defense: 8'), nl,
    write('hp_max : 9'), nl.    

initJob(Username) :-
    write('Silahkan pilih job yang kamu inginkan'), nl,
    write('Berikut informasi dari masing-masing job: '), nl,
    infoJob,
    write('Job pilihan anda: '), read(Job),
    (
        Exp_now is 0,
        Exp_next is 100,
        Job =:= 1 ->
            job(swordsman, Attack, Defense, Hp_max), 
            asserta(player(Username, Attack, Defense, Hp_max, Hp_max, Exp_now, Exp_next))
    ),
    nl, write('Selamat berpetualang!'), nl.

/* Main control */
start :-
    retractall(player(_, _, _, _, _, _, _)),
    title,
    write('Masukkan Username: '),
    read(Username),
    asserta(player(Username, _, _ , _, _, _, _)), initJob(Username), 
        player(User, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next), 
        write([User, Attack, Defense, Hp_now, Hp_max, Exp_now, Exp_next]), nl.
    /* tampilkan map, acak posisi pemain */
    /* as long as, pemain tidak di boss/toko */
    