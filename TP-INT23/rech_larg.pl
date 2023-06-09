/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog      */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE     */

/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog      */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE     */


/* Nom du binome :    JI Zihe - LUO Yijie     										 */
/*           (TODO : remplacez Nom1 et Nom2 par vos noms dans l'ordre alphabétique) */

/*****************************************************************************
*					          PARTIE 4
*
* L'algorithme de recherche en profondeur s'implémente tres facilement en Prolog
* car la stratégie de preuve mise en oeuvre par le démonstrateur de Prolog
* suit elle même une stratégie en profondeur.
* 
* Le codage de l'algorithme de recherche en largeur est un peu moins direct
* car on a besoin de pouvoir connaitre tous les successeurs d'un état.
*
* Pour cela il existe un prédicat prédéfini en prolog, qui permet de trouver
* toutes les solutions d'un but. Ce prédicat s'appelle findall/3.
*
******************************************************************************/


/*****************************************************************************
1) lisez la documentation de ce prédicat en tapant help(findall/3)
     et testez le sur des exemples simples pour bien comprendre comment
     fonctionne ce prédicat.

* findall(+Template, :Goal, -Bag)                                        [ISO]
*   Create  a  list  of  the  instantiations  Template gets  successively on
*   backtracking over Goal and unify the result with  Bag. Succeeds  with an
*   empty list if Goal has no solutions.
*
*   findall/3 is equivalent to bagof/3 with all free variables  appearing in
*   Goal scoped to the Goal with an existential (caret) operator (^), except
*   that bagof/3 fails when Goal has no solutions.

* examples:
* ?- findall(X, (between(1, 10, X), X mod 2 =:= 1), List).
* List = [1, 3, 5, 7, 9].
* 
* likes(john, pizza).
* likes(john, pasta).
* likes(jane, sushi).
* likes(jane, pizza).
* 
* ?- findall(X, likes(john, X), List).
* List = [pizza, pasta].
* 
* ?- findall(X, likes(jane, X), List).
* List = [sushi, pizza].
* 
* ?- findall(X, likes(_, X), List).
* List = [pizza, pasta, sushi, pizza].
* 
******************************************************************************/


/*****************************************************************************
* 2) Pour connaître les tous les succeseurs d'un état E il suffira alors 
* d'utiliser :
*      	...
*       findall(NE, operateur(OP,E,NE), Successeurs)
*       ....
*
* > vérifiez cela manuellement sur quelques états des cruches et/ou du taquin
* > nb : à la place de NE, vous pouvez aussi mettre n'importe quel terme qui contient NE.

* example:
* swipl cruches.pl
* Etat = ec(1, 3),
* findall(NE, operateur(_, Etat, NE), Successeurs),
* write('Successeurs de '), write(Etat), write(': '), write(Successeurs), nl.
* 
******************************************************************************/


/*****************************************************************************
* 3) Le codage de l'algorithme de recherche en profondeur nécessite alors
* de construire le graphe de recherche et sa frontière.
* une façon simple de représenter la structure de ce graphe est de 
* représenter chaque noeud par une structure de la forme : 
*
*      nd(E, Pere) 
* 
* où - E est l'état associé au noeud
*    - Pere est le noeud parent de ce noeud (ou nil si le noeud correspond à l'état initial)
* 
* On peut alors représenter la frontière simplement par une liste de noeuds.
* mais pour garantir que l'exploration s'effectue bien en largeur il faudra bien
* veiller à développer à chaque étape, le noeud le plus ancien parmi ceux de la frontière
* (attention à la façon dont vous rajoutez des noeuds à la frontière).
******************************************************************************/
 
 
 
 
 
 
/*****************************************************************************
* Definir le prédicat :
* rech_larg(+E,-Sol,-NNA,-NND) 
*		qui construit un chemin solution Sol depuis l'état E, en construisant le graphe
*        de recherche suivant une stratégie en largeur d'abord.
*		-NNA,-NND sont des entiers correspondants respectivement au nombre de noeuds
*		 apparus et développés 
*
* nb : Vous aurez besoin de définir 
*		- une procédure auxiliaire, qui explicite la frontière du graphe et les états déjà
*		- developpés et effectue la recherche
*		- une procédure auxiliaire qui reconstruit le chemin solution lorsqu'un état but a été atteint.
******************************************************************************/

enqueue(Element, Queue, NewQueue) :-
    append(Queue, [Element], NewQueue).

/*
 * construire_chemin(Nd, Chemin, Sol)
 * Nd est le noeud actuel, definie par la structure:
 *    Nd = nd(Elem, NdPere)
 * Chemin est une liste qui represente le chemin actuel, devant ce Nd
 * Sol est le chemin fianl, quand le Nd arrive a la racine nil
 */

construire_chemin(nil, Sol, Sol).
construire_chemin(nd(E, Pere), Chemin, Sol) :-
    construire_chemin(Pere, [E | Chemin], Sol).

/* 
 * ajouter_visite(Nd, Visite, NouvelleVisite)
 * Nd est le noeud actuel, ce qui reste a verifier s'il est deja visite.
 * Si Nd est deja visite (cas 2), on le neglige. Sinon on l'ajoute dans la nouvelle liste (cas 3)
 * Puis on supprime le premier noeud, et on continue a voir les autres Nd
 */
ajouter_visite(E, [], [E]).
ajouter_visite(E, [nd(E, _) | Reste], NouvellesVisites) :-
    ajouter_visite(E, Reste, NouvellesVisites).
ajouter_visite(E, [Nd | Reste], [Nd | NouvellesVisites]) :-
    ajouter_visite(E, Reste, NouvellesVisites).

/* ajouter_successeurs(Successeurs, Frontiere, NouvelleFrontiere)
 * 
 */
ajouter_successeurs([], Frontiere, Frontiere).
ajouter_successeurs([Successeur | Reste], Frontiere, NouvelleFrontiere) :-
    enqueue(Successeur, Frontiere, TmpFrontiere),
    ajouter_successeurs(Reste, TmpFrontiere, NouvelleFrontiere).

/* rech_larg_aux(Frontiere, Visite, Sol, NNA, NND)
 *
 *
 * NNA est le nombre des noeuds, contenant les noeuds visites et les noeuds a visiter.
 * NND le nombre des noeuds a visiter.
 */
rech_larg_aux([], _, _, 0, 0). % Pas de solution
rech_larg_aux([nd(E, Pere)|_], _, Sol, NNA, NND):- % E est le but
    but(E),
    construire_chemin(Pere, [], TmpSol),
    enqueue(E, TmpSol, Sol),
    length([nd(_, _)|_], NNA),
    length(_, NND).
rech_larg_aux([nd(E, Pere) | ResteFrontiere], Visites, Sol, NNA, NND) :- 
    findall(nd(NE, nd(E, Pere)), operateur(_, E, NE), Successeurs), 
    ajouter_successeurs(Successeurs, ResteFrontiere, NouvelleFrontiere), 
    ajouter_visite(E, Visites, NouvellesVisites), 
    rech_larg_aux(NouvelleFrontiere, NouvellesVisites, Sol, NNA1, NND1), 
    NNA is NNA1 + 1, 
    NND is NND1 + 1.


/*** TEST ***
*
* swipl cruches.pl
* `rech_larg.pl`.
* rech_larg(ec(0, 0), Sol, NNA, NND).
* Sol = [ec(0, 0), ec(0, 7), ec(5, 2), ec(0, 2), ec(2, 0), ec(2, 7), ec(5, 4)],
NNA = 262,
NND = 261
*
*
************/