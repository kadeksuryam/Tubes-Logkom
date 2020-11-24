/* Position represented in Coordinat x,y where x >= 0 and y <= 0 */
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
	retractall(playerCoor(X,Y)),
	asserta(playerCoor(X,Y)),
	/* Store Position */
	random(1,20,XS),
	random(-20,-1,YS),
	(XS =\= X),(YS =\= Y),/* avoiding conflict position */
	retractall(storeCoor(X,Y)),
	asserta(storeCoor(XS,YS)).
	/* Quest Position */
	random(1,20,XS),
	random(-20,-1,YS),
	(XS =\= XS),(YS =\= YS),(XQ =\= X),(YQ =\= Y), /* avoiding conflict position */
	retractall(questCoor(X,Y)),
	asserta(questCoor(XS,YS)).

/* movement */
/* move north */
w :- 
	(playerCoor(X,Y),(Y =\= -1),(YY is Y+1),retract(playerCoor(X,Y)),asserta(playerCoor(X,YY)),
	isUniqueLoc(X,Y,Z),!);
	playerCoor(X,Y),(Y == -1),write('You can\'t move up again'),!.
/* move west */
a :- 
	playerCoor(X,Y),(X =\= 1),(XX is X-1),retract(playerCoor(X,Y)),asserta(playerCoor(XX,Y)),!;
	playerCoor(X,Y),(X == 1),write('You can\'t move left again'),!.
/* move south */
s :- 
	playerCoor(X,Y),(Y =\= -20),(YY is Y-1),retract(playerCoor(X,Y)),asserta(playerCoor(X,YY)),!;
	playerCoor(X,Y),(Y == -20),write('You can\'t move down again'),!.
/* move east */
d :- 
	playerCoor(X,Y),(X =\= 20),(XX is Y+1),retract(playerCoor(X,Y)),asserta(playerCoor(XX,Y)),!;
	playerCoor(X,Y),(X == 20),write('You can\'t move up again'),!.

isUniqueLoc(X,Y,Z) :- 
	/* Reference: 1 for quest, 2 for quest, 3 for common-enemy, 4 for dungeon boss */
	storeCoor(X,Y),(Z is 1);
	questCoor(X,Y),(Z is 2);
	enemyCoor(X,Y),(Z is 3);
	dungeonBossCoorCoor(X,Y),(Z is 4).
	
/* Writing map */
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
	dungeonBossCoor(X,Y),write('D'),(Z is X+1),wrtmap(Z,Y);
	write('-'),(Z is X+1),wrtmap(Z,Y).

