close all;
clear all;

addpath('matlab_bgl'); %load graph libraries
addpath('matlab_tpgraphe'); %load tp ressources


% Charger les données de mobilité pour les trois configurations de densité
data_low = readtable('topology_low.csv');
data_avg = readtable('topology_avg.csv');
data_high = readtable('topology_high.csv');

% Extraire les positions x, y, z
x_low = data_low.x;
y_low = data_low.y;
z_low = data_low.z;

x_avg = data_avg.x;
y_avg = data_avg.y;
z_avg = data_avg.z;

x_high = data_high.x;
y_high = data_high.y; 
z_high = data_high.z;

% Calculer les matrices de distances
distance_matrix_low  = calculateDistanceMatrix(x_low , y_low , z_low );
distance_matrix_avg  = calculateDistanceMatrix(x_avg , y_avg , z_avg ); 
distance_matrix_high = calculateDistanceMatrix(x_high, y_high, z_high); 

%Calculer les matrices  d'adjacence 
Adj_low_20=distance_matrix_low<=20000;
Adj_low_20 = Adj_low_20 - diag(diag(Adj_low_20));

Adj_low_40=distance_matrix_low<=40000;
Adj_low_40 = Adj_low_40 - diag(diag(Adj_low_40));

Adj_low_60=distance_matrix_low<=60000;
Adj_low_60 = Adj_low_60 - diag(diag(Adj_low_60));

Adj_avg_20=distance_matrix_avg<=20000;
Adj_avg_20 = Adj_avg_20 - diag(diag(Adj_avg_20));

Adj_avg_40=distance_matrix_avg<=40000;
Adj_avg_40 = Adj_avg_40 - diag(diag(Adj_avg_40));

Adj_avg_60=distance_matrix_avg<=60000;
Adj_avg_60 = Adj_avg_60 - diag(diag(Adj_avg_60));

Adj_high_20=distance_matrix_high<=20000;
Adj_high_20 = Adj_high_20 - diag(diag(Adj_high_20));

Adj_high_40=distance_matrix_high<=40000;
Adj_high_40 = Adj_high_40 - diag(diag(Adj_high_40));

Adj_high_60=distance_matrix_high<=60000;
Adj_high_60 = Adj_high_60 - diag(diag(Adj_high_60));

Draw(Adj_low_20, x_low, y_low, z_low, 'low', 20);
Draw(Adj_avg_20, x_avg, y_avg, z_avg, 'avg', 20);
Draw(Adj_high_20, x_high, y_high, z_high, 'high', 20);

Draw(Adj_low_40, x_low, y_low, z_low, 'low', 40);
Draw(Adj_avg_40, x_avg, y_avg, z_avg, 'avg', 40);
Draw(Adj_high_40, x_high, y_high, z_high, 'high', 40);

Draw(Adj_low_60, x_low, y_low, z_low, 'low', 60);
Draw(Adj_avg_60, x_avg, y_avg, z_avg, 'avg', 60);
Draw(Adj_high_60, x_high, y_high, z_high, 'high', 60);

%%%%%%%%%%%%%%%%%%%%%%%%% PARTIE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Définir les graphes à partir des matrices d'adjacence
G_low_20 = graph(Adj_low_20);
G_low_40 = graph(Adj_low_40);
G_low_60 = graph(Adj_low_60);

G_avg_20 = graph(Adj_avg_20);
G_avg_40 = graph(Adj_avg_40);
G_avg_60 = graph(Adj_avg_60);

G_high_20 = graph(Adj_high_20);
G_high_40 = graph(Adj_high_40);
G_high_60 = graph(Adj_high_60);

% Calculer les caractéristiques pour chaque graphe
disp(['les caractéristiques pour chaque graphe...']);
% (Degré moyen, distribution du degré, moyenne et distribution du degré de clustering)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Degré moyen %%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(['---------------Degré moyen---------------']);
degree_avg_low_20 = mean(degree(G_low_20));
disp(['Degré moyen pour densité faible, portée 20 : ' num2str(degree_avg_low_20)]);
degree_avg_low_40 = mean(degree(G_low_40));
disp(['Degré moyen pour densité faible, portée 40 : ' num2str(degree_avg_low_40)]);
degree_avg_low_60 = mean(degree(G_low_60));
disp(['Degré moyen pour densité faible, portée 60 : ' num2str(degree_avg_low_60)]);

