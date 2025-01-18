clear;
close all;
clc;

% Paramètres pour l'affichage des données :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

load donnees_app;

% Données non filtrées :
X = X_app;
Y = Y_app;

% Paramètres d'affichage :
pas = 0.0002;
marge = 0.005;
valeurs_carac_1 = min(min(X(:,1)))-marge:pas:max(max(X(:,1)))+marge;
valeurs_carac_2 = min(min(X(:,2)))-marge:pas:max(max(X(:,2)))+marge;
limites_affichage = [valeurs_carac_1(1) valeurs_carac_1(end) ...
                     valeurs_carac_2(1) valeurs_carac_2(end)];
nom_carac_1 = 'Compacite';
nom_carac_2 = 'Contraste';

% Valeurs de sigma à tester :
valeurs_sigma = linspace(0.00001, 0.015, 100);

% Pourcentage de bonnes classifications pour chaque valeur de sigma :
pourcentages_classification = zeros(1, length(valeurs_sigma));

% Boucle sur les différentes valeurs de sigma :
for k = 1:length(valeurs_sigma)
    sigma = valeurs_sigma(k);

    % Estimation du SVM avec noyau gaussien :
    [X_VS,Y_VS,Alpha_VS,c,code_retour] = SVM_3(X,Y,sigma);

    % Si l'optimisation n'a pas convergé :
    if code_retour ~= 1
        continue;
    end

    % Pourcentage de bonnes classifications des données de test :
    load donnees_test;
    nb_donnees_test = size(X_test,1);
    nb_classif_OK = 0;
    for i = 1:nb_donnees_test
        x_i = X_test(i,:);
        prediction = sign(exp(-sum((X_VS-x_i).^2,2)/(2*sigma^2))'*diag(Y_VS)*Alpha_VS-c);
        if prediction == Y_test(i)
            nb_classif_OK = nb_classif_OK + 1;
        end
    end
    pourcentages_classification(k) = double(nb_classif_OK/nb_donnees_test*100);
end

% Affichage de la performance en fonction des différentes valeurs de sigma :
figure('Name','Performance de la SVM à noyau gaussien','Position',[0.2*L,0.1*H,0.6*L,0.7*H]);
plot(valeurs_sigma, pourcentages_classification, 'bo-', 'LineWidth', 2);
xlabel('Valeur de sigma','FontSize', 12);
ylabel('Pourcentage de bonnes classifications des données de test','FontSize', 12);
set(gca,'FontSize',10);
ylim([0 100]); % Axe des ordonnées de 0 à 100
grid on;
