function [distances, chemins] = floydWarshall(W)
    % W est la matrice des poids des arêtes du graphe
    n = size(W, 1);
    distances = W;
    chemins = cell(n, n);

    % Remplacer les zéros par Inf sauf sur la diagonale
    distances(distances == 0 & eye(n) == 0) = Inf;

    % Initialisation des chemins
    for i = 1:n
        for j = 1:n
            if i ~= j && distances(i, j) < Inf
                chemins{i, j} = [i, j];  % Le chemin direct de i à j est [i, j]
            end
        end
    end

    % Algorithme de Floyd-Warshall
    for k = 1:n
        for i = 1:n
            for j = 1:n
                if distances(i, k) + distances(k, j) < distances(i, j)
                    distances(i, j) = distances(i, k) + distances(k, j);
                    chemins{i, j} = [chemins{i, k}, chemins{k, j}(2:end)];  % Mise à jour du chemin via le sommet k
                end
            end
        end
    end
end

