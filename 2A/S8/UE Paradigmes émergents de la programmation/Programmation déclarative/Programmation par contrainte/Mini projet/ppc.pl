% Programmation Déclarative
% MiniProjet 2 : Programmation par contraintes
% @Author : NAHI Mohammed  - L4
%           Mnaoui Youssef - L3

:- include(libtp2).

%---------------------------------------------------------------------------------------------%
%                                Modele basique                                               %
%---------------------------------------------------------------------------------------------%

% Prédicat principal pour résoudre l'instance Num
solve_v1(Num, Xs, Ys,B) :-
    data(Num, T, Ts),                       % Charger les données de l'instance
    length(Ts, N),                          % Nombre de petits carrés
    length(Xs, N),                          % Liste des coordonnées X
    length(Ys, N),                          % Liste des coordonnées Y
    definir_domaine(Xs, T, Ts),             % Définir les domaines des coordonnées X
    definir_domaine(Ys, T, Ts),             % Définir les domaines des coordonnées Y
    eviter_chevauchement(Xs, Ys, Ts),       % Éviter le chevauchement
    fd_labeling(Xs, [backtracks(B)]),
    fd_labeling(Ys, [backtracks(B)]),                
    printsol('solution01.txt', Xs, Ys, Ts). % Imprimer la solution dans un fichier

% Imposer les contraintes pour Xs et Ys
definir_domaine([], _, []).
definir_domaine([Coord|Coords], Capacite, [Taille|Tailles]) :-
    Max is Capacite - Taille,
    fd_domain(Coord, 0, Max),
    definir_domaine(Coords, Capacite, Tailles).

% Eviter le chauvauchement entre les petits carrés
eviter_chevauchement([], [], []).
eviter_chevauchement([X|Xs], [Y|Ys], [Taille|Tailles]) :-
    eviter_chevauchement_2(X, Y, Taille, Xs, Ys, Tailles),
    eviter_chevauchement(Xs, Ys, Tailles).

% Prédicats de contrainte de non-chevauchement par paire: Carré_i & [Carré_j|Carrés] %
eviter_chevauchement_2(_, _, _, [], [], []).
eviter_chevauchement_2(X, Y, Taille, [Xj|Xs], [Yj|Ys], [Tj|Tailles]) :-
        X + Taille #=< Xj
    #\/ Xj + Tj #=< X 
	#\/ Y + Taille #=< Yj 
	#\/ Yj + Tj #=< Y,
    % réc. Tailles %
    eviter_chevauchement_2(X, Y, Taille, Xs, Ys, Tailles).


    

%---------------------------------------------------------------------------------------------%
%                                Modele redondant                                             %
%---------------------------------------------------------------------------------------------%


% Predicat pour résoudre le problème avec les contraintes redondantes %
solve_v2(Num, Xs, Ys, B) :- 
	% Obtenir les données du fichier libtp2.pl %
	data(Num, T, Ts),
    % Initialisation de la longueur des listes %
	length(Ts, Len),
	length(Xs, Len),
	length(Ys, Len),
	% Domaines des variables dans les listes Xs et Ys %
	definir_domaine(Xs, T, Ts),
	definir_domaine(Ys, T, Ts),
	% Contraintes de chevauchement %
    eviter_chevauchement(Xs, Ys, Ts),
	% Contraintes redondantes %
	contrainte_redundante(T, 0, Xs, Ts),
	contrainte_redundante(T, 0, Ys, Ts),
	% Calcul de la solution et des backtracks %
	fd_labeling(Xs, [backtracks(B)]),
	fd_labeling(Ys, [backtracks(B)]),
	% Écrire les résultats dans le fichier solution02.txt %
	printsol('solution02.txt', Xs, Ys, Ts).

