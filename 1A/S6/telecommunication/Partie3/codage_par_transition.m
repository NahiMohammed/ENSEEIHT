close all;
clear all;


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
symboles(find(symboles==0))=-1 ;                      % Mapping binaire à moyenne nulle

%----------------------
% Codage par transition
%----------------------
symboles_ck = zeros(1,length(symboles));              % Signal codé par transition
symboles_ck(1) = symboles(1);

for k = 2:length(symboles)
    symboles_ck(k) = symboles(k)*symboles_ck(k-1);
end

%Generation de xe avec codage par transition
impulsions1 = kron(symboles_ck, [1 zeros(1, Ns-1)]);   % Génération des impulsions
xe = filter(h, 1, impulsions1);                        % L'enveloppe complexe

%Generation de xe sans codage par transition
impulsions2 = kron(symboles, [1 zeros(1, Ns-1)]);      % Génération des impulsions
xe_sans_codage_transition= filter(h, 1, impulsions2);  %% L'enveloppe complexe sans codage par transition







Phi = [0;40;100]*pi/180;             % Erreur de phase (rad)
Px = mean(abs(xe).^2);               % Puissance du signal reçu
Eb_N0_db = 0:1:6;                    % Différentes valeur du rapport Eb/N0 en decibel
Eb_N0 = 10.^(Eb_N0_db/10);           % Différentes valeur du rapport Eb/N0
TEB_sans_correction_phase = zeros(length(Phi),length(Eb_N0));                         % Initialisation tableau TEB pour le cas avec codage transition sans correction phase                 
TEB_avec_correction_phase = zeros(length(Phi),length(Eb_N0));                         % Initialisation tableau TEB pour le cas avec codage transition avec correction phase
TEB_avec_correction_phase_sans_codage_transition = zeros(length(Phi),length(Eb_N0));  % Initialisation tableau TEB pour le cas sans codage transition avec correction phase
for k = 1:length(Eb_N0)
    sigma = sqrt((Px*Ns)./ (2*Eb_N0(k)));
    %generation du bruit
    bruit = sigma*randn(1, length(xe)) +(1j*sigma*randn(1, length(xe)));

    %cas aveccodage par transition
    xe_bruite = xe + bruit;                                                %ajout du bruit 
    xe_bruite_dephase = xe_bruite.*exp(1i*Phi);                            %Multiplication par l'erreur de phase porteuse pour les valeurs 0,40 ,100
    
    %cas sans codage par transition
    xe_sans_codage_transition_bruite=xe_sans_codage_transition+bruit;      %ajout du bruit
    xe_sans_codage_transition_bruite_dephase=xe_sans_codage_transition_bruite.*exp(1i*Phi); %Multiplication par l'erreur de phase porteuse pour les valeurs 40 ,100
    
    z = zeros(length(Phi), length(xe_bruite_dephase));
    for l = 1:length(Phi)
        z(l,:) = filter(hr,1,xe_bruite_dephase(l,:));         % reception du signal cas avec codage transition
    end
    
    z2 =zeros(length(Phi), length(xe_sans_codage_transition_bruite_dephase));
    for l = 1:length(Phi)
        z2(l,:) = filter(hr,1,xe_sans_codage_transition_bruite_dephase(l,:));         % reception du signal cas sans codage par transition
    end
    % Echantillonage aux instants optimaux

    %cas avec codage par transition 
    n0 = Ns;                            
    signal_echantillone = z'; 
    signal_echantillone = signal_echantillone(n0:Ns:end);
    signal_echantillone = reshape(signal_echantillone,length(signal_echantillone)/length(Phi), length(Phi))';
    
    %cas sans codage par transition
    signal_echantillone2 = z2';
    signal_echantillone2 = signal_echantillone2(n0:Ns:end);
    signal_echantillone2 = reshape(signal_echantillone2,length(signal_echantillone2)/length(Phi), length(Phi))';

    % Estimation des angles phi
    Phi_estime = 1/2 * angle(sum(signal_echantillone.^2, 2));
    Phi_estime2 = 1/2 * angle(sum(signal_echantillone2.^2, 2));
    % Correction des signaux reçus
    signal_echantillone_corrige = real(signal_echantillone .* exp(-1j*Phi_estime));
    signal_echantillone_corrige2 = real(signal_echantillone2 .* exp(-1j*Phi_estime2));

    %------------------------
    % Decodage par transition
    %------------------------
    ak_estime_sans_correction_phase= zeros(length(Phi), length(symboles)); % Signal codé par transition
    ak_estime_avec_correction_phase= zeros(length(Phi), length(symboles)); % Signal codé par transition
    ak_estime_sans_correction_phase(:,1) = signal_echantillone(:,1);
    ak_estime_avec_correction_phase(:,1) = signal_echantillone_corrige(:,1);
    for l = 2:length(symboles)
        ak_estime_sans_correction_phase(:,l) =signal_echantillone(:,l).*signal_echantillone(:,l-1);
        ak_estime_avec_correction_phase(:,l) =signal_echantillone_corrige(:,l).*signal_echantillone_corrige(:,l-1);
    end

    %calcul TEB cas sans_correction_phase avec codage par transition
    bits_estimes_sans_correction_phase = ak_estime_sans_correction_phase > 0;                                   % dempaping | decision
    TEB_sans_correction_phase(:,k) = sum(bits_estimes_sans_correction_phase ~= repmat(bits,length(Phi),1),2) / nb_bits; % Calcul du taux d'erreur
    
    %calcul TEB cas avec_correction_phase avec codage par transition
    bits_estimes_avec_correction_phase = ak_estime_avec_correction_phase > 0;                                   % dempaping | decision
    TEB_avec_correction_phase(:,k) = sum(bits_estimes_avec_correction_phase ~= repmat(bits,length(Phi),1),2) / nb_bits; % Calcul du taux d'erreur
    
    %calcul TEB cas avec_correction_phase sans codage par transition
    bits_estimes_avec_correction_phase_sans_codege_transition=signal_echantillone_corrige2>0; 
    TEB_avec_correction_phase_sans_codage_transition(:,k) = sum(bits_estimes_avec_correction_phase_sans_codege_transition ~= repmat(bits,length(Phi),1),2) / nb_bits; % Calcul du taux d'erreur
