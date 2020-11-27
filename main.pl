:- include('map.pl'). 
:- include('player.pl').

/* Main control */
start :-
    retractall(player(_, _, _, _, _, _, _, _, _, _)),
    write('Welcome to This Game!'), nl,
    write('1. Load save file'), nl,
    write('2. New Game'), nl,
    write('> '),
    read(Pil),
    (
        Pil =:= 1 ->
            load;
        Pil =:= 2 ->
            write('What is your name, Adventurer? : '),
            read(Username),
            asserta(player(Username, _, _ , _, _, _, _, _, _, _)), initJob(Username), nl
    ), write('Use command \'help\' to display all available commands'), nl, nl, write('Map:'), nl, initmap, map, infomap.

/* Quit */
quit :-
    write('Thank you playing this game!'), nl,
    write('Do you want to save current stat? (y/n) : '),
    read(Pil),
    (
        Pil = 'y' -> 
            write('Give a name to the save file: '),
            read(SaveFileName),
            atom_concat(SaveFileName, '.txt', SaveFileName2),
            open(SaveFileName2, write, Stream),
            player(Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money),
            statePlayer(State),
            write(Stream, [Username, Job, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money, State]), write(Stream, '.'),
            nl(Stream),
            playerCoor(X_player, Y_player), 
            write(Stream, [X_player, Y_player]), write(Stream, '.'),
            nl(Stream),
            questCoor(X_Quest, Y_Quest),
            write(Stream, [X_Quest, Y_Quest]), write(Stream, '.'),
            nl(Stream),
            storeCoor(X_Shop, Y_Shop),
            write(Stream, [X_Shop, Y_Shop]), write(Stream, '.'),
            nl(Stream),
            inventoryPlayer(ListWeapon, ListArmor, ListAcc, ListSpell),
            write(Stream, [ListWeapon, ListArmor, ListAcc, ListSpell]), write(Stream, '.'),
            nl(Stream),
            currentEquip(Player_weapon, Player_armor, Player_Acc),
            write(Stream, [Player_weapon, Player_armor, Player_Acc]), write(Stream, '.'),
            close(Stream), write('Current stat has already saved!'),nl, write('See you next time!'), nl,!;
        Pil = 'n' ->
            write('See you next time!'), nl, !
    ).
    /*halt(0). */

/* load save file */
/* Asumsikan file sudah ada */
load :- 
    write('Save Files in Current Directory: '), nl,
    directory_files('./save_files', Files),
    Files = [_, _|Files2],
    wrtList(Files2, 1), nl, 
    write('Input the save file name (use apostrophe symbol at first and end of file names): '), nl,
    Basedir = './save_files/',
    read(SaveFileName),
    atom_concat(Basedir , SaveFileName , SaveFileName2),
    write(SaveFileName2), nl,
    open(SaveFileName2, read, Stream),
    \+ at_end_of_stream(Stream),
    read(Stream, X),
    /* Inisialisasi Job */
    X = [Username, Job_name, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money, State|_],
    asserta(player(Username, Job_name, Attack, Dmg_skill, Defense, Hp_now, Hp_max, Exp_now, Exp_next, Level, Money)),
    asserta(statePlayer(State)),
    /*Insialisasi Posisi Pemain */
    read(Stream, PosPemain),
    elmt(PosPemain, 1, X_player), elmt(PosPemain, 2, Y_player),
    asserta(playerCoor(X_player, Y_player)),
    /* Inisialisasi Posisi Quest */
    read(Stream, PosQuest),
    elmt(PosQuest, 1, X_Quest), elmt(PosQuest, 2, Y_Quest),
    asserta(questCoor(X_Quest, Y_Quest)),
    /* Inisialisasi Posisi Shop */
    read(Stream, PosShop),
    elmt(PosShop, 1, X_Shop), elmt(PosShop, 2, Y_Shop),
    asserta(storeCoor(X_Shop, Y_Shop)),
    /*Inisialisasi Inventory Pemain */
    read(Stream, InventoryPlayerF),
    elmt(InventoryPlayerF, 1, ListWeapon), elmt(InventoryPlayerF, 2, ListArmor),
    elmt(InventoryPlayerF, 3, ListAcc), elmt(InventoryPlayerF, 4, ListSpell),
    asserta(inventoryPlayer(ListWeapon, ListArmor, ListAcc, ListSpell)),
    /*Inisialisasi Equipment */
    read(Stream, CurrEquip),
    elmt(CurrEquip, 1, Player_weapon), elmt(CurrEquip, 2, Player_armor),
    elmt(CurrEquip, 3, Player_Acc),
    asserta(currentEquip(Player_weapon, Player_armor, Player_Acc)),
    close(Stream), write('File berhasil di load!'), nl, !.
    /*
    at_end_of_stream(Stream).*/