
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
    write('you success escape from the enemy.'),
    retract(peluang(P)),
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
    !.

fight :-
    asserta(isRun(1)),
    asserta(isFight(1)),
    asserta(isSkill(1)),
    isEnemyAlive(_),
    asserta(isEnemySkill(1)),
    ni,
    !.

ni :- 
    write("Choose :"),nl,
    write('player_atk.'),nl,
    write('OR'),nl,
    write('player_skill.'),nl,
    !.


/* ~ After Player Atk ~ */
/* Enemy's HP > 0 */
after_player_atk :-
    enemy(enemy_name,_,_,Enemy_Hp,_,_,_,_),
    Enemy_Hp > 0,
    write('Remaining Hp'), write(enemy_name), write(' : '), write(Enemy_Hp),
    write('Enemy turn'),nl,
    enemy_turn,
    !.
/* Enemy's HP <= 0 */
after_player_atk :-
    enemy(enemy_name,_,_,Enemy_Hp,_,_,drop,_),
    Enemy_Hp =< 0,
    write(enemy_name),write(' defeated'),
    !.
    /* Ambil drop ITEM blm */
/*End ~ After Player Atk ~ */

/* ~ After Enemy Atk ~ */
/* Player's HP > 0 */
after_enemy_atk :-
    player(Username, _, _,_,_, Hp_now, _, _, _, _, _),
    Hp_now > 0,
    write('Remaining Hp'), write(Username), write(' : '), write(Hp_now),
    !.
/* Player's HP <= 0 */
after_enemy_atk :-
    player(_, _, _,_,_, Hp_now, _, _, _, _, _),
    Hp_now =< 0,
    write('You Lose !!!'),
    !.

/* End ~ After Enemy Atk ~ */
player_atk :- 
    \+ isEnemyAlive(_),
    write('you haven\'t found the enemy'),
    !.
    
player_atk :-
    isEnemyAlive(_),
    player(Username, _, Attack,_,_, _, _, _, _, _, _),
    enemy(_,_,def,Hp_now,_,_,_,_),
    NeoEnemyHealth is (Hp_now - (Attack - ((0.2)*def))),
    retract(enemy(enemy_name,atk,def, hp_now, hp_max,get_exp,drop)),
    asserta(enemy(enemy_name,atk,def, NeoEnemyHealth, hp_max,get_exp,drop)),
    write(Username), write(' use basic attack !'),nl,
    after_player_atk,
    !.

player_skill :-
    \+ isEnemyAlive(_),
    write('you haven\'t found the enemy'),
    !.

player_skill :-
    \+ isSkill(_),
    write('skill is on cooldown, choose another one !'),nl,
    !.

player_skill :-
    isEnemyAlive(_),
    isSkill(_),
    player(Username,Job,_,dmg_skill,_, _, _, _, _, _, _),
    enemy(_,_,def,Hp_now,_,_,_,_),
    NeoEnemyHealth is (Hp_now - (dmg_skill - ((0.2)*def))),
    retract(enemy(enemy_name,atk,def, hp_now, hp_max,get_exp,drop,atk_skill)),
    asserta(enemy(enemy_name,atk,def, NeoEnemyHealth, hp_max,get_exp,drop,atk_skill)),
    player_skill(Job, Skill_name),
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
    enemy(enemy_name,atk_enemy,_,_,_,_,_),
    player(_, _, _,_, Defense, Hp_now, Hp_max, _, _, _, _),
    NeoHealth is (Hp_now-(atk_enemy-(0.1*Defense))),
    retract(player(Username, Job, Attack,dmg_skill,Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
    asserta(player(Username, Job, Attack, dmg_skill,Defense, NeoHealth, Hp_max, Exp_now, Exp_next, Level, Money)),
    write(enemy_name), write(' use basic attack !'), nl,
    after_enemy_atk,
    !.

enemy_skill :-
    \+ isEnemySkill(_),
    enemy_atk.

enemy_skill :-
    enemy(enemy_name,atk_enemy,_,_,_,_,atk_skill),
    player(_, _, _,_, Defense, Hp_now, Hp_max, _, _, _, _),
    NeoHealth is (Hp_now - (atk_skill-(0.1*Defense))),
    retract(player(Username, Job, Attack, dmg_skill,Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
    asserta(player(Username, Job, Attack, dmg_skill,Defense, NeoHealth, Hp_max, Exp_now, Exp_next, Level, Money)),
    enemy_skill(enemy_name, X,_),
    write(enemy_name), write(' use '), write(X), write('!!!'), nl,
    retract(isEnemySkill(_)),
    after_enemy_atk,
    !.


