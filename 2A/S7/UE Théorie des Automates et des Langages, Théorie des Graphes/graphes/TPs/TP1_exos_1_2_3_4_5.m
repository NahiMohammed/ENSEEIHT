%%%%% SET ENV %%%%%

addpath('matlab_bgl');      %load graph libraries
addpath('matlab_tpgraphe'); %load tp ressources

load TPgraphe.mat;          %load data

%%%%%% DISPLAY INPUT DATA ON TERMINAL %%%%%

cities ;%names of cities
D      ;%distance matrix bw cities
pos    ;%x-y pos of the cities

% %%%%%%EXO 1 (modeliser et afficher le graphe) %%%%%
% 
% A=XXX A faire; %adj matrix
% viz_adj(D,A,pos,cities);
% viz_adj(D,XXX A faire,pos,cities);
%%%%%% EXO 1 (modéliser et afficher le graphe) %%%%%

% Distance limite pour la connexion radio
d = 500;

% Initialiser la matrice d'adjacence A en fonction de la distance limite
A = D <= d;

% Afficher le graphe
viz_adj(D, A, pos, cities);
lengths = [2, 3, 10, 12];
for n = lengths

    viz_adj(D, graphPower(A, n), pos, cities);
end

%%%%%% EXO 2 %%%%%

%Q1 - existence d'un chemin de longueur 3
A3 = bmul(bmul(A, A), A);
viz_adj(D, A3, pos, cities);
%Q2 - nb de chemins de 3 sauts
nbChemins3Sauts = sum(A3(:));

%Q3 - nb de chemins <=3
A1 = A | bmul(A, A) | bmul(bmul(A, A), A);
nbCheminsMoinsOuEgal3 = sum(A1(:));

%%%%%%%% EXO 3 %%%%%

function appartient = possedechaine(G, chaine)
    % G : matrice d'adjacence du graphe
    % chaine : vecteur d’indices de sommets représentant la chaîne
    
    % Vérifier que la longueur de la chaîne est au moins de 2
    if length(chaine) < 2
        error('La chaîne doit avoir au moins deux sommets.');
    end
    
    % Vérifier que tous les sommets de la chaîne existent dans le graphe
    if any(chaine < 1) || any(chaine > size(G, 1))
        error('Certains indices de sommets de la chaîne ne sont pas valides.');
    end
    
    % Vérifier que chaque paire de sommets consécutifs dans la chaîne est reliée par une arête
    for i = 1:length(chaine)-1
        if G(chaine(i), chaine(i+1)) == 0
            appartient = false;
            return;
        end
    end
    
    % Si toutes les vérifications passent, la chaîne appartient au graphe
    appartient = true;
end
c=[18 13 9]; %la chaine 18 13 9 est t dans le graphe?
possedechaine(A,c)
c=[18 6 3]; %la chaine 18 6 3 est t dans le graphe?
possedechaine(A,c)
c=[26 5 17]; %la chaine 26 5 17 est t dans le graphe?
possedechaine(A,c)

%%%%%%%% EXO 4%%%%%
isEulerien(A)

%%%%%%%% EXO 5%%%%%
porteeEulerien(D)
