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


%------------------------------------------------
%cas sans bruit et sans erreur de phase
%------------------------------------------------
signal_recu_1 = filter(hr, 1, xe);                     % Signal reçu

%Decision et Demapping
n0 = Ns;                                               % Instant optimal d'échantillonnage
signal_echantillone= signal_recu_1(n0:Ns:end);         % echantillonage
decision_1=signal_echantillone>0;
TEB_sans_bruit_sans_erreur_phase = sum((decision_1)~=bits)/length(decision_1)

% Tracer la constellation
figure(1);
scatter(real(signal_echantillone), imag(signal_echantillone), 'filled');
xlabel('Partie réelle');
ylabel('Partie imaginaire');
title('Constellation');
grid on;
% %Constellation
% scatterplot(signal_echantillone)


%--------------------------------------------------
%cas sans bruit et avec erreur de phase
%--------------------------------------------------

%dephasage de L'enveloppe avant d'entrer en filtre de récéption
Phi = [40;100;180]*pi/180;                                           % Erreurs de phase (rad)        
signal_dephase = xe.*exp(i*Phi);
z = zeros(length(Phi), length(signal_dephase));
for l = 1:length(Phi)
        z(l,:) = filter(hr,1,signal_dephase(l,:));                   % reception du signal
end
n0 = Ns;                                                             % Echantillonage aux instants optimaux
signal_echantillone = z'; 
signal_echantillone = signal_echantillone(n0:Ns:end);
signal_echantillone = reshape(signal_echantillone,length(signal_echantillone)/length(Phi), length(Phi))';
figure;
for i = 1:length(Phi)
        % Tracer la constellation
        subplot(3,1,i);
        scatter(real(signal_echantillone(i,:)), imag(signal_echantillone(i,:)), 'filled');
        xlabel('Partie réelle');
        ylabel('Partie imaginaire');
        title(sprintf('Constellation (phi=%d)', Phi(i)*(180/pi)));
        grid on;
end

%estimation des bits
bits_estimes = (real(signal_echantillone)>0);

% Calcul du taux d'erreur
TEB_avec_Erreur_Phase_sans_Bruit=sum(bits_estimes ~= repmat(bits,length(Phi),1),2) / length(bits_estimes)


%---------------------------------------
% cas avec bruit et avec erreur de phase
%---------------------------------------
Phi = [0;40;100]*pi/180;                                                     % Erreur de phase (rad)
Px = mean(abs(xe).^2);                                                       % Puissance du signal reçu
Eb_N0_db = 0:1:6;                                                            % Différentes valeur du rapport Eb/N0 en decibel
Eb_N0 = 10.^(Eb_N0_db/10);                                                   % Différentes valeur du rapport Eb/N0
TEB_avec_Erreur_Phase_avec_Bruit = zeros(length(Phi),length(Eb_N0));         % Initialisation tableau TEB 
TEB_Theo = zeros(length(Phi),length(Eb_N0));                                 % Initialisation tableau TEB théorique
for k = 1:length(Eb_N0)
    sigma = sqrt((Px*Ns)./ (2*Eb_N0(k)));
    bruit = (sigma*randn(1, length(xe))) +(1i*sigma*randn(1, length(xe)));
    xe_bruite = xe + bruit;
    xe_bruite_dephase = xe_bruite.*exp(1i*Phi);                              %Multiplication par l'erreur de phase porteuse pour les valeurs 0, 40 ,100
    z = zeros(length(Phi), length(xe_bruite_dephase));
    for k = 1:length(Phi)
        z(k,:) = filter(hr,1,xe_bruite_dephase(k,:));                        % reception du signal
    end
    % Echantillonage aux instants optimaux
    n0 = Ns;                                                           
    signal_echantillone = z'; 
    signal_echantillone = signal_echantillone(n0:Ns:end);
    signal_echantillone = reshape(signal_echantillone,length(signal_echantillone)/length(Phi), length(Phi))';

    %estimation des bits
    bits_estimes = (real(signal_echantillone) > 0);                                   % dempaping | decision
    % Affectation des TEB
    TEB_avec_Erreur_Phase_avec_Bruit(:,k) = sum(bits_estimes ~= repmat(bits,length(Phi),1),2) / nb_bits; 
end


TEB_avec_Erreur_Phase_avec_Bruit

%---------------
%les figures
%---------------

%Calcule des TEB theoriques
for i = 1:length(Phi)
       TEB_Theo(i,:) = qfunc(real(exp(1i*Phi(i)))*sqrt(2*Eb_N0));
end

% Tracé des TEB théoriques et mesurés (phi=40°) en fonction de Eb/N0 en dB
figure,
plot(Eb_N0_db, TEB_Theo(2,:));
hold on;

plot(Eb_N0_db, TEB_avec_Erreur_Phase_avec_Bruit(2,:), ' *- ');
hold off;
ylim([0, 0.5])
xlabel 'Eb/No (dB)'
ylabel 'TEB'
legend 'TEB theorique  (phi=40°)' 'TEB mesure  (phi=40°)'
title '  Tracé des TEB théoriques et mesurés (phi=40°) '

% Tracé des TEB mesurés pour phi=0 et pour phi=40° en fonction de Eb/N0 en dB

figure,
plot(Eb_N0_db, TEB_avec_Erreur_Phase_avec_Bruit(1,:));
hold on;

plot(Eb_N0_db, TEB_avec_Erreur_Phase_avec_Bruit(2,:));
hold off;
xlabel 'Eb/No (dB)'
ylabel 'TEB'
legend 'TEB simule (phi=0°)' 'TEB simule  (phi=40°)'
title '  Tracé des TEB mesurés pour phi=0° et pour phi=40° '

% Tracé des TEB mesurés pour phi=40 et pour phi=100° en fonction de Eb/N0 en dB

figure,
plot(Eb_N0_db, TEB_avec_Erreur_Phase_avec_Bruit(2,:));
hold on;

plot(Eb_N0_db, TEB_avec_Erreur_Phase_avec_Bruit(3,:));
hold off;
xlabel 'Eb/No (dB)'
ylabel 'TEB'
legend 'TEB simule (phi=40°)' 'TEB simule  (phi=100°)'
title '  Tracé des TEB mesurés pour phi=40° et pour phi=100° '










