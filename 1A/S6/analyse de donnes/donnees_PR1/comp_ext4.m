clear;
close all;
clc;

load donnees_app;
load donnees_test;

% Paramètres pour la recherche exhaustive
nb_points_lambda = 100; % Nombre de points pour lambda
nb_points_sigma = 100; % Nombre de points pour sigma
lambda_min = 1; % Valeur minimale de lambda
lambda_max = 10000; % Valeur maximale de lambda
sigma_min = 0.001; % Valeur minimale de sigma
sigma_max = 0.8; % Valeur maximale de sigma

% Initialisation des variables
meilleur_pourcentage = 0;
meilleur_lambda = 0;
meilleur_sigma = 0;

% Recherche exhaustive des paramètres optimaux
for lambda = linspace(lambda_min, lambda_max, nb_points_lambda)
    for sigma = linspace(sigma_min, sigma_max, nb_points_sigma)
        % Estimation du SVM avec noyau gaussien
        [X_VS, Y_VS, ~, c, ~] = SVM_3_souple(X_app, Y_app, sigma, lambda);
        
        % Pourcentage de bonnes classifications des données de test
        nb_donnees_test = size(X_test, 1);
        nb_classif_OK = 0;
        for i = 1:nb_donnees_test
            x_i = X_test(i, :);
            prediction = sign(exp(-sum((X_VS - x_i).^2, 2)/(2*sigma^2))' * diag(Y_VS) * c);
            if prediction == Y_test(i)
                nb_classif_OK = nb_classif_OK + 1;
            end
        end
        pourcentage = nb_classif_OK / nb_donnees_test * 100;
        
        % Mise à jour des paramètres optimaux
        if pourcentage > meilleur_pourcentage
            meilleur_pourcentage = pourcentage;
            meilleur_lambda = lambda;
            meilleur_sigma = sigma;
        end
    end
end

% Affichage des résultats
fprintf('Pourcentage de bonnes classifications des données de test (optimal) : %.1f %%\n', meilleur_pourcentage);
fprintf('Lambda optimal : %.2f\n', meilleur_lambda);
fprintf('Sigma optimal : %.3f\n', meilleur_sigma);
