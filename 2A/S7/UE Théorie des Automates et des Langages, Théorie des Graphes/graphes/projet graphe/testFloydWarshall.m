% Matrice d'adjacence pondérée (poids des arêtes)
adjacencyMatrix = [
    0, 3, 0, 7;
    3, 0, 2, 0;
    0, 2, 0, 4;
    7, 0, 4, 0
];

% Appel de la fonction pour obtenir les distances et les chemins
[distances, chemins] = floydWarshall(adjacencyMatrix);

% Affichage des résultats
disp('Matrice des distances :');
disp(distances);
disp('Matrice des chemins :');
disp(chemins);
