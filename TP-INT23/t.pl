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

/*** TEST ***/
test1:-
    construire_chemin(nd(e, nd(d, nd(c, nil))), [f], Sol),
    write("Chemin de nd(e, nd(d, nd(c, nil)) est: "), write(Sol), nl.

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

/*** TEST ***/
test2 :-
    ajouter_visite(1, [], NouvellesVisites1),
    write('Nouvelles Visites 1: '), write(NouvellesVisites1), nl,

    ajouter_visite(1, [nd(1, nil)], NouvellesVisites2),
    write('Nouvelles Visites 2: '), write(NouvellesVisites2), nl,

    ajouter_visite(2, [nd(1, nil)], NouvellesVisites3),
    write('Nouvelles Visites 3: '), write(NouvellesVisites3), nl.

/* ajouter_successeurs(Successeurs, )
 *
 *
 */

enqueue(Element, Queue, NewQueue) :-
    append(Queue, [Element], NewQueue).

ajouter_successeurs([], Frontiere, Frontiere).
ajouter_successeurs([Successeur | Reste], Frontiere, NouvelleFrontiere) :-
    enqueue(Successeur, Frontiere, TmpFrontiere),
    /*write("Before enqueue: "), write(Frontiere), nl, write("After enqueue: "), write(TmpFrontiere), nl,*/
    ajouter_successeurs(Reste, TmpFrontiere, NouvelleFrontiere).

/*** TEST ***/
test3:-
    ajouter_successeurs([nd(1, nil), nd(2, nd(1, nil))], [nd(1, nil), nd(3, nd(1, nil))], NouvelleFrontiere),
    write('Nouvelle Frontiere: '), write(NouvelleFrontiere), nl.

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
/*
rech_larg_aux([nd(E, Pere) | ResteFrontiere], Visites, Sol, NNA, NND) :- 
    sleep(1),
    write("Got nd("), write(E), write(Pere), write("), Reste:"), write(ResteFrontiere),
    write(", Got Visites: "), write(Visites), nl,
    findall(nd(NE, nd(E, Pere)), operateur(_, E, NE), Successeurs), 
    write("Got succ: "), write(Successeurs), nl,
    ajouter_successeurs(Successeurs, ResteFrontiere, NouvelleFrontiere), 
    write("Got Nouv Frontiere: "), write(NouvelleFrontiere),
    ajouter_visite(E, Visites, NouvellesVisites), 
    write(", Got Nouv Visites: "), write(NouvellesVisites), nl,
    rech_larg_aux(NouvelleFrontiere, NouvellesVisites, Sol, NNA1, NND1), 
    NNA is NNA1 + 1, 
    NND is NND1 + 1.
*/

rech_larg_aux([nd(E, Pere) | ResteFrontiere], Visites, Sol, NNA, NND) :- 
    findall(nd(NE, nd(E, Pere)), operateur(_, E, NE), Successeurs), 
    ajouter_successeurs(Successeurs, ResteFrontiere, NouvelleFrontiere), 
    ajouter_visite(E, Visites, NouvellesVisites), 
    rech_larg_aux(NouvelleFrontiere, NouvellesVisites, Sol, NNA1, NND1), 
    NNA is NNA1 + 1, 
    NND is NND1 + 1.


capacite(5, 7).
cons_etat_cruche(P, G, Etat) :- 
	capacite(Pmax, Gmax),
	Etat = etat(P, G),
	P >= 0, 
	P =< Pmax,
	G >= 0, 
	G =< Gmax.
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
	NEtat = etat(P1, G1),
	min(P+G, Pmax, P1),
	max(P+G-Pmax, 0, G1).
operateur('PtoG', Etat, NEtat) :-
	capacite(_, Gmax),
	cons_etat_cruche(P, G, Etat),
	P > 0, 
	G < Gmax,
	NEtat = etat(P1, G1),
	max(0, P+G-Gmax, P1),
	min(P+G, Gmax, G1).
operateur('viderG', Etat, NEtat) :-
	cons_etat_cruche(P, G, Etat),
	G > 0,
	NEtat = etat(P1, G1),
	P1 is P,
	G1 is 0.
operateur('viderP', Etat, NEtat) :-
	cons_etat_cruche(P, G, Etat),
	P > 0,
	NEtat = etat(P1, G1),
	P1 is 0,
	G1 is G.
operateur('remplirG', Etat, NEtat) :-
	capacite(_, Gmax),
	cons_etat_cruche(P, G, Etat),
	G < Gmax,
	NEtat = etat(P1, G1),
	P1 is P,
	G1 is Gmax.
operateur('remplirP', Etat, NEtat) :-
	capacite(Pmax, _),
	cons_etat_cruche(P, G, Etat),
	P < Pmax,
	NEtat = etat(P1, G1),
	P1 is Pmax,
	G1 is G.

init_etat(etat(0, 0)).
but(etat(4, _)).
but(etat(_, 4)).
init_frontiere(E, nd(E, nil)).
init_frontiere(Frontiere, Visites, Frontiere) :-
    \+ memberchk(nd(_, _), Visites).
init_frontiere([nd(E, Pere) | ResteFrontiere], Visites, Frontiere) :-
    memberchk(nd(E, Pere), Visites),
    init_frontiere(ResteFrontiere, Visites, Frontiere).

test(Sol, NNA, NND) :-
    init_etat(E),
    init_frontiere([nd(E, nil)], [], Frontiere),
    write("Search..."), nl,
    rech_larg_aux(Frontiere, [], Sol, NNA, NND).