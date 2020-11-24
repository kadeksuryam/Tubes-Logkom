/*========================== UTILITAS ==========================*/
/* Berisi utilitas tambahan yang diperlukan */


/*============ START LIST =========== */

/* Panjang List */
len([], 0).
len(List, Ans) :- List = [H|T], len(T, Ans2), Ans is 1+Ans2, !.

/* Append Element at the End */
appendEnd(List, Elmt) :-
    write('test').

/* Concat List */
concat(List1, List2, Ans) :-
    write('ok').

/* Access List Elmt */
elmt(List, Idx, Ans) :-
    Idx =\= 1, List = [_|T], 
    Idx2 is Idx-1,
    elmt(T, Idx2, Ans), !;
    List = [H|_], Ans is H, !.

/*============ END LIST =========== */