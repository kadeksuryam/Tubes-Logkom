/*========================== UTILITAS ==========================*/
/* Berisi utilitas tambahan yang diperlukan */


/*============ START LIST =========== */

/* Panjang List */
len([], 0).
len(List, Ans) :- List = [_|T], len(T, Ans2), Ans is 1+Ans2, !.


/* Append Element at the End */
/*
appendEnd(List, Elmt) :-
    write('test').
*/
/* Concat List */
/*
concat(List1, List2, Ans) :-
    write('ok').
*/
/* Access List Elmt */
elmt(List, Idx, Ans) :-
    Idx =\= 1, List = [_|T], 
    Idx2 is Idx-1,
    elmt(T, Idx2, Ans), !;
    List = [H|_], Ans is H, !.

wrtList([], 1) :- write('None'),nl, !.
wrtList(List, It) :-
    List = [H|T], nl,
    write(It), write('. '), write(H), nl, It2 is It+1, wrtList(T, It2), !;
    !.

delElmtList(List, X, Ans) :-
    List = [H|T],
    \+X = H, delElmtList(T, X, Ans2), Ans = [H|Ans2], !;
    List = [_|T], delElmtList(T, X, Ans), !;
    Ans = [],!. 

/*============ END LIST =========== */