degree_avg_avg_20 = mean(degree(G_avg_20));
disp(['Degré moyen pour densité moyenne, portée 20 : ' num2str(degree_avg_avg_20)]);
degree_avg_avg_40 = mean(degree(G_avg_40));
disp(['Degré moyen pour densité moyenne, portée 40 : ' num2str(degree_avg_avg_40)]);
degree_avg_avg_60 = mean(degree(G_avg_60));
disp(['Degré moyen pour densité moyenne, portée 60 : ' num2str(degree_avg_avg_60)]);

degree_avg_high_20 = mean(degree(G_high_20));
disp(['Degré moyen pour densité élevée, portée 20 : ' num2str(degree_avg_high_20)]);
degree_avg_high_40 = mean(degree(G_high_40));
disp(['Degré moyen pour densité élevée, portée 40 : ' num2str(degree_avg_high_40)]);
degree_avg_high_60 = mean(degree(G_high_60));
disp(['Degré moyen pour densité élevée, portée 60 : ' num2str(degree_avg_high_60)]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distribution du degré %%%%%%%%%%%%%%%%%%%%%%

degree_dist_low_20 = hist(degree(G_low_20), unique(degree(G_low_20)));
figure;
    bar(unique(degree(G_low_20)), degree_dist_low_20);
    xlabel('Degré');
    ylabel('Fréquence ');
    title('Distribution du degré pour densité faible, portée 20');

degree_dist_low_40 = hist(degree(G_low_40), unique(degree(G_low_40)));
figure;
    bar(unique(degree(G_low_40)), degree_dist_low_40);
    xlabel('Degré');
    ylabel('Fréquence ');
    title('Distribution du degré pour densité faible, portée 40');

degree_dist_low_60 = hist(degree(G_low_60), unique(degree(G_low_60)));
figure;
    bar(unique(degree(G_low_60)), degree_dist_low_60);
    xlabel('Degré');
    ylabel('Fréquence ');
    title('Distribution du degré pour densité faible, portée 60');

degree_dist_avg_20 = hist(degree(G_avg_20), unique(degree(G_avg_20)));
figure;
    bar(unique(degree(G_avg_20)), degree_dist_avg_20);
    xlabel('Degré');
    ylabel('Fréquence ');
    title('Distribution du degré pour densité moyenne, portée 20');
degree_dist_avg_40 = hist(degree(G_avg_40), unique(degree(G_avg_40)));
figure;
    bar(unique(degree(G_avg_40)), degree_dist_avg_40);
    xlabel('Degré');
    ylabel('Fréquence ');
    title('Distribution du degré pour densité moyenne, portée 40');

degree_dist_avg_60 = hist(degree(G_avg_60), unique(degree(G_avg_60)));
figure;
    bar(unique(degree(G_avg_60)), degree_dist_avg_60);
    xlabel('Degré');
    ylabel('Fréquence ');
    title('Distribution du degré pour densité moyenne, portée 60');


degree_dist_high_20 = hist(degree(G_high_20), unique(degree(G_high_20)));
figure;
    bar(unique(degree(G_high_20)), degree_dist_high_20);
    xlabel('Degré');
    ylabel('Fréquence ');
    title('Distribution du degré pour densité élevée, portée 20');
degree_dist_high_40 = hist(degree(G_high_40), unique(degree(G_high_40)));
figure;
    bar(unique(degree(G_high_40)), degree_dist_high_40);
    xlabel('Degré');
    ylabel('Fréquence ');
    title('Distribution du degré pour densité élevée, portée 40');

degree_dist_high_60 = hist(degree(G_high_60), unique(degree(G_high_60)));
figure;
    bar(unique(degree(G_high_60)), degree_dist_high_60);
    xlabel('Degré');
    ylabel('Fréquence ');
    title('Distribution du degré pour densité élevée, portée 60');


%%%%%%%%%%%%%%%%%%%%%%degré de clustering%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Calcul la myenne des degré de clustring
ccfs_low_20 = clustering_coefficients(sparse(Adj_low_20));
ccfs_low_40 = clustering_coefficients(sparse(Adj_low_40));
ccfs_low_60 = clustering_coefficients(sparse(Adj_low_60));
 
ccfs_avg_20 = clustering_coefficients(sparse(Adj_avg_20));
ccfs_avg_40 = clustering_coefficients(sparse(Adj_avg_40));
ccfs_avg_60 = clustering_coefficients(sparse(Adj_avg_60));

ccfs_high_20 = clustering_coefficients(sparse(Adj_high_20));
ccfs_high_40 = clustering_coefficients(sparse(Adj_high_40));
ccfs_high_60 = clustering_coefficients(sparse(Adj_high_60));

%  Affichage des résultats
disp(['---------------Degré de clustering---------------'])
disp(['Moyenne des coefficients de regroupement pour densité faible, portée 20 : ' num2str(mean(ccfs_low_20))]);
disp(['Moyenne des coefficients de regroupement pour densité faible, portée 40 : ' num2str(mean(ccfs_low_40))]);
disp(['Moyenne des coefficients de regroupement pour densité faible, portée 60 : ' num2str(mean(ccfs_low_60))]);
disp(['Moyenne des coefficients de regroupement pour densité moyenne, portée 20 : ' num2str(mean(ccfs_avg_20))]);
disp(['Moyenne des coefficients de regroupement pour densité moyenne, portée 40 : ' num2str(mean(ccfs_avg_40))]);
disp(['Moyenne des coefficients de regroupement pour densité moyenne, portée 60 : ' num2str(mean(ccfs_avg_60))]);
disp(['Moyenne des coefficients de regroupement pour densité élevée, portée 20 : ' num2str(mean(ccfs_high_20))]);
disp(['Moyenne des coefficients de regroupement pour densité élevée, portée 40 : ' num2str(mean(ccfs_high_40))]);
disp(['Moyenne des coefficients de regroupement pour densité élevée, portée 60 : ' num2str(mean(ccfs_high_60))]);

%%%%%%%%%%%%%%%%%%%Distribution du u degré de clustering %%%%%%%%%%%%%%%%%
%Affichage de la distribution des coefficients de clustering
figure;

subplot(3, 3, 1);
histogram(ccfs_low_20, 'Normalization', 'probability');
title('Distribution du degré de clustering (Adj\_low\_20)');

subplot(3, 3, 2);
histogram(ccfs_low_40, 'Normalization', 'probability');
title('Distribution du degré de clustering (Adj\_low\_40)');

subplot(3, 3, 3);
histogram(ccfs_low_60, 'Normalization', 'probability');
title('Distribution du degré de clustering (Adj\_low\_60)');

subplot(3, 3, 4);
histogram(ccfs_avg_20, 'Normalization', 'probability');
title('Distribution du degré de clustering (Adj\_avg\_20)');

subplot(3, 3, 5);
histogram(ccfs_avg_40, 'Normalization', 'probability');
title('Distribution du degré de clustering (Adj\_avg\_40)');

subplot(3, 3, 6);
histogram(ccfs_avg_60, 'Normalization', 'probability');
title('Distribution du degré de clustering (Adj\_avg\_60)');

subplot(3, 3, 7);
histogram(ccfs_high_20, 'Normalization', 'probability');
title('Distribution du degré de clustering (Adj\_high\_20)');

subplot(3, 3, 8);
histogram(ccfs_high_40, 'Normalization', 'probability');
title('Distribution du degré de clustering (Adj\_high\_40)');

subplot(3, 3, 9);
histogram(ccfs_high_60, 'Normalization', 'probability');
title('Distribution du degré de clustering (Adj\_high\_60)');

sgtitle('Distributions du degré de clustering pour différentes configurations de densité');

%%%%%%%%%%%%%%%% Calcule du nombre de cliques et leurs ordres%%%%%%%%%%%%%% 
disp(['---------------Nombre de cliques et leurs ordres---------------'])
MC_low_20 = maximalCliques(Adj_low_20);
MC_low_40 = maximalCliques(Adj_low_40);
MC_low_60 = maximalCliques(Adj_low_60);

MC_avg_20 = maximalCliques(Adj_avg_20);
MC_avg_40 = maximalCliques(Adj_avg_40);
MC_avg_60 = maximalCliques(Adj_avg_60);

MC_high_20 = maximalCliques(Adj_high_20);
MC_high_40 = maximalCliques(Adj_high_40);
MC_high_60 = maximalCliques(Adj_high_60);

num_cliques_low_20 = size(MC_low_20, 2);
orders_low_20 = sum(MC_low_20, 1);%%ORDRE DES CLIQUES
disp(['Nombre de cliques dans le cas de densité faible, portée 20 : ' num2str(num_cliques_low_20)]);

num_cliques_low_40 = size(MC_low_40, 2);
orders_low_40 = sum(MC_low_40, 1);
disp(['Nombre de cliques dans le cas de densité faible, portée 40 : ' num2str(num_cliques_low_40)]);

num_cliques_low_60 = size(MC_low_60, 2);
orders_low_60 = sum(MC_low_60, 1);
disp(['Nombre de cliques dans le cas de densité faible, portée 60 : ' num2str(num_cliques_low_60)]);

num_cliques_avg_20 = size(MC_avg_20, 2);
orders_avg_20 = sum(MC_avg_20, 1);
disp(['Nombre de cliques dans le cas de densité moyenne, portée 20 : ' num2str(num_cliques_avg_20)]);

num_cliques_avg_40 = size(MC_avg_40, 2);
orders_avg_40 = sum(MC_avg_40, 1);
disp(['Nombre de cliques dans le cas de densité moyenne, portée 40 : ' num2str(num_cliques_avg_40)]);

num_cliques_avg_60 = size(MC_avg_60, 2);
orders_avg_60 = sum(MC_avg_60, 1);
disp(['Nombre de cliques dans le cas de densité moyenne, portée 60 : ' num2str(num_cliques_avg_60)]);

num_cliques_high_20 = size(MC_high_20, 2);
orders_high_20 = sum(MC_high_20, 1);
disp(['Nombre de cliques dans le cas de densité élevée, portée 20 : ' num2str(num_cliques_high_20)]);

num_cliques_high_40 = size(MC_high_40, 2);
orders_high_40 = sum(MC_high_40, 1);
disp(['Nombre de cliques dans le cas de densité élevée, portée 40 : ' num2str(num_cliques_high_40)]);

num_cliques_high_60 = size(MC_high_60, 2);
orders_high_60 = sum(MC_high_60, 1);
disp(['Nombre de cliques dans le cas de densité élevée, portée 60 : ' num2str(num_cliques_high_60)]);

%%%%%%%%%%Calcul du nombre de composantes connexes et leurs ordres%%%%%%%%%

disp(['---------------Nombre de composantes connexes et leurs ordres---------------'])
disp(['***Cas densité faible, portée 20 : '])
num_conn_comp_low_20 = conncomp(G_low_20);
disp(['Nombre de composantes connexes  : ' num2str(max(num_conn_comp_low_20))]);
% Calcul de l'occurrence des nombres de 1 à max(num_conn_comp_low_20)
occurrences = hist(num_conn_comp_low_20, 1:max(num_conn_comp_low_20));
disp(['Composante connexe | Ordre']);
for i = 1:max(num_conn_comp_low_20)
    disp([num2str(i) ' | ' num2str(occurrences(i))]);
end

disp(['***Cas densité faible, portée 40 : '])
num_conn_comp_low_40 = conncomp(G_low_40);
disp(['Nombre de composantes connexes  : ' num2str(max(num_conn_comp_low_40))]);
occurrences = hist(num_conn_comp_low_40, 1:max(num_conn_comp_low_40));
disp(['Composante connexe | Ordre']);
for i = 1:max(num_conn_comp_low_40)
    disp([num2str(i) ' | ' num2str(occurrences(i))]);
end

disp(['***Cas densité faible, portée 60 : '])
num_conn_comp_low_60 = conncomp(G_low_60);
disp(['Nombre de composantes connexes : ' num2str(max(num_conn_comp_low_60))]);
occurrences = hist(num_conn_comp_low_60, 1:max(num_conn_comp_low_60));
disp(['Composante connexe | Ordre']);
for i = 1:max(num_conn_comp_low_60)
    disp([num2str(i) ' | ' num2str(occurrences(i))]);

end

disp(['***Cas densité moyenne, portée 20 : '])
num_conn_comp_avg_20 = conncomp(G_avg_20);
disp(['Nombre de composantes connexes  : ' num2str(max(num_conn_comp_avg_20))]);
occurrences = hist(num_conn_comp_avg_20, 1:max(num_conn_comp_avg_20));
disp(['Composante connexe | Ordre']);
for i = 1:max(num_conn_comp_avg_20)
    disp([num2str(i) ' | ' num2str(occurrences(i))]);

end

disp(['***Cas densité moyenne, portée 40 : '])
num_conn_comp_avg_40 = conncomp(G_avg_40);
disp(['Nombre de composantes connexes  : ' num2str(max(num_conn_comp_avg_40))]);
occurrences = hist(num_conn_comp_avg_40, 1:max(num_conn_comp_avg_40));
disp(['Composante connexe | Ordre']);
for i = 1:max(num_conn_comp_avg_40)
    disp([num2str(i) ' | ' num2str(occurrences(i))]);
end

disp(['***Cas densité moyenne, portée 60 : '])
num_conn_comp_avg_60 = conncomp(G_avg_60);
disp(['Nombre de composantes connexes : ' num2str(max(num_conn_comp_avg_60))]);
occurrences = hist(num_conn_comp_avg_60, 1:max(num_conn_comp_avg_60));
disp(['Composante connexe | Ordre']);
for i = 1:max(num_conn_comp_avg_60)
    disp([num2str(i) ' | ' num2str(occurrences(i))]);

end


disp(['***Cas densité élevée, portée 20 : '])
num_conn_comp_high_20 = conncomp(G_high_20);
disp(['Nombre de composantes connexes  : ' num2str(max(num_conn_comp_high_20))]);
occurrences = hist(num_conn_comp_high_20, 1:max(num_conn_comp_high_20));
disp(['Composante connexe | Ordre']);
for i = 1:max(num_conn_comp_high_20)
    disp([num2str(i) ' | ' num2str(occurrences(i))]);

end


disp(['***Cas densité élevée, portée 40 : '])
num_conn_comp_high_40 = conncomp(G_high_40);
disp(['Nombre de composantes connexes  : ' num2str(max(num_conn_comp_high_40))]);
occurrences = hist(num_conn_comp_high_40, 1:max(num_conn_comp_high_40));
disp(['Composante connexe | Ordre']);
for i = 1:max(num_conn_comp_high_40)
    disp([num2str(i) ' | ' num2str(occurrences(i))]);

end

disp(['***Cas densité élevée, portée 60 : '])
num_conn_comp_high_60 = conncomp(G_high_60);
disp(['Nombre de composantes connexes  : ' num2str(max(num_conn_comp_high_60))]);

occurrences = hist(num_conn_comp_high_60, 1:max(num_conn_comp_high_60));
disp(['Composante connexe | Ordre']);
for i = 1:max(num_conn_comp_high_60)
    disp([num2str(i) ' | ' num2str(occurrences(i))]);

end


%%%%%%%% les plus courts chemins %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(['Matrice des chemins les plus courts ,Cas densité faible, portée 20 : ']);
% chemins(Adj_low_20)
% disp(['Matrice des chemins les plus courts ,Cas densité faible, portée 40 : ']);
% chemins(Adj_low_40)
% disp(['Matrice des chemins les plus courts ,Cas densité faible, portée 60 : ']);
% chemins(Adj_low_60)
% disp(['Matrice des chemins les plus courts ,Cas densité moyenne, portée 20 : ']);
% chemins(Adj_avg_20)
% disp(['Matrice des chemins les plus courts ,Cas densité moyenne, portée 40 : ']);
% chemins(Adj_avg_40)
% disp(['Matrice des chemins les plus courts ,Cas densité moyenne, portée 60 : ']);
% chemins(Adj_avg_60)
% disp(['Matrice des chemins les plus courts ,Cas densité élevée, portée 20 : ']);
% chemins(Adj_high_20)
% disp(['Matrice des chemins les plus courts ,Cas densité élevée, portée 40 : ']);
% chemins(Adj_high_40)
% disp(['Matrice des chemins les plus courts ,Cas densité élevée, portée 60 : ']);
% chemins(Adj_high_60)