% Cas de base
contrainte_redundante(Capacity, Capacity, _, _).
% Ajoute des contraintes redondantes pour chaque verticale.
contrainte_redundante(Capacity, Vertical, Xs, Ts) :-
    % Ajoute des contraintes redondantes pour une unité verticale spécifique.
    contrainte_redundante_unite(Vertical, Xs, Ts, B),
    % Multiplie les tailles des carrés par les indicateurs de croisement.
    produit_liste(Ts, B, Produits),
    % Calcule la somme des produits pour vérifier la contrainte de capacité.
    somme_liste(Produits, Capacity),
    % Passe à la verticale suivante.
    ProchaineVertical #= Vertical + 1,
    % Appel récursif pour la prochaine verticale.
    contrainte_redundante(Capacity, ProchaineVertical, Xs, Ts).

% Cas de base
contrainte_redundante_unite(_, [], [], []).
% Détermine si un carré croise une verticale.
contrainte_redundante_unite(Vertical, [Xi|Xs], [Ti|Ts], [Croisement|Croisements]) :-
    Croisement #<=> (Xi #=< Vertical #/\ Vertical #< Xi + Ti),
    % Appel récursif pour les autres carrés.
    contrainte_redundante_unite(Vertical, Xs, Ts, Croisements).

% Cas de base
produit_liste([], [], []).
% Multiplie les éléments de deux listes élément par élément.
produit_liste([Elem1 | Reste1], [Elem2 | Reste2], R) :-
    Produit #= Elem1 * Elem2,
    % Appel récursif pour les éléments restants.
    produit_liste(Reste1, Reste2, R1),
    append([Produit], R1, R).

% Cas de base 
somme_liste([], 0).
% Calcule la somme des éléments d'une liste.
somme_liste([Elem | Reste], Somme) :-
    % Appel récursif pour la somme des éléments restants.
    somme_liste(Reste, SommeRestante),
    Somme #= Elem + SommeRestante.


%--------------------------------Resultats du test -------------------------------------------%

% solve_v1(1, Xs, Ys, B) : Nombre de backtracks (B) : 2
% solve_v1(2, Xs, Ys, B) : Nombre de backtracks (B) : 0
% Dans solve_v2, les contraintes redondantes sont utilisées, tandis que dans solve_v1, 
% elles ne le sont pas. Cela signifie que l'ajout de contraintes redondantes dans solve_v2 a 
% permis de réduire le nombre de backtracks nécessaires pour trouver une solution.

%---------------------------------------------------------------------------------------------%
%                                Stratégie Recherche                                          %
%---------------------------------------------------------------------------------------------%

solve_v3(Num, Xs, Ys, B, Goal, NbSol) :- 
    % Obtention des données à partir du fichier libtp2.pl %
    data(Num, T, Ts),
    % Initialisation de la longueur des listes %
    length(Ts, NbSquares),
    length(Xs, NbSquares),
    length(Ys, NbSquares),
    % Définition des domaines des variables dans les listes Xs et Ys %
    definir_domaine(Xs, T, Ts),
    definir_domaine(Ys, T, Ts),
    % Application des contraintes de non-superposition %
    eviter_chevauchement(Xs, Ys, Ts),
    % Application des contraintes redondantes %
    contrainte_redundante(T, 0, Xs, Ts),
    contrainte_redundante(T, 0, Ys, Ts),
    % Calcul de la solution et du nombre de backtracks en utilisant la labellisation avec le critère Goal %
    labeling(Xs, Ys, Goal, minmin, B, NbSol),
    % Écriture des résultats dans le fichier solution03.txt %
    printsol('solution03.txt',Xs,Ys,Ts).


%--------------------------------Resultats du test -------------------------------------------%
% Pour solve_v3(2, Xs, Ys, B, assign, NbSol)   : Nombre de backtracks (B) : 805
%                                                Nombre de solutions trouvées (NbSol) : 1

% Pour solve_v3(2, Xs, Ys, B, indomain, NbSol) : Nombre de backtracks (B) : 9038
%                                                Nombre de solutions trouvées (NbSol) : 1

