clc;
clear all;
close all;

% Constantes
F0=1180;
F1=980;


Fe=48000; % frequence d'echantionnage
Te=1/Fe;  % periode d'echantionnage
Rb=300;
Ts=1/Rb;
Ns=floor(Ts/Te); %nombre d'echantillon
phi0=rand*2*pi;  %variable aleatoire uniformement reparties sur [0.2pi]
phi1=rand*2*pi;%variable aleatoire uniformement reparties sur [0.2pi]



%generation de l'information binaire a transmettre 

nb_bits=1000;
bits=randi([0,1],1,nb_bits);  %dans le cas fichier load fichieri


%PARTIE 3  : Modem de fréquence
   %3.1:Génération du signal NRZ

       %Q1:Génération du signal NRZ
NRZ=kron(bits,ones(1,Ns)); %signal de type NRZ unipolaire formé à partir de la suite de bits à transmettre
      
       %Q2:tracage du signal NRZ

       
N=length(NRZ);
t=[0:Te:(N-1)*Te];
figure(1)
plot(t,NRZ);
xlabel('temps');
ylabel('NRZ');
title('le signal NRZ en fonction du temps')


       %Q3:la densité spectrale de puissance du signal NRZ
DSP=pwelch(NRZ,[],[],[],Fe,'twosided'); %estimation de la densité spectrale de puissance du signal NRZ
f=linspace(-Fe/2,Fe/2,length(DSP));
figure(2)
semilogy(f,fftshift(DSP)); %tracage de la densité spectrale de puissance du signal NRZ estime 
xlabel("fréquence en Hz");
ylabel("la densité spectrale de puissance du signal NRZ");

       %Q4:comparaison entre la densité spectrale de puissance estimée et théorique

figure(3)
semilogy(f,fftshift(DSP));  hold on;
Snrz=(Ts/4)*(sinc(Ts*f).^2)+(1/4)*dirac(f); %densité spectrale de puissance théorique
semilogy(f,Snrz);
legend('DSP','Snrz')
xlabel("fréquence en Hz");
ylabel("la densité spectrale de puissance du signal NRZ");



   %3.2:Génération du signal modulé en fréquence

       %Q1: génération du signal modulé en fréquence
x0=(1-NRZ).*cos(2*pi*F0*t+phi0);
x1=NRZ.*cos(2*pi*F1*t+phi1);
x=x0+x1;  %Le signal modulé en fréquence x(t)

       %Q2:Tracage du signal x(t) avec une échelle temporelle en secondes
figure(4)
plot(t,x); %tracage du signal modulé en fréquence 
xlabel("temps en s");
ylabel("Signal modulé en fréquence");
title("le signal x(t) avec une échelle temporelle en secondes ");

     %Q4:la densité spectrale de puissance du signal x(t)

figure(5)
DSPx=pwelch(x,[],[],[],Fe,'twosided');%estimation de la densité spectrale de puissance du signal modulé en fréquence
f=linspace(-Fe/2,Fe/2,length(DSPx));
semilogy(f,fftshift(abs(DSPx)));
xlabel("fréquence en Hz");
ylabel("la densité spectrale de puissance du signal x(t)");
title("densité spectrale de puissance du signal x(t) avec une échelle temporelle en s");

%partie 4:Canal de transmission à bruit additif, blanc et Gaussien


Px=mean(abs(x).^2); %puissance du signal module en frequence 
SNRdb=50;  %rapport signal sur bruit
Pb=Px/(10^(SNRdb/10)); % la puissance du bruit ajouté
sigma=sqrt(Pb);
bruit=sigma*randn(1,N);  % N=length(NRZ)
figure(6)

signal_final=x+bruit;
plot(t,signal_final); %tracage du signal final
xlabel("temps en s");
ylabel("le signal bruité");
title("le signal bruité en fonction du temps");



%PARTIE 6: DEMODULATION DE FREQUENCE ADAPTE A LA NORME V21
     %6.1

%implantation d'une erreur de phase porteuse
phi00=rand*2*pi;  
phi11=rand*2*pi;



h0=signal_final.*cos(2*pi*F0*t+phi00); 
h1=signal_final.*cos(2*pi*F1*t+phi11); 
L=length(h0)/Ns;
S0= reshape(h0,Ns,L);
integ0=sum(S0);  
S1= reshape(h1,Ns,L);
integ1=sum(S1); 
z=integ1-integ0;


%calcul taux d'erreur apres imtroduction d'une erreur de la phase porteuse
energie11=z>0;
nbr_bits_err=zeros(1,L);
nbr_bits_err(find(energie11))=1;
erreurs= length(find(nbr_bits_err~=bits)); 
Teb_V21 = erreurs/L
    
    %6.2: GESTION D'UNE ERREUR DE SYNCHRONISATION DE PHASE PORTEUSE 

%implantation d'une erreur de phase porteuse
phi00=rand*2*pi;  
phi11=rand*2*pi;



h00=signal_final.*cos(2*pi*F0*t+phi00); 
h01=signal_final.*sin(2*pi*F0*t+phi00); 

h10=signal_final.*cos(2*pi*F1*t+phi11); 
h11=signal_final.*sin(2*pi*F1*t+phi11); 

L=length(h00)/Ns;
S00= reshape(h00,Ns,L);
integ00=sum(S00);

S01= reshape(h01,Ns,L);
integ01=sum(S01);

S10= reshape(h10,Ns,L);
integ10=sum(S10);

S11= reshape(h11,Ns,L);
integ11=sum(S11);

z0=integ01.^2+integ00.^2;
z1=integ11.^2+integ10.^2;

z2=z1-z0;

%calcul taux d'erreur apres la gestion de l'erreur de SYNCHRONISATION DE la PHASE PORTEUSE 
energie22=z2>0;
   
nbr_bits_err=zeros(1,L);
nbr_bits_err(find(energie22))=1;
erreurs= length(find(nbr_bits_err~=bits)); 
Teb_V21_avec_gestion = erreurs/L   %taux d'erreur binaire obtenu