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


