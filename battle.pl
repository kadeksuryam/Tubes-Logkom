
/*enemy(enemy_name,atk,def, hp_now, hp_max,exp,drop,atk_skill)*/
/*player(Username, Job, Attack, dmg_skill,Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)*/
:- dynamic(isEnemySkill/1).
:- dynamic(isFight/1).
:- dynamic(isSkill/1).
:- dynamic(isRun/1).


run :-
    \+ isEnemyAlive(_),
    write('you haven\'t found the enemy'),
    !.

run :-
    \+ isRun(_),
    isEnemyAlive(_),
    run_prob(P), 
    P < 6,
    write('you fail to run, you have to kill the enemy !'), nl,
    retract(run_prob(P)),
    fight,
    !.

run :-
    \+ isRun(_),
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
    ni,
    !.

fight :-
    asserta(isRun(1)),
    asserta(isFight(1)),
    isEnemyAlive(_),
    asserta(isSkill(1)),
    asserta(isEnemySkill(1)),
    ni,
    !.

ni :- 
    write('Make decisions quickly, adventurer !!!'), nl,
    write('1. player_atk'), nl,
    write('2. player_skill'), nl,
    write('> '),
    read(Next),(
        Next =:= 1 ->
            player_atk;
        Next =:= 2 ->
            player_skill    
    ).


/* ~ After Player Atk ~ */
/* Enemy's HP <= 0 */
after_player_atk :-
    player(_, _, _, _, _, _, _, Exp_now, _, Level, Money),
    enemy(Enemy_name, _, _, EnemyHp, _, _, _, _),
    /*enemy(Enemy_name, _, _, EnemyHp, _, _, Drop, _),*/
    EnemyHp =< 0,
    write(Enemy_name),write(' is defeated'),nl,
    /* Ambil drop ITEM blm */
    retract(isFight(_)),
    retract(isEnemyAlive(_)),
    NewMoney is (Money + 15),
    NewExp is (Exp_now  + 15*Level),
    retract(player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
    asserta(player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, NewExp, Exp_next, Level, NewMoney)),
    !.

/* Enemy's HP > 0 */
after_player_atk :-
    enemy(Enemy_name, _, _, EnemyHp, _, _, _, _),
    EnemyHp > 0,
    write('Remaining Hp '), write(Enemy_name), write(' : '), write(EnemyHp),nl,
    write('Enemy turn'),nl,
    enemy_turn,
    !.
/*End ~ After Player Atk ~ */

/* ~ After Enemy Atk ~ */

/* Player's HP <= 0 */
after_enemy_atk :-
    player(_, _, _,_,_, Hp_now, _, _, _, _, _),
    Hp_now =< 0,
    write('You Lose !!!'),nl,
    !.

/* Player's HP > 0 */
after_enemy_atk :-
    player(Username, _, _,_,_, Hp_now, _, _, _, _, _),
    Hp_now > 0,
    write('Remaining Hp '), write(Username), write(' : '), write(Hp_now),nl,
    write('Your turn: '), nl, ni,
    !.

/* End ~ After Enemy Atk ~ */
player_atk :- 
    \+ isEnemyAlive(_),
    write('you haven\'t found the enemy'),nl,
    !
    
player_atk :-
    isEnemyAlive(_),
    player(Username,_, Attack,_,_,_,_,_,_,_,_),
    enemy(_,_,Def,Hp_now,_,_,_,_),
    NewEnemyHealth is (Hp_now - (Attack - (0.2*Def))),
    retract(enemy(Enemy_name, Atk, Def, Hp_now, Hp_max, Get_exp, Drop, Atk_skill)),
    asserta(enemy(Enemy_name, Atk, Def, NewEnemyHealth, Hp_max, Get_exp, Drop, Atk_skill)),
    write(Username), write(' use basic attack !'),nl,
    after_player_atk,
    !.

player_skill :-
    \+ isEnemyAlive(_),
    write('you haven\'t found the enemy'),
    !.

player_skill :-
    \+ isSkill(_),
    write('skill is on cooldown, choose another one !'),nl,ni,
    !.

player_skill :-
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
    after_player_atk,
    !.

enemy_turn :-
    random(1,5,X),
    (X =< 3 ->
        enemy_atk; enemy_skill
    ),
    !.

enemy_atk :-
    enemy(Enemy_name,Atk_enemy,_,_,_,_,_,_),
    player(_, _, _,_, Defense, Hp_now, Hp_max, _, _, _, _),
    NewHealth is (Hp_now-(Atk_enemy-(0.1*Defense))),
    retract(player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
    asserta(player(Username, Job, Attack, Dmg_skill, Defense, NewHealth, Hp_max, Exp_now, Exp_next, Level, Money)),
    write(Enemy_name), write(' use basic attack !'), nl,
    after_enemy_atk,
    !.

enemy_skill :-
    \+ isEnemySkill(_),
    enemy_atk.

enemy_skill :-
    enemy(Enemy_name,_,_,_,_,_,_,Atk_skill),
    player(_, _, _,_, Defense, Hp_now, Hp_max, _, _, _, _),
    NewHealth is (Hp_now - (Atk_skill-(0.1*Defense))),
    retract(player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
    asserta(player(Username, Job, Attack, Dmg_skill, Defense, NewHealth, Hp_max, Exp_now, Exp_next, Level, Money)),
    enemy_skill(Enemy_name, X,_),
    write(Enemy_name), write(' use '), write(X), write('!!!'), nl,
    retract(isEnemySkill(_)),
    after_enemy_atk,
    !.