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
    List = [H|_], Ans = H, !.

wrtList([], 1) :- write('None'),nl, !.
wrtList(List, 1) :- nl, List = [H|T],
    write('1. '), write(H), nl, wrtList(T, 2), !.
wrtList(List, It) :-
    List = [H|T],
    write(It), write('. '), write(H), nl, It2 is It+1, wrtList(T, It2), !;
    !.
/*
delElmtList(List, X, Ans) :-
    List = [H|T],
    \+X = H, delElmtList(T, X, Ans2), Ans = [H|Ans2], !;
    List = [_|T], delElmtList(T, X, Ans), !;
    Ans = [],!. 
*/
concatList([], [], ListAns) :- ListAns = [], !.

concatList([], List2, ListAns) :-
    List2 = [H|T], concatList([], T, ListAns2), ListAns = [H|ListAns2], !.

concatList(List1, List2, ListAns) :-
    List1 = [H|T], concatList(T, List2, ListAns2), ListAns = [H|ListAns2], !.

appendList([], X, Ans) :- Ans = [X],!.
appendList(List, X, Ans) :-
    List = [H|T], appendList(T, X, Ans2), Ans = [H|Ans2],!. 


delElmtList([], _, []) :- !.
delElmtList([H|T], H, T) :- !.
delElmtList([H|T], X, [H|Ans]) :- delElmtList(T, X, Ans), !.


getTxtList(List, Ans) :-
    List = [H|T], 
    decompose_file_name(H, _, Name, X),
    (X = '.txt'), getTxtList(T, Ans2), Ans = [Name|Ans2], !;
    List = [_, T], getTxtList(T, Ans2), Ans = Ans2, !;
    Ans = [], !.

/*============ END LIST =========== */