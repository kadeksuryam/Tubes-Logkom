
/*enemy(enemy_name,atk,def, hp_now, hp_max,exp,drop,atk_skill)*/
/*player(Username, Job, Attack, dmg_skill,Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)*/
:- dynamic(isEnemySkill/1).
:- dynamic(isFight/1).
:- dynamic(isSkill/1).


run :-
    \+ isEnemyAlive(_),
    write('you haven\'t found the enemy'),
    !.

run :-
    isEnemyAlive(_),
    run_prob(P), 
    P < 6,
    write('you fail to run, you have to kill the enemy !'), nl,
    retract(run_prob(P)),
    fight,
    !.

run :-
    isEnemyAlive(_),
    run_prob(P),
    P >= 6,
    write('you success escape from the enemy.'),nl,
    retract(run_prob(P)),
    retract(isEnemyAlive(_)),
    retract(enemy(_, _, _, _, _, _, _, _)),
    (
        isEnemySkill(_) ->
        retract(isEnemySkill(_))
    )
    ,!.

fight :-
    \+ isEnemyAlive(_),
    write('you haven\'t found the enemy'),
    !.

fight :-
    isFight(_),
    isEnemyAlive(_),
    write('the battle is ongoing,'), nl,
    player_turn(_),
    !.

fight :-
    asserta(isFight(1)),
    isEnemyAlive(_),
    asserta(isSkill(1)),
    asserta(isEnemySkill(1)),
    player_turn(0),
    !.

player_turn(Count) :- 
    write('Make decisions quickly, adventurer !!!'), nl,
    write('1. player_atk'), nl,
    write('2. player_skill'), nl,
    write('> '),
    read(Next),(
        Next =:= 1 ->
            player_atk(Count);
        Next =:= 2 ->
            player_skill(Count)
    ),!.


/* ~ After Player Atk ~ */

/* Enemy's HP <= 0 */

after_player_atk(_,Enemy_name) :-
    enemy(Enemy_name, _, _, EnemyHp, _, ExpGet, _, _),
    EnemyHp =< 0,
    retract(isFight(_)),
    retract(isEnemyAlive(_)),
    write(Enemy_name),write(' is defeated'),nl,
    retract(enemy(_,_,_,_,_,_,_,_)),
    player(_, _, _, _, _, _, _, Exp_now, _, Level, Money),
    NewMoney is (Money + 15),
    NewExp is (Exp_now  + ExpGet),
    retract(player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
    asserta(player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, NewExp, Exp_next, Level, NewMoney)),
	progress_quest(Enemy_name),questcleared,
    level_player(NewExp,Exp_next),
    !.

/* Enemy's HP > 0 */
after_player_atk(Count,Enemy_name) :-
    enemy(Enemy_name, _, _, EnemyHp, _, _, _, _),
    EnemyHp > 0,
    write('Remaining Hp '), write(Enemy_name), write(' : '), write(EnemyHp),nl,
    write('Enemy turn'),nl,
    enemy_turn(Count,Enemy_name),
    !.

/*End ~ After Player Atk ~ */

/* ~ After Enemy Atk ~ */

/* Player's HP <= 0 */
after_enemy_atk(_) :-
    isEnemyAlive(_),
    player(_, _, _,_,_, Hp_now, _, _, _, _, _),
    Hp_now =< 0,
    write('You Lose !!!'),nl,    
    !.

/* Player's HP > 0 */
after_enemy_atk(Count) :-
    isEnemyAlive(_),
    player(Username, _, _,_,_, Hp_now, _, _, _, _, _),
    Hp_now > 0,
    write('Remaining Hp '), write(Username), write(' : '), write(Hp_now),nl,
    write('Your turn: '), nl, player_turn(Count),
    !.

/* End ~ After Enemy Atk ~ */
player_atk(_) :- 
    \+ isEnemyAlive(1),
    write('you haven\'t found the enemy'),nl,
    !.
    
player_atk(Count) :-
    isEnemyAlive(1),
    player(Username,_, Attack,_,_,_,_,_,_,_,_),
    enemy(_,_,Def,Hp_now,_,_,_,_),
    NewEnemyHealth is (Hp_now - (Attack - (0.2*Def))),
    retract(enemy(Enemy_name, Atk, Def, Hp_now, Hp_max, Get_exp, Drop, Atk_skill)),
    asserta(enemy(Enemy_name, Atk, Def, NewEnemyHealth, Hp_max, Get_exp, Drop, Atk_skill)),
    write(Username), write(' use basic attack !'),nl,
    after_player_atk(Count,Enemy_name),
    !.

