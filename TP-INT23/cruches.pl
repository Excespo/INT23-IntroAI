/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog       */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE                            */

/* Nom du binome :    JI Zihe - LUO Yijie     										 */
/*           (TODO : remplacez Nom1 et Nom2 par vos noms dans l'ordre alphabétique) */

/*****************************************************************************
*              Modélisation du domaine du problème des cruches
******************************************************************************/
% Capacite des cruches P et G
capacite(5, 7).

/*****************************************************************************
* Question 0 :  
*
* Proposer une structure permettant de représenter un état pour le problème
* des cruches (nb il n'y a pas de relation à définir - décrire juste la
* structure que vous comptez utiliser, en précisant le sens de chaque argument)
*
* Réponse : 
*       on represente un état par un terme de la forme ec(P, G)
* où
*       P : contenu de la petite cruche P, entier entre 0 et Pmax
*       G : contenu de la grande cruche G, entier entre 0 et Gmax
*
*			opérateurs | préconditions     | effets 
*				G -> P | g > 0 && p < Pmax | (p,g) <-- (min(p+g, Pmax), max(0, p+g-Pmax))
*				P -> G | p > 0 && g < Gmax | (p,g) <-- (max(0, p+g-Gmax), min(p+g, Gmax))
*				G -> F | g > 0             | (p,g) <-- (p, 0)
*				P -> F | p > 0             | (p,g) <-- (0, g)
*				F -> G | g < Gmax          | (p,g) <-- (p, Gmax)
*				F -> P | p < Pmax          | (p,g) <-- (Pmax, g)
* où... 
*         P : contenu de la petite cruche P
*         G : contenu de la grande cruche G
*		  F : fontaine
*         Pmax : capacité de la petite cruche P
*         Gmax : capacité de la grande cruche G
* où... 
*         G->P : verser le contenu de la cruche G dans la cruche P
*         P->G : verser le contenu de la cruche P dans la cruche G
*         G->F : vider la cruche G
*         P->F : vider la cruche P
*         F->G : remplir la cruche G
*         F->P : remplir la cruche P 
******************************************************************************/



/*****************************************************************************
* Question 1 : Définir un prédicat constructeur/accesseur, permettant de faire
* abstraction de la structure que vous avez choisie (et d'automatiser les test)

* cons_etat_cruche(?P, ?G, ?Etat)  
	qui est vrai si et seulement si Etat correspond au terme
	modélisant un état du domaine des cruches dans lequel 
	- le contenu de la petite cruche est P
	- le contenu de la grande cruche est G
******************************************************************************/


cons_etat_cruche(P, G, Etat) :- 
	capacite(Pmax, Gmax),
	Etat = ec(P, G),
	P >= 0, 
	P =< Pmax,
	G >= 0, 
	G =< Gmax.


/*****************************************************************************
* Question 2 : Ecrire le code du prédicat :

* etat_cruche(?Terme)  qui est vrai si et seulement si Terme est un terme prolog
*                      qui représente bien un état pour le problème des cruches.
******************************************************************************/




/*****************************************************************************
* Question 3 : Définir un prédicat :

* operateur(?Nom,?Etat,?NEtat)
					qui est vrai si et seulement si Nom est le nom d'un opérateur 
*					applicable pour le problème des cruches, permettant de  
					passer d'un état Etat à un successeur état NEtat.
******************************************************************************/
min(X, Y, P) :- 
	X =< Y, 
	P is X, 
	!.
min(X, Y, P) :- 
	X > Y, 
	P is Y, 
	!.

max(X, Y, P) :- 
	X >= Y, 
	P is X, 
	!.
max(X, Y, P) :- 
	X < Y, 
	P is Y, 
	!.

operateur('GtoP', Etat, NEtat) :- 
	capacite(Pmax, _),
	cons_etat_cruche(P, G, Etat),
	G > 0, 
	P < Pmax,
	NEtat = ec(P1, G1),
	min(P+G, Pmax, P1),
	max(P+G-Pmax, 0, G1).

operateur('PtoG', Etat, NEtat) :-
	capacite(_, Gmax),
	cons_etat_cruche(P, G, Etat),
	P > 0, 
	G < Gmax,
	NEtat = ec(P1, G1),
	max(0, P+G-Gmax, P1),
	min(P+G, Gmax, G1).

operateur('viderG', Etat, NEtat) :-
	cons_etat_cruche(P, G, Etat),
	G > 0,
	NEtat = ec(P1, G1),
	P1 is P,
	G1 is 0.

operateur('viderP', Etat, NEtat) :-
	cons_etat_cruche(P, G, Etat),
	P > 0,
	NEtat = ec(P1, G1),
	P1 is 0,
	G1 is G.

operateur('remplirG', Etat, NEtat) :-
	capacite(_, Gmax),
	cons_etat_cruche(P, G, Etat),
	G < Gmax,
	NEtat = ec(P1, G1),
	P1 is P,
	G1 is Gmax.

operateur('remplirP', Etat, NEtat) :-
	capacite(Pmax, _),
	cons_etat_cruche(P, G, Etat),
	P < Pmax,
	NEtat = ec(P1, G1),
	P1 is Pmax,
	G1 is G.



/*****************************************************************************
* Question 4 : Définir le prédicat : 
* but(?Etat)   qui est vrai si et seulement si Etat est un état but pour 
*              le problème des cruches.
******************************************************************************/
but(Etat) :- 
	cons_etat_cruche(P, _, Etat),
	P is 4.

but(Etat) :- 
	cons_etat_cruche(_, G, Etat),
	G is 4.





