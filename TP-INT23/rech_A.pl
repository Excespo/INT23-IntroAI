/* Ce fichier est encodé en UTF-8 et suit la syntaxe du langage Prolog      */
/* Merci de NE PAS MODIFIER LE SYSTEME D'ENCODAGE     */


/*****************************************************************************
* rech_A(+Etat,-Solution,H,NNA,NND)	  qui est vrai si et seulement si Solution est 
*			une suite (sans cycle) d'états, caractérisant un chemin solution depuis
*			Etat vers un état du But, renvoyé par l'algorithme A* en utilisant
* 			la fonction heuristique H. NNA et NND représentent respectivement le `
* 			nombre total de noeuds apparus (i.e. la taille du graphe de recherche)
* 			et le nombre de noeuds développés.
******************************************************************************/

/**************************************************************************
* On représente un noeud par un terme nd(Etat,Cout_F,Cout_G)
* où Etat est l'état du noeud, Cout_F son coût estimé et Cout_G son coût réel.
* On représente une route par un terme route(Etat1,Etat2,Cout)
* où Cout est le coût de la route entre Etat1 et Etat2.
* On représente une solution par une liste d'états.
***************************************************************************/

rech_A(Etat, Solution, H, NNA, NND) :-
    retractall(parent(_, _, _)),
    h(H, Etat, Cout_F),
    boucle([nd(Etat, Cout_F, 0)], Terminal, H, 1, NND),
    calculer_solution(Terminal, [Terminal], Solution),
    findall(E, parent(E, _, _), Liste),
    length(Liste, NNA).

/**************************************************************************
* Cette fonction est la boucle principale de l'algorithme A*
* Queue est la file de priorité des noeuds à développer
* Terminal est l'état terminal
* H est la fonction heuristique
* NND est le nombre de noeuds développés
***************************************************************************/
boucle(Queue, Terminal, H, NND, NND_Final) :-
    dequeue(Queue, nd(Etat, _, Etat_G), TQueue),
    (terminal(Etat) -> 
        Terminal = Etat,
        NND_Final = NND;
        (
            findall(route(Voisin, Cout), operateur(_, Etat, Voisin, Cout), Voisins),
            expand(Voisins, TQueue, NewQueue, H, Etat, Etat_G),
            NND1 is NND + 1,
            boucle(NewQueue, Terminal, H, NND1, NND_Final)
        )
    ).

/**************************************************************************
* Cette fonction développe les noeuds voisins d'un noeud
* On représente la rélation parent par un terme parent(Etat, Parent, Cout)
* On met à jour la base de faits parent si on trouve un meilleur chemin
***************************************************************************/
expand([], Queue, QueueFinal, _, _, _) :-
    QueueFinal = Queue.

expand([route(Voisin, Cout)|Voisins], Queue, QueueFinal, H, Parent, Parent_G) :-
    h(H, Voisin, Cout_H),
    Cout_G is Cout + Parent_G,
    Cout_F is Cout_G + Cout_H,
    enqueue(nd(Voisin, Cout_F, Cout_G), Queue, NewQueue),
    (
        parent(Voisin, Old_Parent, Old_Cout) ->
        (
            Cout_G < Old_Cout ->
            retract(parent(Voisin, Old_Parent, Old_Cout)), 
            assert(parent(Voisin, Parent, Cout_G));
            true
        );
        assert(parent(Voisin, Parent, Cout_G))
    ), 
    expand(Voisins, NewQueue, QueueFinal, H, Parent, Parent_G).

/**************************************************************************
* Cette fonction développe le chemin solution depuis Etat vers un état du But
* en utilisant la base de faits parent
***************************************************************************/
calculer_solution(Etat, SolPartiel, Sol) :-
    (parent(Etat, Parent, _) ->
        calculer_solution(Parent, [Parent|SolPartiel], Sol); 
        Sol = SolPartiel
    ).

/**************************************************************************
* On réalise une file de priorité avec une liste ordonnée
* On ajoute un noeud dans la file de priorité en fonction de son coût estimé
* Pour enqueue, si l'état est déjà dans la file de priorité, 
* on le compare avec le noeud déjà présent et on garde le noeud avec le plus petit coût
***************************************************************************/

enqueue(nd(Etat, Cout_F, Cout_G), Queue, NewQueue) :-
    member(nd(Etat, Old_F, Old_G), Queue) ->
        (Cout_F < Old_F ->
            delete(Queue, nd(Etat, Old_F, Old_G), Queue1),
            enqueue_aux(nd(Etat, Cout_F, Cout_G), Queue1, NewQueue);
            NewQueue = Queue
        );
        enqueue_aux(nd(Etat, Cout_F, Cout_G), Queue, NewQueue).

enqueue_aux(Element, [], [Element]).
enqueue_aux(Element, [Head|Tail], [Element, Head|Tail]) :-
    Element = nd(_, Priority, _),
    Head = nd(_, HeadPriority, _),
    Priority =< HeadPriority.
enqueue_aux(Element, [Head|Tail], [Head|NewTail]) :-
    Element = nd(_, Priority, _),
    Head = nd(_, HeadPriority, _),
    Priority > HeadPriority,
    enqueue(Element, Tail, NewTail).

dequeue([Head|Tail], Head, Tail).

/* Test
* ?- rech_A(a, Solution, h1, NNA, NND).
* Solution = [a, f, h, l, o, m, q],
* NNA = 14,
* NND = 12 .
*/