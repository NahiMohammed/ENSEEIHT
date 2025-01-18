/* **************************************************************************
   Objet                                 Poids (kg)       Utilité 
   -------------------------------------------------------------------------- 
   Morceau du pont Saint Pierre          10              1
   Cachous                                1              2
   Stock de ballons de rugby              7		         1
   Goodies Airbus et Cité de l'Espace     6		         3
   Ordinateur salle TP N7                10 	            2
   ******************************************************************************* */
   
   
/* ***************************  Definition poids ********************************* */
poids(morceau_du_pont_Saint_Pierre, 10).
poids(cachous, 1).
poids(stock_de_ballons_de_rugueubi, 7).
poids(goodies_Airbus_et_Cite_de_l_Espace, 6).
poids(ordinateur_salle_TP_N7, 10). 



/* ***************************  Poids sacs(S,P)  ********************************* */
/****   poids_sac(S, P) est vrai si P est le poids total de la liste d'objets S.** */
poids_sac([], 0).
poids_sac([Objet|Reste], PoidsTotal) :-
    poids(Objet, PoidsObjet),
    poids_sac(Reste, PoidsReste),
    PoidsTotal is PoidsObjet + PoidsReste.  



/* *************************** sous-liste(L,M)  ********************************** */
/**** sous_liste(L, M) est vrai si M est une sous-liste de L.********************* */
sous_liste(L, []).
sous_liste([T | M1], [T | M2]) :- sous_liste(M1, M2).
sous_liste([ _ | M1], [T | M2]) :- sous_liste(M1, [T | M2]).



/* *************************** acceptable(L, S)  ********************************* */
/*acceptable(L, S) est vrai si S est une liste d’objets choisis dans la liste L,** */
/* et si le poiuds total des objets ne depasse pas 20 Kg   *********************** */
acceptable(L, S) :- sous_liste(L, S), poids_sac(S,  P), P =< 20.



/* *************************** meilleur_poids  **************************** */
/*meilleur_poids(L, S) est  vrai si S est une liste acceptable d’objets *** */ 
/*******    choisis dans la liste L, de poids maximal ********************* */
meilleur_poids(L, S1) :- acceptable(L, S1), poids_sac(S1, P1),
                        \+ (acceptable(L, S2), poids_sac(S2, P2),
                        P1 < P2).



/* *************************** utilite  *********************************** */
/*un prédicat utilite qui représente l’utilité d’un objet pour le voyageur. */
utilite(morceau_du_pont_Saint_Pierre, 1).
utilite(cachous, 2).
utilite(stock_de_ballons_de_rugueubi, 1).
utilite(goodies_Airbus_et_Cite_de_l_Espace, 3).
utilite(ordinateur_salle_TP_N7, 2).



/* *************************** meilleure_utilite(L,S) ********************* */
/*  est vrai si S est une
liste d’objets de poids maximal et d’utilité maximale.********************* */
somme_utilite([], 0).
somme_utilite([T | Q], U) :- somme_utilite(Q, N), utilite(T, M), U is M + N.
meilleure_utilite(L, S1) :- acceptable(L, S1), somme_utilite(S1, U1),
                            \+ (acceptable(L, S2), somme_utilite(S2, U2),
                            U1 < U2).




/* *************************** e problème avec la définition précédente de meilleur_poids **************************** */

/*Le problème avec la définition précédente de meilleur_poids est qu'elle peut être inefficace en raison de la méthode utilisée pour vérifier si une autre sous-liste de poids total supérieur existe.
*/

/*
Le prédicat p est un prédicat ternaire. Son premier argument est une liste contenant plusieurs éléments, le deuxième argument est un marqueur qui apparaît dans la première liste, et le troisième argument est l'ensemble des sous-listes obtenues à partir du marqueur dans la liste d'entrée. 
*/


/* Définition de meilleur_poids 
   meilleur_poids_v2(L, S) est vrai si S est une liste acceptable d’objets, choisie dans la liste L, de poids maximal 
   il n’y a pas moyen de choisir dans L une autre liste acceptable d’objets de poids total strictement supérieur au poids total des objets de S
*/






