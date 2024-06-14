%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Partie 4
clear;
close all ;

nb_bits=50;  %nombre de bits à transmettre
Fe=24000;   %la fréquence d'échantillonnage
Te=1/Fe;   %la durée d'échantillonnage
Rb=3000;   %le débit binaire
Tb=1/Rb;  %la durée d'un bit
Nb=Fe/Rb;  %le nombre de bits par symbole

%Etude de chaque chaine de transmission
  
    %Chaine 3


%Sans bruit

%modulateur2

M=4; %nombre de symbole
Rs=Rb/log2(M); %le débit symbole
Ns=Fe/Rs; %le nombre d'échantillons par symbole
N_symb=nb_bits/log2(M); %le nombre de symboles à transmettre

bits=randi([0,1],1,nb_bits); %Génération d'une séquence binaire aléatoire de longueur nb_bits

%Mapping
V=1;  % la tension de modulation
A=reshape(bits,N_symb,2);  %transformer la séquence de bits en une matrice de taille N_symb x 2, où chaque ligne correspond à un symbole

% 00->-3V / 01->-V / 10->+V / 11->+3V
symb=-3*V*(A(:,1)==0&A(:,2)==0) -V*(A(:,1)==0&A(:,2)==1) +V*(A(:,1)==1&A(:,2)==0) +3*V*(A(:,1)==1&A(:,2)==1);

impulsions=[1 ,zeros(1,Ns-1)]; % impulsion de forme rectangulaire de durée Ns
B=kron(symb',impulsions);  %Concaténer les impulsions pour former une séquence d'impulsions
h=ones(1,Ns);
x=filter(h,1,B); %application du filtre passe-bas pour limiter la bande passante du signal modulé

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
z_echant=z(T_echant(1:length(nb_bits)));
  %Decisions
decision=z_echant>0;
erreur =length(find(decision~=bits));
teb_1 = erreur/length(bits);




%Avec bruit

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

Rapport_signal_bruit = [10^0 10^1 10^2 10^3 10^4 10^5 10^6 10^7 10^8];
teb_simulation = length(Rapport_signal_bruit);
for i=1:length(Rapport_signal_bruit)
     sigma = sqrt(Px*Ns/(2*log2(M)*Rapport_signal_bruit(i)));
     r = x + sigma * randn(1,length(x));
     
     %%Demodulation
       %%filtre de reception
     z=filter(h,1,r);
     %Determination de n0
     t0=Tb;
     n0=t0*Fe;   % Ts=1/Rb et Ns=Fe/Rb=Fe*Ts       et t0 --> Ts donc n0 --> Ns

     % trace du diagramme de l'oeil en sortie du filtre de reception
     figure (i+10);
     plot(reshape(z,Ns,length(z)/Ns));
     title("tracé du diagramme de l'oeil pour Rapport_signal_bruit = 10^" + (i-1));

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