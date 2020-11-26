

:- include('battle.pl').
/* Position represented in Coordinat x,y where mapsize >= x > 0 and mapsize <= y < 0 */
:- dynamic(playerCoor/2).
:- dynamic(storeCoor/2).
:- dynamic(questCoor/2).
:- dynamic(enemy/8). 
:- dynamic(isEnemyAlive/1).
:- dynamic(run_prob/1).
:- dynamic(isFight/1).
/* Dungeon boss coordinate */
dungeonBossCoor(20,-20).

/* map size 20x20 */
pagar(0,_).
pagar(_,0).
pagar(21,_).
pagar(_,-21).


/* initialize player, quest, and Store position on map */
initmap :- 
	/* Player position */
	random(1,20,X),
	random(-20,-1,Y),
	retractall(playerCoor(_,_)),
	asserta(playerCoor(X,Y)),
	/* Store Position */
	random(1,20,XS),
	random(-20,-1,YS),
	retractall(storeCoor(_,_)),
	asserta(storeCoor(XS,YS)),
	/* Quest Position */
	random(1,20,XQ),
	random(-20,-1,YQ),
	(((XQ =:= XS),(YQ =:= YS),random(1,20,XQ1),random(-20,-1,YQ1));
	((XQ1 is XQ+0),(YQ1 is YQ+0))),
	retractall(questCoor(_,_)),
	asserta(questCoor(XQ1,YQ1)).

/* ----------- MOVEMENT ---------- */
/* move north */
w :- 
	playerCoor(X,Y),
	(
		(
			(Y =\= -1),(YY is Y+1),retract(playerCoor(X,Y)),asserta(playerCoor(X,YY)),
			((storeCoor(X,Y),shop);(enemy_spotted);write('You move north'))
		);
		(
			(Y == -1),write('You can\'t move north again')
		)
	),!.
/* move west */
a :- 
	playerCoor(X,Y),
	(
		(
			(X =\= 1),(XX is X-1),retract(playerCoor(X,Y)),asserta(playerCoor(XX,Y)),
			((storeCoor(X,Y),shop);(enemy_spotted);write('You move west'))		
		);
		(
			(X == 1),write('You can\'t move west again')
		)
	),!.
/* move south */
s :- 
	playerCoor(X,Y),
	(
		(
			(Y =\= -20),(YY is Y-1),retract(playerCoor(X,Y)),asserta(playerCoor(X,YY)),
			((storeCoor(X,Y),shop);(enemy_spotted);write('You move south'))
		);
		(
			(Y == -20),write('You can\'t move south again')
		)
	),!.
/* move east */
d :- 
	playerCoor(X,Y),
	(
		(
			(X =\= 20),(XX is X+1),retract(playerCoor(X,Y)),asserta(playerCoor(XX,Y)),
			((storeCoor(X,Y),shop);(enemy_spotted);write('You move east'))
		);
		(
			(X == 20),write('You can\'t move right again')
		)
	),!.


/* ----------------- Writing map ------------------ */
/* with assumtion player position has been initialized before */
map :- wrtmap(0,0),!.

/* Basis */
endmap(21,-21):- 
	write('#'),nl.
/* Rekurens */
wrtmap(X,Y):- 
	endmap(X,Y);
	pagar(X,Y),(X =\= 21),write('#'),(Z is X+1),wrtmap(Z,Y);
	pagar(X,Y),(X == 21),write('#'),nl,(XX is 0),(YY is Y-1),wrtmap(XX,YY);
	playerCoor(X,Y),write('P'),(Z is X+1),wrtmap(Z,Y);
	storeCoor(X,Y),write('S'),(Z is X+1),wrtmap(Z,Y);
	questCoor(X,Y),write('Q'),(Z is X+1),wrtmap(Z,Y);
	dungeonBossCoor(X,Y),write('D'),(Z is X+1),wrtmap(Z,Y);
	write('-'),(Z is X+1),wrtmap(Z,Y).
	
