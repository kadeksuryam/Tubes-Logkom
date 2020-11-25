:- include('info.pl').
:- include('util.pl').
/* Player memiliki parameter (Username, job, attack, dmg_skill, defense, hp_now, hp_max, exp_now, exp_next, level, money) */
:- dynamic(player/11).
:- dynamic(statePlayer/1).
/* berisi inventory player yang meliputi : listWeapon, listArmor, listAcc, listSpell */
:- dynamic(inventoryPlayer/4).


/* Menampilkan status */
status :-
    player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money),
    format('Username: %s\n', [Username]),
    format('Level: %d\n', [Level]),
    format('Job: %s\n', [Job]),
    format('Attack: %d\n', [Attack]),
    format('Damage skill: %d\n',[Dmg_skill]),
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

/* Menampilkan inventory user */
infoinventory :-
    write('Your Inventory: '), nl,
    inventoryPlayer(ListWeapon, ListArmor, ListAcc, ListSpell),nl,
    write('Weapons: '), 
    wrtList(ListWeapon, 1),
    write('Armor: '), 
    wrtList(ListArmor, 1),
    write('Accesoris: '),
    wrtList(ListAcc, 1),
    write('Spell: '),
    wrtList(ListSpell, 1),
    write('Total: '), 
    len(ListWeapon, I1), len(ListArmor, I2), len(ListAcc, I3), len(ListSpell, I4), I is I1+I2+I3+I4,
    write(I), write('/100'),  nl, !.

inventory :-
    write('Hello! Welcome to your Inventory!'),nl,
    infoinventory, nl,
    write('Do you want to throw some of your items? (y/n): '), 
    read(Pil),
    (
        Pil = 'y',        
            write('Item\'s Name: '),
            read(ItemName),
            inventoryPlayer(ListWeapon, ListArmor, ListAcc, ListSpell),
            delElmtList(ListWeapon, ItemName, I1),
            delElmtList(ListArmor, ItemName, I2),
            delElmtList(ListAcc, ItemName, I3),
            delElmtList(ListSpell, ItemName, I4),
            retractall(inventoryPlayer(_, _, _, _)),
            asserta(inventoryPlayer(I1, I2, I3, I4)),
            infoinventory
    ).

initJob(Username) :-
    nl, write('Choose your job'), nl,
    write('The following is information from each job:'), nl,
    job_stat,
    Exp_now is 0,
    Exp_next is 100,
    Level is 1,
    Money is 100,
    State = 'adventure',
    ListWeapon = [],
    ListArmor = [],
    ListAcc = [],
    ListSpell = [],
    asserta(statePlayer(State)),
    asserta(inventoryPlayer(ListWeapon, ListArmor, ListAcc, ListSpell)),
    write('Your Choice: '), read(Job),
    (
        Job =:= 1 ->
            Job_name = 'swordsman',
            job(swordsman, Attack, Defense, Hp_max),
            player_skill(swordsman,sword_mastery,Dmg_skill),
            asserta(player(Username, Job_name, Attack, Dmg_skill,Defense, Hp_max, Hp_max, Exp_now, Exp_next, Level, Money));
        Job =:= 2 ->
            Job_name = 'archer',
            job(archer, Attack, Defense, Hp_max),
            player_skill(archer, meteor_arrow,Dmg_skill),
            asserta(player(Username, Job_name, Attack, Dmg_skill, Defense, Hp_max, Hp_max, Exp_now, Exp_next, Level, Money));
        Job =:= 3 ->
            Job_name = 'sorcerer',
            job(sorcerer, Attack, Defense, Hp_max),
            player_skill(sorcerer,deadly_curse,Dmg_skill),
            asserta(player(Username, Job_name, Attack, Dmg_skill, Defense, Hp_max, Hp_max, Exp_now, Exp_next, Level, Money))
    ),
    nl, write('Happy Adventuring!!'), nl.



