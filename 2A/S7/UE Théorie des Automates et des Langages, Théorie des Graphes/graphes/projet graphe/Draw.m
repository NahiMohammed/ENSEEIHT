function Draw(adjMatrix, xCoords, yCoords, zCoords, density, distance)
    % Ouvrir une nouvelle figure pour le tracé
    figure;
    
    % Tracer les positions des satellites en 3D
    scatter3(xCoords, yCoords, zCoords, 'filled');
    hold on; % Maintenir la figure pour ajouter d'autres éléments graphiques

    % Tracer des lignes entre les satellites connectés
    numSatellites = length(xCoords);
    for i = 1:numSatellites
        for j = i + 1:numSatellites
            if adjMatrix(i, j)
                % Dessiner une ligne entre les satellites i et j
                plot3([xCoords(i), xCoords(j)], [yCoords(i), yCoords(j)], [zCoords(i), zCoords(j)], 'k-');
            end
        end
        % Ajouter un texte à côté de chaque satellite
        text(xCoords(i) + 5, yCoords(i), zCoords(i), num2str(i), 'FontSize', 8);
    end

    % Configurer le titre et les étiquettes des axes
    title(['Essaim de nanosatellites - Densité : ' density ', Portée : ' num2str(distance) ' km']);
    xlabel('Position X');
    ylabel('Position Y');
    zlabel('Position Z');

    % Activer la grille pour une meilleure lisibilité
   grid on;
end