/* ---------- Encountering Enemy System ---------- */
enemy_spotted :-
    playerCoor(X,Y),
    (
        (
            isWyvernArea(X,Y),
            encounter(wyvern,Output),
            stat_enemy(wyvern, Attack, Defense, Hp_max),
            get_exp(wyvern,Exp),
            drop(wyvern,Item_drop),
            enemy_skill(wyvern, lockdown, Attack_skill),
            Enemy_name = 'wyvern',
            asserta(enemy(Enemy_name,Attack,Defense, Hp_max, Hp_max,Exp,Item_drop,Attack_skill)),
            (Output =:= 1),
            asserta(isEnemyAlive(1)),
			write('You found a wyvern!'),nl,
            next_action
        );
        (
            isGoblinArea(X,Y),
            encounter(goblin,Output),
            stat_enemy(goblin, Attack, Defense, Hp_max),
            get_exp(goblin,Exp),
            drop(goblin,Item_drop),
            enemy_skill(goblin, provoke, Attack_skill),
            Enemy_name = 'goblin',
            asserta(enemy(Enemy_name,Attack,Defense, Hp_max, Hp_max,Exp,Item_drop,Attack_skill)),
            (Output =:= 1),
            asserta(isEnemyAlive(1)),
			write('You found a goblin!'),nl,
            next_action
        );
        (
            isLamiaArea(X,Y),
            encounter(lamia,Output),
            stat_enemy(lamia, Attack, Defense, Hp_max),
            get_exp(lamia,Exp),
            drop(lamia,Item_drop),
            enemy_skill(lamia, kumiaa, Attack_skill),
            Enemy_name = 'lamia',
            asserta(enemy(Enemy_name,Attack,Defense, Hp_max, Hp_max,Exp,Item_drop,Attack_skill)),
            (Output =:= 1),
            asserta(isEnemyAlive(1)), 
			write('You found a lamia!'),nl,
            next_action
        );
        (
            isKoboldArea(X,Y),
            encounter(kobold,Output),
            stat_enemy(kobold, Attack, Defense, Hp_max),
            get_exp(kobold,Exp),
            drop(kobold,Item_drop),
            enemy_skill(kobold, bold, Attack_skill),
            Enemy_name = 'kobold',
            asserta(enemy(Enemy_name,Attack,Defense, Hp_max, Hp_max,Exp,Item_drop,Attack_skill)),
            (Output =:= 1),
            asserta(isEnemyAlive(1)),
			write('You found a kobold!'),nl,
            next_action
        );
        (
            isSlimeArea(X,Y),
            encounter(slime,Output),
            stat_enemy(slime, Attack, Defense, Hp_max),
            get_exp(slime,Exp),
            drop(slime,Item_drop),
            enemy_skill(slime, gloomy, Attack_skill),
            Enemy_name = 'slime',
            asserta(enemy(Enemy_name,Attack,Defense, Hp_max, Hp_max,Exp,Item_drop,Attack_skill)),
            (Output =:= 1),
            asserta(isEnemyAlive(1)),
			write('You found a slime!'),nl,
            next_action
        )
    ),!.
/* Next Action */
next_action :-
    write('What would you do, adventurer?'), nl,
    write('1. fight'), nl,
    write('2. run'), nl,
    write('> '),
    random(1, 10, P),
    asserta(run_prob(P)), 
    read(Next),(
        Next =:= 1 ->
            fight;
        Next =:= 2 ->
            run    
    ).
/* Enemy Spawn Zone/Area */
/* Format : (enemy_name,Xmin,Xmax,Ymax,Ymin) */
spawn_area(slime,2,7,-2,-15).
spawn_area(slime,11,19,-2,-11).
spawn_area(slime,12,17,-13,-19).
spawn_area(kobold,7,13,-4,-10).
spawn_area(kobold,7,10,-10,-18).
spawn_area(kobold,2,4,-12,-15).
spawn_area(lamia,14,20,-1,-13).
spawn_area(lamia,5,9,-12,-19).
spawn_area(goblin,1,5,-2,-7).
spawn_area(goblin,1,5,-11,-16).
spawn_area(wyvern,8,19,-2,-20).


/* Random Encounter System */
/* Output = 1 if encountering enemy, Output = 0 if not */
encounter(EnemyName,Output) :-
    random(1,100,N),
    (
        (
            /* enemy name : Slime ; Encounter Rate = 30% */
            (EnemyName = 'slime'),
            (((N < 90),(mod(N,3) =:= 0),(Output is 1));(Output is 0))
        );
        (
            /* enemy name : Kobold ; Encounter Rate = 27,5% */
            (EnemyName = 'kobold'),
            (((N < 93),(mod(N,4) =:= 0),(Output is 1));(Output is 0))
        );
        (
            /* enemy name : Lamia; Encounter Rate = 25% */
            (EnemyName = 'lamia'),
            (X is mod(N,4)),
            (((X =:= 2),(Output is 1));(Output is 0))
        );
        (
            /* enemy name : Goblin ; Encounter Rate = 22,5% */
            (EnemyName = 'goblin'),
            (((N < 90),(mod(N,5) =:= 0),(Output is 1));(Output is 0))
        );
        (
            /* enemy name : Wyvern ; Encounter Rate = 20% */
            (EnemyName = 'wyvern'),
            (X is mod(N,5)),
            (((X =:= 2),(Output is 1));(Output is 0))
        )
    ),!.



isSlimeArea(X,Y) :-
    spawn_area(slime,X1,X2,Y1,Y2),
    (X >= X1),(X =< X2),
    (Y =< Y1),(Y >= Y2),!.

isKoboldArea(X,Y) :-
    spawn_area(kobold,X1,X2,Y1,Y2),
    (X >= X1),(X =< X2),
    (Y =< Y1),(Y >= Y2),!.

