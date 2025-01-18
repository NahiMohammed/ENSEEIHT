%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARTIE 3 %%%%%%%%%%%%%%%%%%%%%%%%%

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

% Portée de 60 km
portee_60km = 60000;

%Calculer les matrices  d'adjacence 

Adj_low_60 = distance_matrix_low<=60000;
Adj_low_60 = Adj_low_60 - diag(diag(Adj_low_60));
Adj_low_60 = Adj_low_60.*(distance_matrix_low.^2);

Adj_avg_60=distance_matrix_avg<=60000;
Adj_avg_60 = Adj_avg_60 - diag(diag(Adj_avg_60));
Adj_avg_60 = Adj_avg_60.*(distance_matrix_avg.^2);


Adj_high_60=distance_matrix_high<=60000;
Adj_high_60 = Adj_high_60 - diag(diag(Adj_high_60));
Adj_high_60 = Adj_high_60.*(distance_matrix_high.^2);

% Draw(Adj_low_60, x_low, y_low, z_low, 'low', 60);
% Draw(Adj_avg_60, x_low, y_low, z_low, 'avg', 60);
% Draw(Adj_high_60, x_low, y_low, z_low, 'high', 60);



%%%Calcul des plus court chemins
%Appel de la fonction pour Adj_low_60
% [distances_low, chemins_low] = floydWarshall(Adj_low_60);
% disp('Matrice des distances pour Adj_low_60 :');
% disp(distances_low);
% disp('Matrice des chemins pour Adj_low_60 :');
% disp(chemins_low);
% 
% % Appel de la fonction pour Adj_avg_60
% [distances_avg, chemins_avg] = floydWarshall(Adj_avg_60);
% disp('Matrice des distances pour Adj_avg_60 :');
% disp(distances_avg);
% disp('Matrice des chemins pour Adj_avg_60 :');
% disp(chemins_avg);
% 
% % Appel de la fonction pour Adj_high_60
% [distances_high, chemins_high] = floydWarshall(Adj_high_60);
% disp('Matrice des distances pour Adj_high_60 :');
% disp(distances_high);
% disp('Matrice des chemins pour Adj_high_60 :');
% disp(chemins_high);