% la stratégie assign est plus efficace en termes de nombre de backtracks nécessaires pour 
% trouver une solution dans cette instance donnée. Cela pourrait être dû à la façon dont la 
% stratégie assign sélectionne dynamiquement les variables à affecter, ce qui peut conduire à 
% une exploration plus efficace de l'espace de recherche.


%---------------------------------------------------------------------------------------------%
%                                Symétrie                                                     %
%---------------------------------------------------------------------------------------------%


% Prédicat pour résoudre le problème en brisant la symétrie par des coordonnées séquentielles
solve_v4_1(Num, Xs, Ys, B, Goal, NbSol) :- 
    % Charger les données de l'instance
    data(Num, T, Ts),
    % Obtenir la longueur des listes
    length(Ts, Len),
    length(Xs, Len),
    length(Ys, Len),
    % Définir les domaines des variables Xs et Ys en fonction de T et Ts
    definir_domaine(Xs, T, Ts),
    definir_domaine(Ys, T, Ts),
    % Éviter le chevauchement
    eviter_chevauchement(Xs, Ys, Ts),
    % Ajouter les contraintes redondantes
    contrainte_redundante(T, 0, Xs, Ts),
    contrainte_redundante(T, 0, Ys, Ts),
    % Briser la symétrie en ordonnant les coordonnées des carrés
    ordonner_coordonnees(Xs, Ys, Ts),
    % Calculer la solution et le nombre de backtracks
    labeling(Xs, Ys, Goal, minmin, B, NbSol),
    % Imprimer les résultats dans un fichier
    printsol('solution04_1.txt', Xs, Ys, Ts).


% Briser la symétrie en ordonnant les coordonnées des carrés
ordonner_coordonnees([_], [_], [_]).
ordonner_coordonnees([X,Xi|Xs], [Y,Yi|Ys], [T,Ti|Ts]) :-
    (Ti #\= T) 
    #\/ (
        (  Yi #< Y
        #\/ Xi #< X)
        #/\ Xi #=< X),
        ordonner_coordonnees([Xi|Xs], [Yi|Ys], [Ti|Ts]).


%--------------------------------Resultats du test -------------------------------------------%

% Pour solve_v4_1(1, Xs, Ys, B, assign, NbSol) :
% Nombre de backtracks (B) : 1
% Nombre de solutions trouvées (NbSol) : 1
% Coordonnées des carrés Xs : [0, 2, 2, 2, 1, 0]
% Coordonnées des carrés Ys : [0, 2, 1, 0, 2, 2]

% Nombre de backtracks (B) : 2
% Nombre de solutions trouvées (NbSol) : 2
% Coordonnées des carrés Xs : [0, 2, 2, 2, 1, 0]
% Coordonnées des carrés Ys : [1, 2, 1, 0, 0, 0]
% Après avoir obtenu la deuxième solution et appuyé sur 'a':

% Nombre de backtracks (B) : 7
% Nombre de solutions trouvées (NbSol) : 3
% Coordonnées des carrés Xs : [1, 2, 1, 0, 0, 0]
% Coordonnées des carrés Ys : [0, 2, 2, 2, 1, 0]
% Après avoir obtenu la troisième solution et appuyé sur 'a':

% Nombre de backtracks (B) : 8 
% Nombre de solutions trouvées (NbSol) : 4
% Coordonnées des carrés Xs : [1, 2, 1, 0, 0, 0]
% Coordonnées des carrés Ys : [1, 0, 0, 2, 1, 0]

% Cela montre que chaque fois qu'une solution est trouvée, 
% le nombre de backtracks augmente progressivement. 
% En utilisant la stratégie assign, la symétrie de permutation 
% entre les petits carrés de même taille est rompue en ordonnant 
% leurs coordonnées lexicographiquement, ce qui permet de trouver 
% les différentes solutions possibles.