isLamiaArea(X,Y) :-
    spawn_area(lamia,X1,X2,Y1,Y2),
    (X >= X1),(X =< X2),
    (Y =< Y1),(Y >= Y2),!.

isGoblinArea(X,Y) :-
    spawn_area(goblin,X1,X2,Y1,Y2),
    (X >= X1),(X =< X2),
    (Y =< Y1),(Y >= Y2),!.

isWyvernArea(X,Y) :-
    spawn_area(wyvern,X1,X2,Y1,Y2),
    (X >= X1),(X =< X2),
    (Y =< Y1),(Y >= Y2),!.


/* ---------- BONUS SYSTEM ----------- */
/* Teleportation System */
teleport(X,Y) :- 
	(((X >= 21);(X =< 0);(Y =< -21);(Y >= 0)),write('Invalid Coordinate!!!'),!);
	(inventory(teleport_rune,N),(N > 0),retract(playerCoor(_,_)),asserta(playerCoor(X,Y)),!);
	write('You don\'t have any Teleportation Rune in your inventory.').

/* Info map */
infomap :-
    nl,
    write('Information about the map: '), nl,
    write('P is your position right now'), nl,
    write('Q is Quest position'), nl,
    write('S is Shop position'), nl,
    write('D is the final boss position'), nl.



/* Mungkin dipindahkan ke map.pl */
/* Menampilkan Shop */
shop :-
/*
    playerCoor(X_player, Y_player),
    storeCoor(X_store, Y_store),
    (X_player = X_store), (Y_player = Y_store), */
    write('Welcome to the Shop!'), nl,
    write('1. You can get any equipments by doing \'Gacha\' (100 gold)'), nl,
    write('2. Potion (50 gold)'), nl,
    write('Your choice : '), read(Choice),
    (
        (Choice =:= 1 ->
            player(A1, Job, A3, A4, A5, A6, A7, A8, A9, A10, Money),nl,(
                Money >= 100 ->(
                    retract(player(_, _, _, _, _, _, _, _, _, _, _)),
                    Money2 is Money-100,
                    asserta(player(A1, Job, A3, A4, A5, A6, A7, A8, A9, A10, Money2)),
                    findall(Weapons, equip(weapon, Job, Weapons, _, _), ListofWeapons),
                    findall(Armors , equip(armor, Job, Armors , _, _), ListofArmors),
                    findall(Accessories, equip(accessories, Job, Accessories, _, _), ListofAcc),
                    concatList(ListofWeapons, ListofArmors, Concat1), 
                    concatList(Concat1, ListofAcc, Concat2), len(Concat2, EquipLen),
                    random(1, EquipLen, X), 
                    write('Congratulations! You\'ve got a '),
                    elmt(Concat2, X, Item), write(Item), nl,
                    equip(Type, Job, Item, _, _),
                    inventoryPlayer(ListWeapons, ListArmors, ListAcc, ListSpell),
                    ListWeapons = L1, ListArmors = L2, ListAcc = L3, ListSpell = L4,
                    retract(inventoryPlayer(_, _, _, _)),
                    (
                        Type = weapon -> 
                            appendList(L1, Item, L_New), asserta(inventoryPlayer(L_New, L2, L3, L4));
                        Type = armor ->
                            appendList(L2, Item, L_New), asserta(inventoryPlayer(L1, L_New, L3, L4));
                        Type = accessories ->
                            appendList(L3, Item, L_New), asserta(inventoryPlayer(L1, L2, L_New, L4));
                        Type = spell ->
                            appendList(L4, Item, L_New), asserta(inventoryPlayer(L1, L2, L3, L_New))
                    ),
                    write('The item is already sent to your inventory!'), ! 
                );   
                ( write('Your money isn\'t enough :('), nl)
            )
        );
        ( 
            Choice =:= 2 ->
            player(A1, Job, A3, A4, A5, A6, A7, A8, A9, A10, Money),
            retract(player(_, _, _, _, _, _, _, _, _, _, _)),(
                (Money >= 50) -> (
                    Money2 is Money-50,
                    asserta(player(A1, Job, A3, A4, A5, A6, A7, A8, A9, A10, Money2)),
                    inventoryPlayer(ListWeapons, ListArmors, ListAcc, ListSpell),
                    ListWeapons = L1, ListArmors = L2, ListAcc = L3, ListSpell = L4,
                    retract(inventoryPlayer(_, _, _, _)),
                    write('Potions/Spells: '), nl, write('1. Heal Potion'), nl, write('> '), 
                    read(Pil),(
                        Pil = 1 -> appendList(L4, heal, L_New), asserta(inventoryPlayer(L1, L2, L3, L_New))
                    )
                );
                (write('Your money isn\'t enough :('), nl, asserta(player(A1, Job, A3, A4, A5, A6, A7, A8, A9, A10, Money)))
            )
        )
    ).

