/* Player memiliki parameter (Username, job, attack, defense, hp_now, hp_max, exp_now, exp_next, level, money) */
:- dynamic(player/10).
:- dynamic(statePlayer/1).

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
    write('Job : Swordsman'),nl,
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
    nl, write('Choose your job'), nl,
    write('The following is information from each job:'), nl,
    job_stat,
    Exp_now is 0,
    Exp_next is 100,
    Level is 1,
    Money is 100,
    State = 'adventure',
    asserta(statePlayer(State)),
    write('Your Choice: '), read(Job),
    (
        Job =:= 1 ->
            Job_name = 'swordsman',
            job(swordsman, Attack, Defense, Hp_max),
            asserta(player(Username, Job_name, Attack, Defense, Hp_max, Hp_max, Exp_now, Exp_next, Level, Money));
        Job =:= 2 ->
            Job_name = 'archer',
            job(archer, Attack, Defense, Hp_max),
            asserta(player(Username, Job_name, Attack, Defense, Hp_max, Hp_max, Exp_now, Exp_next, Level, Money));
        Job =:= 3 ->
            Job_name = 'sorcerer',
            job(sorcerer, Attack, Defense, Hp_max),
            asserta(player(Username, Job_name, Attack, Defense, Hp_max, Hp_max, Exp_now, Exp_next, Level, Money))
    ),
    nl, write('Happy Adventuring!!'), nl.



