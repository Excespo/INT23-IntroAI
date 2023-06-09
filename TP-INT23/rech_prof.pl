/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog      */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE     */


/* Nom du binome :    JI Zihe - LUO Yijie     										 */
/*           (TODO : remplacez Nom1 et Nom2 par vos noms dans l'ordre alphabétique) */


/*****************************************************************************
* On suppose que l'on dispose d'un domaine de problème, caractérisé par 
*
*  - une relation operateur/3
*  - une relation but/1
*
* On souhaite coder un algorithme de recherche de chemin solution de faisant 
* aucune autre hypothèse que celle de la modélisation du domaine du problème
* a l'aide des relations précédentes.
*
* Définir les relations suivantes : 
******************************************************************************/




/*****************************************************************************
* rprof(+Etat,-Solution)	 qui est vrai si et seulement si Solution est une suite
*					         d'états caractérisant un chemin solution depuis Etat
*						     vers un état du But.
******************************************************************************/
rprof(Etat, [Etat]) :- but(Etat).
rprof(Etat, [Etat|Solution]) :-
    operateur(_, Etat, NEtat),
    rprof(NEtat, Solution).




/*****************************************************************************
* rprof_ss_cycle(+Etat,-Solution)	  qui est vrai si et seulement si Solution est 
*			une suite d'états sans cycle, caractérisant un chemin solution depuis
*			Etat vers un état du But.
******************************************************************************/
rprof_ss_cycle(Etat, [Etat]) :- but(Etat).
rprof_ss_cycle(Etat, [Etat|Solution]) :-
    operateur(_, Etat, NEtat),
    \+ member(NEtat, Solution),
    rprof_ss_cycle(NEtat, Solution).





/*****************************************************************************
* Une nouvelle version de ce prédicat permettant limiter
* la profondeur de recherche.
*  
* rprof_bornee(+Etat,-Solution,+ProfMax)
*     qui est vrai si et seulement si Solution est une suite d'au plus ProfMax
*	  états caractérisant un chemin solution depuis Etat vers un état du But.
******************************************************************************/
rprof_bornee(Etat, Solution, ProfMax, Visited) :- rprof_bornee_aux(Etat, Solution, ProfMax, 0, Visited).

rprof_bornee_aux(Etat, [Etat], _, _, _) :- but(Etat).
rprof_bornee_aux(Etat, [Etat|Etats], ProfMax, ProfActuelle, Visited) :-
    ProfActuelle < ProfMax,
    operateur(_, Etat, NEtat),
    \+ member(NEtat, Visited), 
    NewProf is ProfActuelle + 1,
    rprof_bornee_aux(NEtat, Etats, ProfMax, NewProf, [NEtat|Visited]).



/*****************************************************************************
* rprof_incr(+Etat,-Solution,+ProfMax)
*     qui est vrai si et seulement si Solution est une suite d'au plus ProfMax
*	  états caractérisant recherchée suivant une stratégie de recherche itérative
*     à profondeur incrémentale.
******************************************************************************/
rprof_incr(Etat, Solution, ProfMax) :- 
    between(0, ProfMax, Prof),
    rprof_bornee(Etat, Solution, Prof, []).
    
/*****************************************************************************
* rprof_ops(+Solution, -Ops)
*     Savoir tous les operateurs qui mènent à la solution
******************************************************************************/
rprof_ops([_], []).
rprof_ops([Etat1, Etat2|Etats], [Op|Ops]) :-
    operateur(Op, Etat1, Etat2),
    rprof_ops([Etat2|Etats], Ops).

/****************************  Test sur cruches  *******************************
* ?- rprof_incr(ec(0,0),S,10), rprof_ops(S,Ops).
* S = [ec(0, 0), ec(0, 7), ec(5, 2), ec(0, 2), ec(2, 0), ec(2, 7), ec(5, 4)],
* Ops = [remplirG, 'GtoP', viderP, 'GtoP', remplirG, 'GtoP'] .
******************************************************************************/

/****************************  Test sur taquin  *******************************
* ?- init_etat(E,50).
* E = et(0, 2, 3, 4, 11, 5, 6, 8, 1, 10, 7, 12, 9, 13, 14, 15, 1) .
*
?- E = et(0, 2, 3, 4, 11, 5, 6, 8, 1, 10, 7, 12, 9, 13, 14, 15, 1), rprof_incr(E, S, 20), rprof_ops(S, Ops), writeln(Ops), writeln(S).
* [right,down,left,down,down,right,up,up,up,left,down,right,right,down,left,down,right,right]
* [et(0,2,3,4,11,5,6,8,1,10,7,12,9,13,14,15,1),
*  et(2,0,3,4,11,5,6,8,1,10,7,12,9,13,14,15,2),
*  et(2,5,3,4,11,0,6,8,1,10,7,12,9,13,14,15,6),
*  et(2,5,3,4,0,11,6,8,1,10,7,12,9,13,14,15,5),
*  et(2,5,3,4,1,11,6,8,0,10,7,12,9,13,14,15,9),
*  et(2,5,3,4,1,11,6,8,9,10,7,12,0,13,14,15,13),
*  et(2,5,3,4,1,11,6,8,9,10,7,12,13,0,14,15,14),
*  et(2,5,3,4,1,11,6,8,9,0,7,12,13,10,14,15,10),
*  et(2,5,3,4,1,0,6,8,9,11,7,12,13,10,14,15,6),
*  et(2,0,3,4,1,5,6,8,9,11,7,12,13,10,14,15,2),
*  et(0,2,3,4,1,5,6,8,9,11,7,12,13,10,14,15,1),
*  et(1,2,3,4,0,5,6,8,9,11,7,12,13,10,14,15,5),
*  et(1,2,3,4,5,0,6,8,9,11,7,12,13,10,14,15,6),
*  et(1,2,3,4,5,6,0,8,9,11,7,12,13,10,14,15,7),
*  et(1,2,3,4,5,6,7,8,9,11,0,12,13,10,14,15,11),
*  et(1,2,3,4,5,6,7,8,9,0,11,12,13,10,14,15,10),
*  et(1,2,3,4,5,6,7,8,9,10,11,12,13,0,14,15,14),
*  et(1,2,3,4,5,6,7,8,9,10,11,12,13,14,0,15,15),
*  et(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,16)]
******************************************************************************/