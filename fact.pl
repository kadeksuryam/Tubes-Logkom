/* Fakta-fakta */

/* Job(job_name, attack, defense, hp_max) */
job(swordsman, 160, 130, 500).
job(archer, 180, 100, 500).
job(sorcerer, 150, 150, 500).

/* Item tiap job */
/* item(job_name, item)  */

/*Senjata */
item(swordsman, saber).
item(swordsman, blade).
item(archer, lightshoot_bow).
item(archer, cross_bow).
item(sorcerer, thorn_staff).
item(sorcerer, deadly_staff).

/*Armor */
item(swordsman, griffin_armor).
item(swordsman, god_armor).
item(archer, luci_robe).
item(archer, diabolus_robe).
item(sorcerer, magic_robe).
item(sorcerer, saphiens_robe).

/*Aksesoris */
item(swordsman, elfin_shield)
item(archer, hawk_headband)
item(sorcerer, pendant_necklace)

/* Skill tiap job*/ 
/* skill(job_name, skill)  */

skill(swordsman,slash).
skill(swordsman,sword_mastery).
skill(archer, owl_eye).
skill(archer, meteor_arrow).
skill(sorcerer,spirit_curse).
skill(sorcerer,deadly_curse).

/* Stat Enemy */
/* enemy(enemy_name, attack, defense, hp_max) */
enemy(slime, 15, 15, 300).
enemy(kobold, 25, 20, 350).
enemy(lamia, 20, 25, 350).
enemy(goblin, 30, 30, 400).
enemy(wyvern, 35, 40, 450).


