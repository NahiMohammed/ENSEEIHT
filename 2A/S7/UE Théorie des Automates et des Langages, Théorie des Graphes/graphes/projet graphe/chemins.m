function resultatsChemins = chemins(A)
    G = graph(A);
    n = size(A, 1); % Nombre de nœuds

    % Initialiser la matrice pour stocker les résultats
    resultatsChemins = cell(n, n); 

    % Parcourir tous les nœuds pour trouver les plus courts chemins
    for i = 1:n
        for j = 1:n
            if i ~= j
                [path, ~] = shortestpath(G, i, j);
                if ~isempty(path)
                    % Convertir le chemin en une chaîne avec des séparateurs
                    resultatsChemins{i, j} = join(string(path), '/');
                end
            end
       end
end
end