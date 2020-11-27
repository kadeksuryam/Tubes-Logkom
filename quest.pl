:- dynamic(quest_info/5).
:- dynamic(quest_prog/6).

updatequest :- 
    retractall(quest_info(_,_,_,_,_)),
    retractall(quest_prog(_,_,_,_,_,_)),
    random(1,21,V),
    random(1,19,W),
    random(1,16,X),
    random(1,16,Y),
    random(1,14,Z),
    asserta(quest_info(V,W,X,Y,Z)),
    asserta(quest_prog(V,W,X,Y,Z,1)),
    playerCoor(XP,YP),
    storeCoor(XS,YS),
    random(2,4,N),
	(
        (
            (N =:= 2),random(2,9,XQ),random(-19,-12,YQ),
            (((XQ =:= XS),(YQ =:= YS),random(2,9,XQ1),random(-19,-12,YQ1));
	        ((XQ1 is XQ+0),(YQ1 is YQ+0))),
            (((XQ1 =:= XP),(YQ1 =:= YP),random(2,9,XQ2),random(-19,-12,YQ2));
	        ((XQ2 is XQ+0),(YQ2 is YQ+0)))
        );
        (
            random(15,20,XQ),random(-18,-11,YQ),
            (((XQ =:= XS),(YQ =:= YS),random(15,20,XQ1),random(-18,-11,YQ1));
	        ((XQ1 is XQ+0),(YQ1 is YQ+0))),
            (((XQ1 =:= XP),(YQ1 =:= YP),random(15,20,XQ2),random(-18,-11,YQ2));
	        ((XQ2 is XQ+0),(YQ2 is YQ+0)))
        )
    ),
	retractall(questCoor(_,_)),
	asserta(questCoor(XQ2,YQ2)),!.

questcleared :- 
    quest_prog(0,0,0,0,0,1),
    player(_, _, _, _, _, _, _, Exp_now, _, Level, Money),
    /* level up player */
    (
        quest_info(V,W,X,Y,Z),
        (
            ((V > 10),(V1 is 125*Level));
            ((V =< 10),(V1 is 50*Level))
        ),
        (
            ((W > 10),(W1 is V1+(125*Level)));
            ((W =< 10),(W1 is V1+(50*Level)))
        ),
        (
            ((X > 10),(X1 is W1+(150*Level)));
            ((X =< 10),(X1 is W1+(75*Level)))
        ),
        (
            ((Y > 10),(Y1 is X1+(150*Level)));
            ((Y =< 10),(Y1 is X1+(75*Level)))
        ),
        (
            ((Z > 10),(Z1 is Y1+(175*Level)));
            ((Z =< 10),(Z1 is Y1+(100*Level)))
        ),
        (
            (NewExp is Exp_now+Z1),
            (Sum is V+W+X+Y+Z),
            (Sum1 is ceiling(Sum/10)*10),
            (Sum2 is Sum1*30),
            (NewMoney is Money+Sum2)
        ),
        (
            retract(player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
            asserta(player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, NewExp, Exp_next, Level, NewMoney))
        )
    ),updatequest,
    write('|//|------------------|//|'),nl,
    write('|//|  Quest Cleared!  |//|'),nl,
    write('|//|------------------|//|'),nl,!.

startquest :-
    quest_info(V,W,X,Y,Z),
	retractall(questCoor(_,_)),
    retract(quest_prog(V,W,X,Y,Z,1)),
    asserta(quest_prog(V,W,X,Y,Z,0)),!.