end
TEB_sans_correction_phase
TEB_avec_correction_phase
TEB_avec_correction_phase_sans_codage_transition




%les figure
figure;
plot(Eb_N0_db, TEB_sans_correction_phase(2,:));
hold on;

plot(Eb_N0_db, TEB_sans_correction_phase(3,:));
hold on;

plot(Eb_N0_db, TEB_avec_correction_phase(2,:),'*');
hold on;

plot(Eb_N0_db, TEB_avec_correction_phase(3,:));
hold off;

xlabel 'Eb/No (dB)'
ylabel 'TEB'
legend 'TEB obtenu avec codage par transition sans correction de phase (phi=40)' 'TEB obtenu avec codage par transition sans correction de phase (phi=100)' 'TEB obtenu avec codage par transition avec correction de phase (phi=40)' 'TEB obtenu avec codage par transition avec correction de phase (phi=100)'
title 'Comparaison du TEB obtenu avec codage par transition sans et avec correction de phase '  

figure;
plot(Eb_N0_db, TEB_avec_correction_phase(2,:));
hold on;

plot(Eb_N0_db, TEB_avec_correction_phase(3,:),'*');
hold on;

plot(Eb_N0_db, TEB_avec_correction_phase_sans_codage_transition(2,:));
hold on;

plot(Eb_N0_db, TEB_avec_correction_phase_sans_codage_transition(3,:));
hold off;

xlabel 'Eb/No (dB)'
ylabel 'TEB'
legend 'TEB obtenu avec codage par transition avec correction de phase (phi=40)' 'TEB obtenu avec codage par transition avec correction de phase (phi=100)' 'TEB obtenu sans codage par transition avec correction de phase (phi=40)' 'TEB obtenu sans codage par transition avec correction de phase (phi=100)'
title 'Comparaison du TEB obtenu avec correction de phase  sans et avec codage par transition ' 

















