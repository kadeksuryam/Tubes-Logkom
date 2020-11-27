:- include('info.pl').
:- include('util.pl').
/* Player memiliki parameter (Username, job, attack, dmg_skill, defense, hp_now, hp_max, exp_now, exp_next, level, money) */
:- dynamic(player/11).
:- dynamic(statePlayer/1).
/* berisi inventory player yang meliputi : listWeapon, listArmor, listAcc, listSpell */
:- dynamic(inventoryPlayer/4).
:- dynamic(currentEquip/3).

/* Menampilkan status */
status :-
    player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money),
    format('Username: %s\n', [Username]),
    format('Level: %d\n', [Level]),
    format('Job: %s\n', [Job]),
    format('Attack: %d\n', [Attack]),
    format('Damage skill: %d\n',[Dmg_skill]),
    format('Defense: %d\n', [Defense]),
    format('Hp: %.2f/%.2f\n', [Hp_now, Hp_max]),
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
    write('2. Hawkeye '), nl,
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
    write('Current Used Equipment: '), nl,
    currentEquip(CurrWeapon, CurrArmor, CurrAcc),
    write('Weapon: '), write(CurrWeapon), nl,
    write('Armor: '), write(CurrArmor), nl,
    write('Accessoris: '), write(CurrAcc), nl, nl,
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
    write('What you want to do: '), nl,
    write('1. Use/Change Items'), nl,
    write('2. Throw Items'), nl,
    write('Your Choice: '), 
    read(Pil),
    (
        Pil = 1 -> (
            inventoryPlayer(ListWeapon, ListArmor, ListAcc, ListSpell),
            write('What items you want to use/change'),nl,
            write('Item Type: '),
            read(ItemType),
            write('Item Name: '),
            read(ItemName),
            (
                ItemType = weapon -> (
                    
                    member(ItemName, ListWeapon),
                    equip(weapon, _, ItemName, Hp_item, Damage),
                    player(A1, A2, Attack_player, A4, A5, Hp_player, A7, A8, A9, A10, A11),
                    currentEquip(E1, E2, E3),(
                        \+E1 = none ->(
                            equip(weapon, _, E1, Hp_item_now, Damage_item_now),
                            Hp_player_def is Hp_player-Hp_item_now, 
                            Attack_player_def is Attack_player-Damage_item_now
                        );
                        (Hp_player_def is Hp_player, Attack_player_def is Attack_player)
                    ),
                    Attack2 is Attack_player_def+Damage, Hp_player2 is Hp_player_def+Hp_item,
                    retract(currentEquip(_, _, _)),
                    retract(player(_, _, _, _, _, _, _, _, _, _, _)),
                    asserta(player(A1, A2, Attack2, A4, A5, Hp_player2, A7, A8, A9, A10, A11)),
                    asserta(currentEquip(ItemName, E2, E3)), write('Weapon changed to '), write(ItemName), nl, ! 
                );
                ItemType = armor -> (
                    member(ItemName, ListWeapon),
                    equip(armor, _, ItemName, Hp_item, Damage),
                    player(A1, A2, Attack_player, A4, A5, Hp_player, A7, A8, A9, A10, A11),
                    currentEquip(E1, E2, E3),(
                        \+E2 = none ->(
                            equip(weapon, _, E2, Hp_item_now, Damage_item_now),
                            Hp_player_def is Hp_player-Hp_item_now, 
                            Attack_player_def is Attack_player-Damage_item_now
                        );
                        (Hp_player_def is Hp_player, Attack_player_def is Attack_player)
                    ),
                    Attack2 is Attack_player_def+Damage, Hp_player2 is Hp_player_def+Hp_item,
                    retract(currentEquip(_, _, _)),
                    retract(player(_, _, _, _, _, _, _, _, _, _, _)),
                    asserta(player(A1, A2, Attack2, A4, A5, Hp_player2, A7, A8, A9, A10, A11)),
                    asserta(currentEquip(E1, ItemName, E3)), write('Armor changed to '), write(ItemName), nl, !
                );
                ItemType = accessories -> (
                    member(ItemName, ListWeapon),
                    equip(accessories, _, ItemName, Hp_item, Damage),
                    player(A1, A2, Attack_player, A4, A5, Hp_player, A7, A8, A9, A10, A11),
                    currentEquip(E1, E2, E3),(
                        \+E3 = none ->(
                            equip(weapon, _, E3, Hp_item_now, Damage_item_now),
                            Hp_player_def is Hp_player-Hp_item_now, 
                            Attack_player_def is Attack_player-Damage_item_now
                        );
                        (Hp_player_def is Hp_player, Attack_player_def is Attack_player)
                    ),
                    Attack2 is Attack_player_def+Damage, Hp_player2 is Hp_player_def+Hp_item,
                    retract(currentEquip(_, _, _)),
                    retract(player(_, _, _, _, _, _, _, _, _, _, _)),
                    asserta(player(A1, A2, Attack2, A4, A5, Hp_player2, A7, A8, A9, A10, A11)),
                    asserta(currentEquip(E1, E2, ItemName)), write('Accessories changed to '), write(ItemName), nl, !
                );
                ItemType = spell ->(
                    member(ItemName, ListSpell),
                    player(A1, A2, A3, A4, A5, Hp_player, A7, A8, A9, A10, A11),
                    (
                        ItemName = heal ->(
                            write('Your Hp increased by 500!'), nl,
                            Hp_player2 is Hp_player+500
                        );
                        (Hp_player2 is 0)
                    ), inventoryPlayer(ListWeapon, ListArmor, ListAcc, ListSpell), delElmtList(ListSpell, ItemName, I4),
                    retract(player(_, _, _, _, _, _, _, _, _, _, _)),
                    retract(inventoryPlayer(_, _, _, _)),
                    asserta(inventoryPlayer(ListWeapon, ListArmor, ListAcc, I4)),
                    asserta(player(A1, A2, A3, A4, A5, Hp_player2, A7, A8, A9, A10, A11)), !
                )
            )
        );
        /* Saat ngebuang items, dapet duit 50 gold untuk equipment, 25 gold untuk potion*/
        Pil = 2 ->(        
            write('Item\'s Name: '),
            read(ItemName),
            inventoryPlayer(ListWeapon, ListArmor, ListAcc, ListSpell),
            delElmtList(ListWeapon, ItemName, I1),
            delElmtList(ListArmor, ItemName, I2),
            delElmtList(ListAcc, ItemName, I3),
            delElmtList(ListSpell, ItemName, I4),(
            member(ItemName, ListWeapon) -> (
                MoneyAdd is 50
            );
            member(ItemName, ListArmor) -> (
                MoneyAdd is 50
            );
            member(ItemName, ListAcc) -> (
                MoneyAdd is 50
            );
            member(ItemName, ListSpell) -> (
                MoneyAdd is 25
            )),
            player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money),
            Money2 is Money+MoneyAdd,
            retract(player(_, _, _, _, _, _, _, _, _, _, _)),
            retract(inventoryPlayer(_, _, _, _)),
            asserta(inventoryPlayer(I1, I2, I3, I4)),
            asserta(player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money2)),
            infoinventory
        )
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
    ListSpell = [heal, heal, heal, heal, heal],
    CurrWeapon = none,
    CurrArmor = none,
    CurrAcc = none,
    asserta(statePlayer(State)),
    asserta(inventoryPlayer(ListWeapon, ListArmor, ListAcc, ListSpell)),
    asserta(currentEquip(CurrWeapon, CurrArmor, CurrAcc)),
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



