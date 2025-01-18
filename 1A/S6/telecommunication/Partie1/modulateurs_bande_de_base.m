clear;
close all ;

nb_bits=100;  %nombre de bits à transmettre
Fe=24000;   %la fréquence d'échantillonnage
Te=1/Fe;   %la durée d'échantillonnage
Rb=3000;   %le débit binaire
Tb=1/Rb;  %la durée d'un bit
Nb=Fe/Rb;  %le nombre de bits par symbole



% Etude de modulateurs bande de base

%------------
% modulateur1
%------------

M=2; %nombre de symbole
Rs=Rb/log2(M); %le débit symbole
Ns=Fe/Rs; %le nombre d'échantillons par symbole
N_symb=nb_bits/log2(M); %le nombre de symboles à transmettre
Ts=1/Rs; % période symbole
bits=randi([0,1],1,nb_bits); %Génération d'une séquence binaire aléatoire de longueur nb_bits
%Mapping
symb=bits;
symb(find(symb==0))=-1; %les 0 sont modulés en -1 et les 1 sont modulés en +1

impulsions=[1 zeros(1,Ns-1)]; % impulsion de forme rectangulaire de durée Ns
A=kron(symb,impulsions); %Concaténer les impulsions pour former une séquence d'impulsions
h=ones(1,Ns);
x1=filter(h,1,A); %application du filtre passe-bas pour limiter la bande passante du signal modulé

%tracé du signal généré
T=0:Te:(N_symb*Ns-1)*Te;
figure(1);
plot(T,x1);
xlabel("temps(s)");
ylabel("x1");
title("tracé du signal généré pour M1");

% tracé de la densité spectrale de puissance estimee et theorique
DSP_estime=pwelch(x1,[],[],[],Fe,'twosided');
frequence1=linspace(-Fe/2,Fe/2,length(DSP_estime));
DSP_theo =(1/Ts) *abs(fft(h,length(frequence1))).^2;
figure(2);

semilogy(frequence1,fftshift(DSP_estime/max(DSP_estime)));
hold on ;
semilogy(frequence1,fftshift(DSP_theo/max(DSP_theo)));
xlabel("L'échelle fréquentielle  en Hz");
ylabel("DSP du signal x1");
legend('DSP estimée', 'DSP théorique');
title("Comparaison du DSP pour M1");

%------------
% modulateur2
%------------

M=4; %nombre de symbole
Rs=Rb/log2(M); %le débit symbole
Ts=1/Rs; % période symbole
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
x2=filter(h,1,B); %application du filtre passe-bas pour limiter la bande passante du signal modulé

%tracé du signal généré
T=0:Te:(N_symb*Ns-1)*Te;
figure(3);
plot(T,x2);
xlabel("temps(s)");
ylabel("x2");
title("tracé du signal généré pour M2");

% tracé de la densité spectrale de puissance estimee et theorique
DSP_estime=pwelch(x2,[],[],[],Fe,'twosided');
frequence1=linspace(-Fe/2,Fe/2,length(DSP_estime));

DSP_theo =abs(fft(h,length(frequence1))).^2;
figure(4);

semilogy(frequence1,fftshift(DSP_estime/max(DSP_estime)));
hold on ;
semilogy(frequence1,fftshift(DSP_theo/max(DSP_theo)));
xlabel("L'échelle fréquentielle  en Hz");
ylabel("DSP du signal x2");
legend('DSP estimée', 'DSP théorique');
title("Comparaison du DSP pour M2");

%------------
% modulateur3
%------------

M=2; %nombre de symbole
Rs=Rb/log2(M); %le débit symbole
Ts=1/Rs; % période symbole
Ns=Fe/Rs; %le nombre d'échantillons par symbole
N_symb=nb_bits/log2(M);  %le nombre de symboles à transmettre
alpha=0;  %roll off
L=20;  %longueur de la réponse impulsionnelle de l'impulsion de mise en forme


bits=randi([0,1],1,nb_bits);   %Génération d'une séquence binaire aléatoire de longueur nb_bits

%Mapping
symb=bits;
symb(find(symb==0))=-1; %les 0 sont modulés en -1 et les 1 sont modulés en +1

impulsions=[1 zeros(1,Ns-1)]; % impulsion de forme rectangulaire de durée Ns
A=kron(symb,impulsions); %Concaténer les impulsions pour former une séquence d'impulsions

h=rcosdesign(alpha,L,Ns); %filtre en racine de cosinus surélevé 
x3_0=filter(h,1,A);
m=floor(L*Ns/2);
x3=circshift(x3_0,length(x3_0)-m);
x3(length(x3)-m:length(x3))=0;

%tracé du signal généré
T=0:Te:(N_symb*Ns-1)*Te;
figure(5);
plot(T,x3);
xlabel("temps(s)");
ylabel("x3");
title("tracé du signal généré pour M3");

% tracé de la densité spectrale de puissance estimee et theorique

DSP_estime=pwelch(x3,[],[],[],Fe,'twosided');
frequence1=linspace(-Fe/2,Fe/2,length(DSP_estime));

DSP_theo =abs(fft(h,length(frequence1))).^2;
figure(6);

semilogy(frequence1,fftshift(DSP_estime/max(DSP_estime)));
hold on ;
semilogy(frequence1,fftshift(DSP_theo/max(DSP_theo)));
xlabel("L'échelle fréquentielle  en Hz");
ylabel("DSP du signal x3");
legend('DSP estimée', 'DSP théorique');
title("Comparaison du DSP pour M3");