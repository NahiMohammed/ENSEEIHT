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

% %partie 5:Démodulation par filtrage

     %5.1:Synthèse du filtre passe-bas
fc=(F0+F1)/2; %frequence de coupure 
Ordre=201;   
hPb=2*(fc/Fe)*sinc(2*(fc/Fe)*[-(Ordre-1)/2:(Ordre-1)/2]);
figure(7)
plot(hPb);
xlabel('temps');
ylabel('hPb');
title("la réponse en fréquence du filtre passe-bas")

     %5.2:Synthèse du filtre passe-haut 
fc2=fc; %frequence de coupure 
hPb0=2*(fc/Fe)*sinc(2*(fc2/Fe)*[-(Ordre-1)/2:(Ordre-1)/2]);
hPh=-hPb0;
hPh((Ordre-1)/2+1)=1-2*fc2/Fe;
figure(8)
plot(hPh);
xlabel('temps');
ylabel('hPh');
title("la réponse en fréquence du filtre passe-haut")
   %%5,2
DSPx=pwelch(hPb,[],[],[],Fe,'twosided');
f=linspace(-Fe/2,Fe/2,length(hPb));
figure(9)
semilogy(f,fftshift((hPb.^2)/Ordre)); 
xlabel('frequence');
ylabel('Dsp');
  
    %5.3 Filtrage 
        %filtrage passe bas 
signal_filtre=filter(hPb,1,signal_final);
figure(10)
hold on
subplot(3,1,1);
plot(t,signal_filtre);
xlabel("temps en s");
ylabel("le signal filtré avec passe bas");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,1,2);
plot(t,signal_final); %tracage du signal final
xlabel("temps en s");
ylabel("le signal bruité");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
yfilter=filter(hPb,1,[signal_final zeros(1, (Ordre-1)/2)]);
signal_filtre=yfilter((Ordre-1)/2+1:end);
        %filtrage passe haut 
y1=filter(hPh,1,signal_final);
subplot(3,1,3);
plot(t,y1);
xlabel("temps en s");
ylabel("le signal filtré avec passe haut");
hold off


    %5.5:detection d'energie
L=length(signal_filtre)/Ns;
S= reshape(signal_filtre,Ns,L);
energie1=sum(abs(S.^2));
k=(max(energie1)-min(energie1))/2;


energie=sum(abs(S.^2))>k;
nbr_bits_err=zeros(1,L);
nbr_bits_err(find(energie))=1;


   

 %calcul taux d'erreur

erreurs= length(find(nbr_bits_err~=bits)); 
Teb= erreurs/L %taux d'erreur binaire obtenu  

