clear all;
close all;

% Données
Fe = 24000;       % Fréquence d'échantillonnage
Te = 1/Fe;        % Période d'échantiollonnage
Rb = 6000;        % Débit binaire
Tb = 1/Rb;        % Période binaire
M = 2;            % Ordre de la modulation
n = log2(M);      % Nombre de bits par symbole                        
Rs = Rb/n;        % Débit symbole
Ts = 1/Rs;        % Période symbole
Ns = Ts/Te;       % Facteur de suréchantillonnage
h = ones(1, Ns);  % filtre de mise en forme
hr = fliplr(h);   % filtre de réception
nb_bits = 50000;  % Nombre de bits à transmettre

% Gérération de l'information binaire 
bits = randi([0,1], 1, nb_bits);                      %Génération d'une séquence binaire aléatoire de longueur nb_bit
symboles=bits;
symboles(find(symboles==0))=-1   ;                    % Mapping binaire à moyenne nulle
impulsions = kron(symboles, [1 zeros(1, Ns-1)]);      % Génération des impulsions
xe = filter(h, 1, impulsions);                        % L'enveloppe complexe


Phi = [40;100]*pi/180;                                                       % Erreur de phase (rad)
Px = mean(abs(xe).^2);                                                       % Puissance du signal reçu
Eb_N0_db = 0:1:6;                                                            % Différentes valeur du rapport Eb/N0 en decibel
Eb_N0 = 10.^(Eb_N0_db/10);                                                   % Différentes valeur du rapport Eb/N0
TEB_sans_correction = zeros(length(Phi),length(Eb_N0));                      % Initialisation tableau TEB pour le cas sans correction
TEB_avec_correction = zeros(length(Phi),length(Eb_N0));                      % Initialisation tableau TEB pour le cas avec correction
TEB_sans_phase = zeros(1,length(Eb_N0));                                     % Initialisation tableau TEB pour le cas sans erreur phase
for k = 1:length(Eb_N0)
    sigma = sqrt((Px*Ns)./ (2*Eb_N0(k)));
    bruit = (sigma*randn(1, length(xe)))+(1i*sigma*randn(1, length(xe))); 
    xe_bruite = xe + bruit;
    xe_bruite_dephase = xe_bruite.*exp(1i*Phi);                              %Multiplication par l'erreur de phase porteuse pour les valeurs 40 ,100
    z = zeros(length(Phi), length(xe_bruite_dephase));
    for l = 1:length(Phi)
        z(l,:) = filter(hr,1,xe_bruite_dephase(l,:));                        % reception du signal
    end
    signal_recu_sans_phase = filter(hr,1,xe_bruite); 
     % Echantillonage aux instants optimaux
    n0 = Ns;                                                           
    signal_echantillone = z'; 
    signal_echantillone = signal_echantillone(n0:Ns:end);
    signal_echantillone = reshape(signal_echantillone,length(signal_echantillone)/length(Phi), length(Phi))';
    

    signal_echantillone2= signal_recu_sans_phase(n0:Ns:end);         % echantillonage

    %-----------------------------------
    %cas sans erreur de phase 
    %-----------------------------------
    %estimation des bits
    bits_estimes_sans_phase = (real(signal_echantillone2) > 0);
    TEB_sans_phase(k) = sum(bits_estimes_sans_phase ~= bits) / nb_bits;
    
    %------------------------------------
    %sans correction de l'erreur de phase
    %------------------------------------

    %estimation des bits
    bits_estimes_sans_correction = (real(signal_echantillone) > 0); 

    % Affectation des TEB
    TEB_sans_correction(:,k) = sum(bits_estimes_sans_correction ~= repmat(bits,length(Phi),1),2) / nb_bits; 

    %------------------------------------
    %avec correction de l'erreur de phase
    %------------------------------------

    % Estimation des angles phi
    Phi_estime = 1/2 * angle(sum(signal_echantillone.^2, 2));

    % Correction des signaux reçus
    signal_echantillone_corrige = signal_echantillone .* exp(-1i*Phi_estime);

    %estimation des bits
    bits_estimes_avec_correction = (real(signal_echantillone_corrige) > 0); 
    
    % Affectation des TEB
    TEB_avec_correction(:,k) = sum(bits_estimes_avec_correction ~= repmat(bits,length(Phi),1),2) / nb_bits;


end


   TEB_sans_correction
   TEB_sans_phase
   TEB_avec_correction

%les figure
figure;
plot(Eb_N0_db, TEB_avec_correction(1,:));
hold on;

plot(Eb_N0_db, TEB_avec_correction(2,:));
hold on;

plot(Eb_N0_db, TEB_sans_correction(1,:));
hold on;

plot(Eb_N0_db, TEB_sans_correction(2,:));
hold off;

xlabel 'Eb/No (dB)'
ylabel 'TEB'
legend 'TEB simule avec correction de phase porteuse(phi=40°)' 'TEB simule avec correction de phase porteuse(phi=100°)' 'TEB simule sans correction de phase porteuse(phi=40°)' 'TEB simule sans correction de phase porteuse(phi=100°)'
title 'TEB obtenue avec et sans correction de l erreur de phase '    

figure;
plot(Eb_N0_db, TEB_avec_correction(1,:));
hold on;

plot(Eb_N0_db, TEB_avec_correction(2,:));
hold on;

plot(Eb_N0_db, TEB_sans_phase,'--');
hold off;

xlabel 'Eb/No (dB)'
ylabel 'TEB'
legend 'TEB simule avec correction de phase porteuse(phi=40°)' 'TEB simule avec correction de phase porteuse(phi=100°)' 'TEB simule sans erreur erreur de phase'
title 'TEB obtenue avec et sans correction de l erreur de phase ' 








