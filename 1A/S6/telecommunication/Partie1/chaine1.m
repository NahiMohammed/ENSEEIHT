P=[1 0 1;1 1 1;1 1 0;0 1 1];
G=[eye(4),P];
h=[P',eye(3)];
C=mod(G*h', 2);
%-----------
% Partie 4
%-----------


clear;
close all ;

nb_bits=1000;  %nombre de bits à transmettre
Fe=24000;   %la fréquence d'échantillonnage
Te=1/Fe;   %la durée d'échantillonnage
Rb=3000;   %le débit binaire
Tb=1/Rb;  %la durée d'un bit
Nb=Fe/Rb;  %le nombre de bits par symbole

%Etude de chaque chaine de transmission
    % Chaine 1

    %------------
    % Sans bruit
    %------------


%Modulation

M=2; %nombre de symbole
Rs=Rb/log2(M); %le de sans canal de propagationébit symbole
Ns=Fe/Rs; %le nombre d'échantillons par symbole
N_symb=nb_bits/log2(M); %le nombre de symboles à transmettre

bits=randi([0,1],1,nb_bits); %Génération d'une séquence binaire aléatoire de longueur nb_bits

%Mapping
symb=bits;
symb(find(symb==0))=-1; %les 0 sont modulés en -1 et les 1 sont modulés en +1

impulsions=[1 zeros(1,Ns-1)]; % impulsion de forme rectangulaire de durée Ns
A=kron(symb,impulsions); %Concaténer les impulsions pour former une séquence d'impulsions
h=ones(1,Ns);
x=filter(h,1,A); %application du filtre passe-bas pour limiter la bande passante du signal modulé

%%Canal de propagation
r=x;



%%Demodulation

%%filtre de reception
z=filter(h,1,r);

%tracé du signal z
T=0:Te:(N_symb*Ns-1)*Te;
figure(1);
plot(T,z);
xlabel("le temps(s)");
ylabel("le signal x_recep(t)");
title("tracé du signal du sortie du filtre de reception");


%Determination de n0
t0=Tb;
n0=t0*Fe;   % Ts=1/Rb et Ns=Fe/Rb=Fe*Ts       et t0 --> Ts donc n0 --> Ns

% trace du diagramme de l'oeil en sortie du filtre de reception
figure (3);
plot(reshape(z,Ns,length(z)/Ns));
title("tracé du diagramme de l'oeil");

% retrouver les symboles

  %Echantilloneur
T_echant=n0:Ns:(n0+nb_bits*Ns)-1; 
z_echant=z(T_echant);
  %Decisions
decision=z_echant>0;
erreur =length(find(decision~=bits));
teb_sans_bruit = erreur/length(bits);




    %------------
    % Avec bruit
    %------------

%Modulation

M=2; %nombre de symbole
Rs=Rb/log2(M); %le de sans canal de propagationébit symbole
Ns=Fe/Rs; %le nombre d'échantillons par symbole
N_symb=nb_bits/log2(M); %le nombre de symboles à transmettre

bits=randi([0,1],1,nb_bits); %Génération d'une séquence binaire aléatoire de longueur nb_bits

%Mapping
symb=bits;
symb(find(symb==0))=-1; %les 0 sont modulés en -1 et les 1 sont modulés en +1

impulsions=[1 zeros(1,Ns-1)]; % impulsion de forme rectangulaire de durée Ns
A=kron(symb,impulsions); %Concaténer les impulsions pour former une séquence d'impulsions
h=ones(1,Ns);
x=filter(h,1,A); %application du filtre passe-bas pour limiter la bande passante du signal modulé

%%Canal de propagation

Px = mean(abs(x).^2);

%Rapport_signal_bruit = [10^0 10^1 10^2 10^3 10^4 10^5 10^6 10^7 10^8];  %% Eb/N0
SNRdB = [0 1 2 3 4 5 6 7 8];
EbN0 = 10.^(SNRdB/10); %% SNRdB = 10 log_10(Psignal/Pbruit) et  Eb/N0 = Psignal/Pbruit
EbN1 = 10.^(SNRdB);
teb_simulation = zeros(1,length(EbN0));
for i=1:length(EbN0)
     sigma = sqrt(Px*Ns/(2*log2(M)*EbN0(i)));
     sigma_diag_oeil = sqrt(Px*Ns/(2*log2(M)*EbN1(i)));
     r = x + sigma * randn(1,length(x));
     r_diag_oeil = x + sigma_diag_oeil * randn(1,length(x));
     z_diag_oeil=filter(h,1,r_diag_oeil);
     %%Demodulation
       %%filtre de reception
     z=filter(h,1,r);
     %Determination de n0
     t0=Tb;
     n0=t0*Fe;   % Ts=1/Rb et Ns=Fe/Rb=Fe*Ts       et t0 --> Ts donc n0 --> Ns

     % trace du diagramme de l'oeil en sortie du filtre de reception
     figure (i+10);
     plot(reshape(z_diag_oeil,Ns,length(z)/Ns));
     title("tracé du diagramme de l'oeil pour Eb/N0 = 10^" + SNRdB(i));

     % retrouver les symboles

      %Echantilloneur
      T_echant=n0:Ns:(n0+nb_bits*Ns)-1; 
      z_echant=z(T_echant);
      %Decisions
      decision=z_echant>0;
      erreur =length(find(decision~=bits));
      teb = erreur/length(bits);
      teb_simulation(i) = teb;

end
teb_simulation
