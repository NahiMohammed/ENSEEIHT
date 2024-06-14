clear;
close all;
clc;

load donnees_app;
load donnees_test;

% Données d'apprentissage :
X = X_app;
Y = Y_app;

% Données de test :
X_test = X_test;
Y_test = Y_test;

% Paramètres pour l'affichage des résultats :
lambda_values = linspace(0, 200, 100); % 100 points de λ entre 0 et 100
nb_lambda = length(lambda_values);
classification_results = zeros(nb_lambda, 1);

% Estimation du SVM linéaire (formulation duale) pour différentes valeurs de λ :
for i = 1:nb_lambda
    lambda = lambda_values(i);
    [X_VS,w,c,code_retour] = SVM_2_souple(X,Y, lambda);

    % Si l'optimisation n'a pas convergé :
    if code_retour ~= 1
        continue;
    end

    % Calcul du pourcentage de bonnes classifications des données de test :
    nb_donnees_test = size(X_test, 1);
    nb_classif_OK = 0;
    for j = 1:nb_donnees_test
        x_j = X_test(j,:)';
        prediction = sign(w'*x_j-c);
        if prediction == Y_test(j)
            nb_classif_OK = nb_classif_OK + 1;
        end
    end
    classification_results(i) = nb_classif_OK / nb_donnees_test * 100;
end

% Tracer la courbe des pourcentages de bonnes classifications en fonction de λ :
figure;
plot(lambda_values, classification_results, 'bo-','LineWidth',2);
xlabel('\lambda','FontSize',12);
ylabel('Pourcentage de bonnes classifications','FontSize',12);
title('Résultats de la classification SVM à marge souple','FontSize',14);
grid on;
