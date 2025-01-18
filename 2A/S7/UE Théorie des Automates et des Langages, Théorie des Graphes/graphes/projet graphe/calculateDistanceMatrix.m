function D = calculateDistanceMatrix(x, y, z)
    % Cette fonction prend en entrée trois vecteurs colonnes x, y, z
    % et renvoie la matrice de distances entre les points.

    % Assurez-vous que les vecteurs ont la même taille
    if numel(x) ~= numel(y) || numel(y) ~= numel(z)
        error('Les vecteurs x, y, et z doivent avoir la même taille.');
    end

    % Nombre de points
    num_points = numel(x);

    % Initialiser la matrice de distances
    D = zeros(num_points);

    % Calculer la distance entre chaque paire de points
    for i = 1:num_points
        for j = i+1:num_points
            D(i, j) = sqrt((x(i) - x(j))^2 + (y(i) - y(j))^2 + (z(i) - z(j))^2);
            D(j, i) = D(i, j); % La matrice est symétrique  
        end
    end
end