player_skill(_) :-
    \+ isEnemyAlive(1),
    write('you haven\'t found the enemy'),
    !.

player_skill(Count) :-
    \+ isSkill(_),
    write('skill is on cooldown, choose another one !'),nl,player_turn(Count),
    !.

player_skill(Count) :-
    isEnemyAlive(_),
    isSkill(_),
    player(Username,Job,_,Dmg_skill,_,_,_,_,_,_,_),
    enemy(_,_,Def,Hp_now,_,_,_,_),
    NewEnemyHealth is (Hp_now - (Dmg_skill - (0.2*Def))),
    retract(enemy(Enemy_name, Atk, Def, Hp_now, Hp_max, Get_exp, Drop, Atk_skill)),
    asserta(enemy(Enemy_name, Atk, Def, NewEnemyHealth, Hp_max, Get_exp, Drop, Atk_skill)),
    player_skill(Job, Skill_name, _),
    write(Username), write(' use '), write(Skill_name), write('!!!'),nl,
    retract(isSkill(_)),
    after_player_atk(Count,Enemy_name),
    !.

enemy_turn(Count,Enemy_name) :-
    isEnemyAlive(_),
    Count < 3, 
    Newcount is Count + 1,
    random(1,5,X),
    (X =< 3 ->
        enemy_atk(Newcount,Enemy_name); enemy_skill(Newcount,Enemy_name)
    ),
    !.

enemy_turn(Count,Enemy_name) :-
    isEnemyAlive(_),
    Count >= 3, 
    asserta(isSkill(1)),
    Newcount is 0,
    random(1,5,X),
    (X =< 3 ->
        enemy_atk(Newcount,Enemy_name); enemy_skill(Newcount,Enemy_name)
    ),
    !.

enemy_atk(_,_) :-
    \+isEnemyAlive(_),
    fail,
    !.

enemy_atk(Count,Enemy_name) :-
    isEnemyAlive(_),
    enemy(Enemy_name,Atk_enemy,_,_,_,_,_,_),
    player(_, _, _,_, Defense, Hp_now, Hp_max, _, _, _, _),
    NewHealth is (Hp_now-(Atk_enemy-(0.1*Defense))),
    retract(player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
    asserta(player(Username, Job, Attack, Dmg_skill, Defense, NewHealth, Hp_max, Exp_now, Exp_next, Level, Money)),
    write(Enemy_name), write(' use basic attack !'), nl,
    after_enemy_atk(Count),
    !.

enemy_skill(_,_) :-
    \+ isEnemySkill(_),
    enemy_atk(_,_).

enemy_skill(Count,Enemy_name) :-
    enemy(Enemy_name,_,_,_,_,_,_,Atk_skill),
    player(_, _, _,_, Defense, Hp_now, Hp_max, _, _, _, _),
    NewHealth is (Hp_now - (Atk_skill-(0.1*Defense))),
    retract(player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
    asserta(player(Username, Job, Attack, Dmg_skill, Defense, NewHealth, Hp_max, Exp_now, Exp_next, Level, Money)),
    enemy_skill(Enemy_name, X,_),
    write(Enemy_name), write(' use '), write(X), write('!!!'), nl,
    retract(isEnemySkill(_)),
    after_enemy_atk(Count),
    !.


level_player(Exp_now,Exp_next) :- 
    Exp_now >= Exp_next,
    player(_, _, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now,Exp_next, Level, _),
    TempLevel is (Level + 1),
    TempHP_max is Hp_max + 500,
    TempAtk is Attack + 30,
    TempDmg_skill is Dmg_skill + 10,
    TempDef is Defense + 15,
    TempExp_next is 2*Exp_next,
    retract(player(Username, Job, Attack, Dmg_skill,Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
    asserta(player(Username, Job, TempAtk, TempDmg_skill,TempDef, TempHP_max, TempHP_max, Exp_now, TempExp_next, TempLevel, Money)),
    write('You have Leveled Up!!!'),nl,
    !.

level_enemy :-
    enemy(_,Atk,Def, Hp_now, Hp_max, Get_Exp, _, Atk_skill),
    TempAtk is Atk + 30,
    TempDef is Def + 30,
    TempHP_max is Hp_max + 300,
    TempGet_exp is Get_Exp + 5,
    TempAtk_skill is Atk + 30,
    retract(enemy(Enemy_name,Atk,Def, Hp_now, Hp_max, Get_Exp, Drop, Atk_skill)),
    asserta(enemy(Enemy_name, TempAtk, TempDef, Hp_now, TempHP_max, TempGet_exp, Drop, TempAtk_skill)),
    !.
    