infoQ :-
    quest_info(V,W,X,Y,Z),
    quest_prog(V2,W2,X2,Y2,Z2,0),
    (V1 is V-V2),(W1 is W-W2),(X1 is X-X2),(Y1 is Y-Y2),(Z1 is Z-Z2),
    write('Active Quest :'),nl,
    write(' _________________________'),nl,
    write('|                         |'),nl,
    (
        (
            (V =< 10),(V1 =< 10),
            format('|  Slime  : ~w/~w   killed  | ~n', [V1, V])
        );
        (
            (V >= 10),(V1 >= 10),
            format('|  Slime  : ~w/~w killed  | ~n', [V1, V])
        );
        (
            format('|  Slime  : ~w/~w  killed  | ~n', [V1, V])
        )
    ),
    (
        (
            (W =< 10),(W1 =< 10),
            format('|  Kobold : ~w/~w   killed  | ~n', [W1, W])
        );
        (
            (W >= 10),(W1 >= 10),
            format('|  Kobold : ~w/~w killed  | ~n', [W1, W])
        );
        (
            format('|  Kobold : ~w/~w  killed  | ~n', [W1, W])
        )
    ),
    (
        (
            (X =< 10),(X1 =< 10),
            format('|  Lamia  : ~w/~w   killed  | ~n', [X1, X])
        );
        (
            (X >= 10),(X1 >= 10),
            format('|  Lamia  : ~w/~w killed  | ~n', [X1, X])
        );
        (
            format('|  Lamia  : ~w/~w  killed  | ~n', [X1, X])
        )
    ),
    (
        (
            (Y =< 10),(Y1 =< 10),
            format('|  Goblin : ~w/~w   killed  | ~n', [Y1, Y])
        );
        (
            (Y >= 10),(Y1 >= 10),
            format('|  Goblin : ~w/~w killed  | ~n', [Y1, Y])
        );
        (
            format('|  Goblin : ~w/~w  killed  | ~n', [Y1, Y])
        )
    ),
    (
        (
            (Z =< 10),(Z1 =< 10),
            format('|  Wyvern : ~w/~w   killed  | ~n', [Z1, Z])
        );
        (
            (Z >= 10),(Z1 >= 10),
            format('|  Wyvern : ~w/~w killed  | ~n', [Z1, Z])
        );
        (
            format('|  Wyvern : ~w/~w  killed  | ~n', [Z1, Z])
        )
    ),
    write('|                         |'),nl,
    write(' _________________________'),nl,!.

infoQ :-
    write('You don\'t have any active quest').

progress_quest(EnemyName) :-
    quest_prog(V,W,X,Y,Z,0),
    ((
        (
            (EnemyName = 'slime'),
            (V =\= 0),(VV is V-1),
            retract(quest_prog(V,W,X,Y,Z,0)),
            ((
                (VV =:= 0),(W =:= 0),(Y =:= 0),(X =:= 0),(Z =:= 0),asserta(quest_prog(0,0,0,0,0,1))
            );
            (
                asserta(quest_prog(VV,W,X,Y,Z,0))
            ))
        );
        (
            (EnemyName = 'kobold'),
            (W =\= 0),(WW is W-1),
            retract(quest_prog(V,W,X,Y,Z,0)),
            ((
                (V =:= 0),(WW =:= 0),(Y =:= 0),(X =:= 0),(Z =:= 0),asserta(quest_prog(0,0,0,0,0,1))
            );
            (
                asserta(quest_prog(V,WW,X,Y,Z,0))
            ))
        );
        (
            (EnemyName = 'lamia'),
            (X =\= 0),(XX is X-1),
            retract(quest_prog(V,W,X,Y,Z,0)),
            ((
                (V =:= 0),(W =:= 0),(Y =:= 0),(XX =:= 0),(Z =:= 0),asserta(quest_prog(0,0,0,0,0,1))
            );
            (
                asserta(quest_prog(V,W,XX,Y,Z,0))
            ))
        );
        (
            (EnemyName = 'goblin'),
            (Y =\= 0),(YY is Y-1),
            retract(quest_prog(V,W,X,Y,Z,0)),
            ((
                (V =:= 0),(W =:= 0),(YY =:= 0),(X =:= 0),(Z =:= 0),asserta(quest_prog(0,0,0,0,0,1))
            );
            (
                asserta(quest_prog(V,W,X,YY,Z,0))
            ))
        );
        (
            (EnemyName = 'wyvern'),
            (Z =\= 0),(ZZ is Z-1),
            retract(quest_prog(V,W,X,Y,Z,0)),
            ((
                (V =:= 0),(W =:= 0),(Y =:= 0),(X =:= 0),(ZZ =:= 0),asserta(quest_prog(0,0,0,0,0,1))
            );
            (
                asserta(quest_prog(V,W,X,Y,ZZ,0))
            ))
        )
    );
    quest_prog(V,W,X,Y,Z,0)
    ),!.