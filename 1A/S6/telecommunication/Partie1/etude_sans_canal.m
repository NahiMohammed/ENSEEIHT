
%-----------
% Partie 3 
%-----------


clear;
close all ;

nb_bits=50;  %nombre de bits à transmettre
Fe=24000;   %la fréquence d'échantillonnage
Te=1/Fe;   %la durée d'échantillonnage
Rb=3000;   %le débit binaire
Tb=1/Rb;  %la durée d'un bit
Nb=Fe/Rb;  %le nombre de bits par symbole

%--------------------------------
% Etude sans canal de propagation
%--------------------------------

     %------------
     % Modulation
     %------------

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


     %------------
     % Canal de propagation
     %------------

r=x;

     %------------
     % demodulation
     %------------


%%filtre de reception
z=filter(h,1,r);

%tracé du signal z
T=0:Te:(N_symb*Ns-1)*Te;
figure(1);
plot(T,z);
xlabel("le temps(s)");
ylabel("le signal x_recep(t)");
title("tracé du signal du sortie du filtre de reception");

%tracé du réponse impulsionnelle globale de la chaine 
g=conv(h,h);
T_g=0:Te:(length(g)-1)*Te;
figure(2);
plot(T_g,g);
xlabel("temps");
ylabel("g");
title("tracé du réponse impulsionnelle globale de la chaine en fonction du temps");

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
teb_1 = erreur/length(bits);

%MODIFICATION DE n0
n0=3;

% retrouver les symboles

  %Echantilloneur
T_echant=n0:Ns:(n0+nb_bits*Ns)-1;  
z_echant=z(T_echant);
  %Decisions
decision=z_echant>0;
erreur =length(find(decision~=bits));
teb_2 = erreur/length(bits);



%-------------------------------------------
% Etude avec canal de propagation sans bruit
%-------------------------------------------



%Trace de la reponse impulsionnelle globale de la chaine de transmission

fc=8000;
ordre=201;
T1=linspace(-(ordre-1)/2,(ordre-1)/2,ordre);
h_bas=2*(fc/Fe)*sinc(2*(fc/Fe)*T1);

g=conv(conv(h,h),h_bas);
T1=0:Te:(length(g)-1)*Te;
figure(4);
plot(T1,g);
xlabel("le temps (s)");
ylabel("le réponse g(t)");
title("tracé du réponse impulsionnelle globale de la chaine ");

%Trace du diagramme de l'oeil a la sortie du filtre de reception
Deph=floor((ordre-1)/2);
x2 = zeros(1,length(x)+Deph);
x2(1:length(x))=x;
r=filter(h_bas,1,x2);
r=r(Deph+1:end);
z=filter(h,1,r);
figure(20);
plot(z)
figure (5);
plot(reshape(z,Ns,length(z)/Ns));
title("tracé du diagramme de l'oeil");

%Trace des réponse en frequence 
frequence1=linspace(-Fe/2,Fe/2,1024);
Hr=fft(h,length(frequence1));
Hc=fft(h_bas,length(frequence1));
H=fft(h,length(frequence1));
figure(6);
semilogy(frequence1,fftshift(abs(H.*Hr)));
hold on
semilogy(frequence1, fftshift(abs(Hc)));
xlabel("L'échelle fréquentielle  en Hz");
legend('abs(H.*Hr)', 'abs(Hc)');
title("Trace des réponse en frequence");

%TEB
t0=Tb;
n0=t0*Fe;   % Ts=1/Rb et Ns=Fe/Rb=Fe*Ts       et t0 --> Ts donc n0 --> Ns

% retrouver les symboles

  %Echantilloneur
T_echant=n0:Ns:(n0+nb_bits*Ns)-1;  
z_echant=z(T_echant);
  %Decisions
decision=z_echant>0;
erreur =length(find(decision~=bits));
teb_3 = erreur/length(bits);
