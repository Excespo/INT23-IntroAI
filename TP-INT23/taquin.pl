/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog      */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE     */

/* Nom du binome :    NOM1 - NOM2     										 */
/*           (TODO : remplacez Nom1 et Nom2 par vos noms dans l'ordre alphabétique) */

/*****************************************************************************
 			    Introduction à l'Intelligence Artificielle					 
					ENSTA 1ère année - Cours INT23
*****************************************************************************/

/*****************************************************************************
* On considère le domaine de problème correspondant au jeu du taquin sur une
* grille de taille 4x4 et on décide de représenter un état par une structure 
* de la forme :
*  
*     et( A, B, C, D
*		  E, F, G, H
*		  I, J, K, L,
*		  M, N, O, P,
*		  CV
*		 )
*
* tel que : 
* - A,...,P représentent respectivement les contenus des 
*   différentes cases de la grille du taquin, lorsqu'elle est 
*	parcourue de haut en bas et de gauche à droite.
*   ils correspondent à des entiers tous différentes allant de 0 à 15 
*   (où 0 représente la case vide) 
*
* - CV représente le numéro de l'argument correspondant à la case vide 
*
* Exemple :  la grille suivante :
*
*				1   2   3   4  
*				5   6   7   8  
*				9  10  11  12  
*			   13  14  15   0  
*
*     sera représentée par le terme 
*		et(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,16)
*		car la position de la case vide correspond au 16e argument de la structure.
*
*  NB1  : l'information représentée par CV est redondante, mais elle évite d'avoir 
*         à parcourir la structure pour retrouver la position de la case vide
*
*  NB2  : cette représentation n'est pas optimale en terme d'espace
*		 On pourait par exemple représenter
*        la grille par un simple entier sur 64bits (4*16)	
* 		 mais elle est déjà plus économique qu'une simple liste de 16 entiers.		
*******************************************************************************/

/*****************************************************************************
 cons_etat_taquin(?Liste, ?EtatTaquin) est vrai 
				construit un  ?EtatTaquin à partir d'une grille 
				représentée par une simple liste dont les cases sont parcourues
				de gauche à droite  et de haut en bas (et inversement)
				
				mode d'appel (+,?) ou (?,+) 
				Ne vérifie pas que les cases sont bien remplies par des
				entiers entre 0 et 15
******************************************************************************/
cons_etat_taquin(Matrice, EtatTaquin) :-
		     Matrice = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P],
		     EtatTaquin =.. [et,A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P,CV],
			 arg(CV,EtatTaquin,0).

/* tests
cons_etat_taquin([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0],E).
cons_etat_taquin([0,2,3,4,5,6,7,8,9,10,11,12,13,14,15,1],E).
cons_etat_taquin([10,2,3,4,5,6,7,8,9,0,11,12,13,14,15,1],E).

cons_etat_taquin(M,et(0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1, 1)).

*/ 



/*****************************************************************************
* operateur(?Nom,?Etat,?NEtat) qui est vrai si et seulement si Nom est le nom
*							  d'un opérateur pour le problème du taquin
*							  applicable et permettant de faire passer d'un état
*							  Etat à un nouvel état NEtat.
******************************************************************************/
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]) :-
    I > 1,
    NewI is I - 1,
    replace(T, NewI, X, R).

operateur('up', Etat, NEtat) :-
	Etat = et(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, CV),
	Matrice = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P],
    CV > 4, 
    NewCV is CV - 4,
    nth1(NewCV, Matrice, Val),
    replace(Matrice, NewCV, 0, NewMatrice1),
	replace(NewMatrice1, CV, Val, NewMatrice2),
	cons_etat_taquin(NewMatrice2, NEtat).

operateur('down', Etat, NEtat) :-
    Etat = et(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, CV),
	Matrice = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P],
    CV < 13, 
    NewCV is CV + 4,
    cons_etat_taquin(Matrice, Etat),
    nth1(NewCV, Matrice, Val),
    replace(Matrice, NewCV, 0, NewMatrice1),
	replace(NewMatrice1, CV, Val, NewMatrice2),
	cons_etat_taquin(NewMatrice2, NEtat).

