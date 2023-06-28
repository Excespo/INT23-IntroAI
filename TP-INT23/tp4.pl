/* Operateurs */

operateur(a2b,a,b,4).
operateur(a2f,a,f,6).
operateur(a2g,a,g,2).

operateur(b2c,b,c,1).
operateur(b2e,b,e,5).
operateur(b2f,b,f,3).

operateur(c2f,c,f,6).
operateur(c2g,c,g,8).

operateur(e2h,e,h,3).
operateur(e2l,e,l,6).

operateur(f2e,e,h,7).
operateur(f2h,f,h,3).
operateur(f2i,f,i,9).

operateur(g2f,g,f,4).
operateur(g2i,g,i,6).


operateur(h2k,h,k,2).
operateur(h2l,h,l,1).
operateur(h2i,h,i,9).

operateur(i2j,i,j,9).

operateur(j2g,j,g,2).

operateur(k2n,k,n,4).

operateur(l2j,l,j,1).
operateur(l2k,l,k,3).
operateur(l2o,l,o,3).
operateur(l2p,l,p,12).


operateur(m2q,m,q,4).

operateur(n2o,n,o,1).
operateur(n2p,n,p,9).
operateur(n2q,n,q,10).

operateur(o2m,o,m,3).
operateur(o2p,o,p,9).
operateur(o2q,o,q,9).

/* Etats terminaux */
but(p).
but(q).

/* heuristique terminaux */

eval_heuristique(h1,a,17).
eval_heuristique(h1,b,15).
eval_heuristique(h1,c,15).
eval_heuristique(h1,e,17).
eval_heuristique(h1,f,15).
eval_heuristique(h1,g,15).
eval_heuristique(h1,h,10 ).
eval_heuristique(h1,i,9).
eval_heuristique(h1,j,7).
eval_heuristique(h1,k,9).
eval_heuristique(h1,l,8).
eval_heuristique(h1,m,2).
eval_heuristique(h1,n,7).
eval_heuristique(h1,o,6).
eval_heuristique(h1,p,0).
eval_heuristique(h1,q,0).

