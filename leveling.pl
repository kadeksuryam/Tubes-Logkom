% level_player :- 
%     player(_, _, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now,Exp_next, Level, _),
%     Exp_now >= Exp_next,
%     TempLevel is (Level + 1),
%     TempHP_max is Hp_max + 500,
%     TempAtk is Attack + 30,
%     TempDmg_skill is Dmg_skill + 10,
%     TempDef is Defense + 15,
%     TempExp_next is 2*Exp_next,
%     retract(player(Username, Job, Attack, Dmg_skill,Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
%     asserta(player(Username, Job, TempAtk, TempDmg_skill,TempDef, TempHP_max, TempHP_max, Exp_now, TempExp_next, TempLevel, Money)),
%     write('You have Leveled Up!!!'),nl,
%     level_enemy.


% level_enemy :-
%     enemy(_,Atk,Def, Hp_now, Hp_max, Get_Exp, _, Atk_skill),
%     TempAtk is Atk + 30,
%     TempDef is Def + 30,
%     TempHP_max is Hp_max + 300,
%     TempGet_exp is Get_Exp + 5,
%     TempAtk_skill is Atk + 30,
%     retract(enemy(Enemy_name,Atk,Def, Hp_now, Hp_max, Get_Exp, Drop, Atk_skill)),
%     asserta(enemy(Enemy_name, TempAtk, TempDef, Hp_now, TempHP_max, TempGet_exp, Drop, TempAtk_skill)).
    
