/* Map dengan ukuran 10*10 */

initCol(1, ['.']) :- !.
initCol(N, ['.' | T]) :-
    N2 is N-1, initCol(N2, T).

initMat(1, M, Mat) :- 
    initCol(M, Rows), Mat = [Rows],!.vb 

initMat(N, M, Mat) :-
    N > 1, N2 is N-1, initCol(M, Rows), Mat = [Rows], initMat(N2, M, T)
