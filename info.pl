/* Berisi Fakta-fakta dan Informasi tentang game seperti cerita, items, command-2 */

/*========================== START Fakta-fakta ==========================*/

/* =========== START Fakta-fakta Job ============ */
/* Job(job_name, attack, defense, hp_max, list_equip, list_potions) */

job(swordsman, 160, 130, 500).
job(archer, 180, 100, 500).
job(sorcerer, 150, 150, 500).

/* =========== END Fakta-fakta Job ============ */

/* ======= START Fakta-fakta Equipment ============*/
/*Weapon */
/* (tipe, allowed_job namaSenjata, HP, damage) */
equip(weapon, swordsman, saber, 200, 50).
equip(weapon, swordsman, blade, 200, 50).
equip(weapon, archer, lightshoot_bow, 200, 50).
equip(weapon, archer,  cross_bow, 200, 50).
equip(weapon, sorcerer, thorn_staff, 200, 50).
equip(weapon, sorcerer, deadly_staff, 200, 50).

/* Armors */
/* (tipe, namaArmor, HP) */
equip(armor, swordsman, griffin_armor, 200, 0).
equip(armor, swordsman, god_armor, 200, 0).
equip(armor, archer, luci_robe, 200, 0).
equip(armor, archer, diabolus_robe, 200, 0).
equip(armor, sorcerer, magic_robe, 200, 0).
equip(armor, sorcerer, saphiens_robe, 200, 0).

/* Accessories */
equip(accessories, swordsman, elfin_shield, 0, 0).
equip(accessories, archer, hawk_headband, 0, 0).
equip(accessories, sorcerer, pendant_necklace, 0, 0).

/* ========== END Fakta-fakta Equipment ============*/

/* =========== START Fakta-fakta Skills ============ */
/* Skill ? perlu dijabarkan speknya */

/* Skill tiap job*/ 
/* skill(job_name, skill)  */

player_skill(swordsman,sword_mastery,300).
player_skill(archer, meteor_arrow,320).
player_skill(sorcerer,deadly_curse,280).
/* =========== END Fakta-fakta Skills ============ */

/* =========== START Fakta-fakta Enemy ============ */
/* Stat Enemy */
/* enemy(enemy_name, attack, defense, hp_max) */
stat_enemy(slime, 30, 15, 300).
stat_enemy(kobold, 50, 20, 350).
stat_enemy(lamia, 40, 25, 350).
stat_enemy(goblin, 60, 30, 400).
stat_enemy(wyvern, 70, 40, 450).
stat_enemy(boss, 1000, 1000, 3000).

enemy_skill(slime, gloomy, 50).
enemy_skill(kobold, bold, 70).
enemy_skill(lamia, kumiaa, 60).
enemy_skill(goblin, provoke, 80).
enemy_skill(wyvern, lockdown, 90).
enemy_skill(boss, earthquake, 2000).

get_exp(slime,30).
get_exp(kobold,40).
get_exp(lamia,50).
get_exp(goblin,60).
get_exp(wyvern,70).

drop(slime, hp_potion).
drop(kobold, hp_potion).
drop(lamia, def_potion).
drop(goblin, atk_potion).
drop(wyvern, atk_potion).

/* =========== END Fakta-fakta Enemy ============ */

/*========================== END Fakta-fakta ==========================*/



/*========================== START Rule Info ==========================*/

/* Menampilkan cerita dan command-command yang ada */
title :-
    write('Once upon a time in Dome Kingdom'), nl,
    sleep(0.5),
    write('...'), nl,
    sleep(0.5),
    write('Messenger: "King of Battle!, there is a terrible situation"'), nl,
    sleep(0.5),
    write('King of Battle: "Dont worry, tell me what is that?"'), nl,
    sleep(0.5),
    write('Messenger: "I found this letter in the south gate of kingdom"'), nl,
    sleep(1),
    write(' '), nl,
    write('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'), nl,
    write('| Dear King of Battle,                 |'), nl,
    write('| Go to Emod and die with your sister! |'), nl,
    write('|                                 -??? |'), nl,
    write('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'), nl,
    write(' '), nl,
    sleep(1),
    write('King of Battle: "Who the hell is this!?"'), nl,
    sleep(0.5),
    write('King of Battle: "How dare you!?"'), nl,
    sleep(0.5),
    write('King of Battle: "I will go to Emod and find my sister"'), nl,
    sleep(0.5),
    write('...'), nl,
    sleep(0.5),
    write('...'), nl,
    sleep(0.5),
    write('...'), nl,
    sleep(0.5),
    write('Adventurer!, Welcome to Emod, the city of Madness'), nl,
    sleep(0.5),
    write('In order to start your jorney to find your sister'), nl,
    sleep(0.5),
    write('I will show you the available commands'), nl,
    sleep(1),
    help.

help :-
    write('Available commands: '), nl,nl,
    write('start. --> start the game'), nl,
    write('map. --> open the map'), nl,
    write('help. --> open available commands'),nl,
    write('inventory. --> open inventory'),nl,
    write('A. --> move left'),nl,
    write('W. --> move up '),nl,
    write('S. --> move down'),nl,
    write('D. --> move right'),nl,
    write('status. --> open current stat'), nl,
    write('quit. --> quit the game'), nl.

/* Menampilkan Info Item-Item */

/*========================== END Rule Info ==========================*/

