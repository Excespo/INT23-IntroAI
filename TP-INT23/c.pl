rech_larg(E, Sol, NNA, NND) :-
    init_frontiere([nd(E, nil)], [], Frontiere),
    rechercher(Frontiere, [], Sol, NNA, NND).

init_frontiere(Frontiere, Visites, Frontiere) :-
    \+ memberchk(nd(_, _), Visites).
init_frontiere([nd(E, Pere) | ResteFrontiere], Visites, Frontiere) :-
    memberchk(nd(E, Pere), Visites),
    init_frontiere(ResteFrontiere, Visites, Frontiere).

rechercher([], _, _, 0, 0).
rechercher([nd(E, Pere) | _], _, [E | Sol], NNA, NND) :-
    but(E),
    construire_chemin(Pere, [], Sol),
    length([nd(_, _) | _], NNA),
    length(_, NND).
rechercher([nd(E, Pere) | ResteFrontiere], Visites, Sol, NNA, NND) :-
    findall(nd(NE, nd(E, Pere)), operateur(_, E, NE), Successeurs),
    ajouter_successeurs(Successeurs, ResteFrontiere, NouvelleFrontiere),
    ajouter_visite(E, Visites, NouvellesVisites),
    rechercher(NouvelleFrontiere, NouvellesVisites, Sol, NNA1, NND1),
    NNA is NNA1 + 1,
    NND is NND1 + 1.

construire_chemin(nil, Sol, Sol).
construire_chemin(nd(E, Pere), Acc, Sol) :-
    construire_chemin(Pere, [E | Acc], Sol).

ajouter_successeurs([], Frontiere, Frontiere).
ajouter_successeurs([Successeur | Reste], Frontiere, NouvelleFrontiere) :-
    ajouter_successeurs(Reste, [Successeur | Frontiere], NouvelleFrontiere).

ajouter_visite(_, [], []).
ajouter_visite(E, [nd(E, _) | Reste], NouvellesVisites) :-
    ajouter_visite(E, Reste, NouvellesVisites).
ajouter_visite(E, [Nd | Reste], [Nd | NouvellesVisites]) :-
    ajouter_visite(E, Reste, NouvellesVisites).

/* 定义操作符 */
operateur(remplir(Bouteille), etat(_, Y), etat(Bouteille, Y)) :- Bouteille \= 5.
operateur(remplir(Bouteille), etat(X, _), etat(X, Bouteille)) :- Bouteille \= 8.
operateur(vider(Bouteille), etat(_, Y), etat(Bouteille, Y)) :- Bouteille \= 0.
operateur(vider(Bouteille), etat(X, _), etat(X, Bouteille)) :- Bouteille \= 0.
operateur(transvaser(Source, Destination), etat(X, Y), etat(X2, Y2)) :-
    X + Y >= Destination,
    X2 is max(X - (Destination - Y), 0),
    Y2 is min(X + Y, Destination),
    X2 \= X,
    Y2 \= Y.

/* 定义目标状态 */
but(etat(4, _)).

/* 测试 rech_larg/4 */
test_rech_larg(Sol, NNA, NND) :-
    rech_larg(etat(0, 0), Sol, NNA, NND).

/* 运行测试 */
:- test_rech_larg(Sol, NNA, NND),
   write('Solution: '), write(Sol), nl,
   write('Generated Nodes: '), write(NNA), nl,
   write('Expanded Nodes: '), write(NND), nl.
