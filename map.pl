/* Posisi pemain disimpan dengan koordinat x,y dimana x >= 0 dan y >= 0 */
:- dynamic(playerCoor/2).

/* playerCoor(20,-20).*/
initmap :- 
	random(1,20,X),
	random(-20, -1,Y),
	asserta(playerCoor(X,Y)).

/* ukuran map 20x20 */
pagar(0,_).
pagar(_,0).
pagar(21,_).
pagar(_,-21).

/* Basis */
endmap(21,-21):- 
	write('#'),nl.
/* Rekurens */
wrtmap(X,Y):-
	endmap(X,Y);
	pagar(X,Y),(X =\= 21),write('#'),(Z is X+1),wrtmap(Z,Y);
	pagar(X,Y),(X == 21),write('#'),nl,(XX is 0),(YY is Y-1),wrtmap(XX,YY);
	playerCoor(X1, Y1), (X = X1), (Y = Y1), write('P'),(Z is X+1),wrtmap(Z,Y);
	write('-'),(Z is X+1),wrtmap(Z,Y).

map :- retractall(playerCoor(_, _)), initmap, wrtmap(0,0),!.

