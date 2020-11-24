/* Position represented in Coordinat x,y where mapsize >= x > 0 and mapsize <= y < 0 */
:- dynamic(playerCoor/2).
:- dynamic(storeCoor/2).
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
            (Output =:= 1),
			write('You found a wyvern!'),nl
            /* MEMANGGIL FUNGSI BATTLE DENGAN GOBLIN */
        );
        (
            isGoblinArea(X,Y),
            encounter(goblin,Output),
            (Output =:= 1),
			write('You found a goblin!'),nl
            /* MEMANGGIL FUNGSI BATTLE DENGAN KOBOLD */
        );
        (
            isLamiaArea(X,Y),
            encounter(lamia,Output),
            (Output =:= 1),
			write('You found a lamia!'),nl
            /* MEMANGGIL FUNGSI BATTLE DENGAN LAMIA */
        );
        (
            isKoboldArea(X,Y),
            encounter(kobold,Output),
            (Output =:= 1),
			write('You found a kobold!'),nl
            /* MEMANGGIL FUNGSI BATTLE DENGAN GOBLIN */
        );
        (
            isSlimeArea(X,Y),
            encounter(slime,Output),
            (Output =:= 1),
			write('You found a slime!'),nl
            /* MEMANGGIL FUNGSI BATTLE DENGAN GOBLIN */
        )
    ),!.

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