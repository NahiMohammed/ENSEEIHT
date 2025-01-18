function [sortie] = demoduler(signal_final)
F0=1180;%6000
F1=980;%2000
Rb=300;
Fe=48000; % frequence d'echantionnage
Te=1/Fe;
Ts=1/Rb;
Ns=floor(Ts/Te);
N=length(signal_final);
t=[0:Te:(N-1)*Te];


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
energie22=z2>0;
sortie=zeros(1,L);
sortie(find(energie22))=1;
end