/* *******************************************************  TESTS EFFECTUES ******************************************************* */
/*
| ?- poids(morceau_du_pont_Saint_Pierre, 10).
yes


| ?- poids_sac([morceau_du_pont_Saint_Pierre, cachous, stock_de_ballons_de_rugueubi], Poids).
Poids = 18


| ?- poids_sac([morceau_du_pont_Saint_Pierre, cachous, stock_de_ballons_de_rugueubi], 18).
yes


| ?- sous_liste([a, b, c], SousListe).
SousListe = [] ? ;
SousListe = [a] ? ;
SousListe = [a,b] ? ;
SousListe = [a,b,c] ? ;
SousListe = [a,c] ? ;
SousListe = [b] ? ;
SousListe = [b,c] ? ;
SousListe = [c] ? ;


| ?- sous_liste([a, b], SousListe).
SousListe = [] ? ;
SousListe = [a] ? ;
SousListe = [a,b] ? ;
SousListe = [b] ? ;
no


| ?- acceptable([morceau_du_pont_Saint_Pierre, cachous, stock_de_ballons_de_rugueubi], Sac).
Sac = [] ? ;
Sac = [morceau_du_pont_Saint_Pierre] ? ;
Sac = [morceau_du_pont_Saint_Pierre,cachous] ? ;
Sac = [morceau_du_pont_Saint_Pierre,cachous,stock_de_ballons_de_rugueubi] ? ;
Sac = [morceau_du_pont_Saint_Pierre,stock_de_ballons_de_rugueubi] ? ;
Sac = [cachous] ? ;
Sac = [cachous,stock_de_ballons_de_rugueubi] ? ;
Sac = [stock_de_ballons_de_rugueubi] ? ;
no


| ?- acceptable([morceau_du_pont_Saint_Pierre, cachous, stock_de_ballons_de_rugueubi,goodies_Airbus_et_Cite_de_l_Espace,ordinateur_salle_TP_N7],Sac).
Sac = [] ? ;
Sac = [morceau_du_pont_Saint_Pierre] ? ;
Sac = [morceau_du_pont_Saint_Pierre,cachous] ? ;
Sac = [morceau_du_pont_Saint_Pierre,cachous,stock_de_ballons_de_rugueubi] ? ;
Sac = [morceau_du_pont_Saint_Pierre,cachous,goodies_Airbus_et_Cite_de_l_Espace] ? ;
Sac = [morceau_du_pont_Saint_Pierre,stock_de_ballons_de_rugueubi] ? ;
Sac = [morceau_du_pont_Saint_Pierre,goodies_Airbus_et_Cite_de_l_Espace] ? ;
Sac = [morceau_du_pont_Saint_Pierre,ordinateur_salle_TP_N7] ? ;
Sac = [cachous] ? ;
Sac = [cachous,stock_de_ballons_de_rugueubi] ? ;
Sac = [cachous,stock_de_ballons_de_rugueubi,goodies_Airbus_et_Cite_de_l_Espace] ? ;
Sac = [cachous,stock_de_ballons_de_rugueubi,ordinateur_salle_TP_N7] ? ;
Sac = [cachous,goodies_Airbus_et_Cite_de_l_Espace] ? ;
Sac = [cachous,goodies_Airbus_et_Cite_de_l_Espace,ordinateur_salle_TP_N7] ? ;
Sac = [cachous,ordinateur_salle_TP_N7] ? ;
Sac = [stock_de_ballons_de_rugueubi] ? ;
Sac = [stock_de_ballons_de_rugueubi,goodies_Airbus_et_Cite_de_l_Espace] ? ;
Sac = [stock_de_ballons_de_rugueubi,ordinateur_salle_TP_N7] ? ;
Sac = [goodies_Airbus_et_Cite_de_l_Espace] ? ;
Sac = [goodies_Airbus_et_Cite_de_l_Espace,ordinateur_salle_TP_N7] ? ;
Sac = [ordinateur_salle_TP_N7] ? ;
no


| ?- meilleur_poids([morceau_du_pont_Saint_Pierre, cachous, stock_de_ballons_de_rugueubi, goodies_Airbus_et_Cite_de_l_Espace, ordinateur_salle_TP_N7], Sac).
Sac = [morceau_du_pont_Saint_Pierre,ordinateur_salle_TP_N7] ? ;



*************************************************************      RESULTAT ATTENDU DU MINI PROJET      ****************************************************

meilleure_utilite([morceau_du_pont_Saint_Pierre, cachous, stock_de_ballons_de_rugueubi, goodies_Airbus_et_Cite_de_l_Espace, ordinateur_salle_TP_N7], Sac).
Sac = [cachous,goodies_Airbus_et_Cite_de_l_Espace,ordinateur_salle_TP_N7] ? ;
no

*/