operateur('left', Etat, NEtat) :-
    Etat = et(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, CV),
	Matrice = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P],
    CV mod 4 =\= 1, 
    NewCV is CV - 1,
    cons_etat_taquin(Matrice, Etat),
    nth1(NewCV, Matrice, Val),
    replace(Matrice, NewCV, 0, NewMatrice1),
	replace(NewMatrice1, CV, Val, NewMatrice2),
	cons_etat_taquin(NewMatrice2, NEtat).

operateur('right', Etat, NEtat) :-
    Etat = et(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, CV),
	Matrice = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P],
    CV mod 4 =\= 0, 
    NewCV is CV + 1,
    cons_etat_taquin(Matrice, Etat),
    nth1(NewCV, Matrice, Val),
    replace(Matrice, NewCV, 0, NewMatrice1),
	replace(NewMatrice1, CV, Val, NewMatrice2),
	cons_etat_taquin(NewMatrice2, NEtat).



/*****************************************************************************
* but(Etat)	  qui est vrai si et seulement si Etat est un état but pour 
*              le problème du taquin.
******************************************************************************/
but(et(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,16)).





/*****************************************************************************
*Avertissement : 
* pour tester vos algorithmes sur le problème du taquin, devez faire attention
* au fait que l'espace d'état est composé de deux parties non connectées.
* Si vous choisissez un état au hasard... il est possible qu'il ne figure pas 
* dans la même composante connexe que votre but... et dans ce cas le problème
* n'aura pas de solution.
*
* Suggestion : implémentez une relation qui à partir de l'état correspondant
* a votre but, applique au hasard des opérateurs un certain nombre de fois
* pour obtenir un état qui se trouve forcément dans la même composantte connexe 
* que votre but.
* 
******************************************************************************/

% On applique des opérateurs au hasard
init_etat(Etat, Steps) :-
	but(But),
	init_etat_aux(But, Steps, Etat).

init_etat_aux(Etat, 0, Etat).
init_etat_aux(Etat, Steps, FinalEtat) :-
    Steps > 0,
	operateurs_valides(Etat, Operators),
    random_member(Op, Operators),
    operateur(Op, Etat, NEtat),
    NewSteps is Steps - 1,
    init_etat_aux(NEtat, NewSteps, FinalEtat).


% 'up' : CV > 4
% 'down' : CV < 13
% 'left' : CV mod 4 =\= 1
% 'right' : CV mod 4 =\= 0
% donner tous les operateurs valides pour un etat
operateurs_valides(Etat, Operators3) :-
	arg(17, Etat, CV),
	( CV > 4 -> Operators = ['up'] ; Operators = []),
	( CV < 13 -> append(Operators, ['down'], Operators1) ; Operators1 = Operators),
	( CV mod 4 =\= 1 -> append(Operators1, ['left'], Operators2) ; Operators2 = Operators1),
	( CV mod 4 =\= 0 -> append(Operators2, ['right'], Operators3) ; Operators3 = Operators2).


/* evalution heuristique */
% h1 : nombre de pièces mal placées
eval_heuristique(h1, Etat, Cout_H) :-
	et(A1, B1, C1, D1, E1, F1, G1, H1, I1, J1, K1, L1, M1, N1, O1, P1, _) = et(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,16),
	Etat = et(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, _),
    dif(A, A1, D1),
    dif(B, B1, D2),
    dif(C, C1, D3),
    dif(D, D1, D4),
    dif(E, E1, D5),
    dif(F, F1, D6),
    dif(G, G1, D7),
    dif(H, H1, D8),
    dif(I, I1, D9),
    dif(J, J1, D10),
    dif(K, K1, D11),
    dif(L, L1, D12),
    dif(M, M1, D13),
    dif(N, N1, D14),
    dif(O, O1, D15),
    dif(P, P1, D16),
    Cout_H is D1 + D2 + D3 + D4 + D5 + D6 + D7 + D8 + D9 + D10 + D11 + D12 + D13 + D14 + D15 + D16.

dif(X, X, 0) :- 
	!.
dif(_, _, 1).

/* test

but(B), eval_heuristique(h1, B, H).

eval_heuristique(h1, et(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,16), H).

*/