load fichier1.mat;
morceau1 = reconstitution_image(demoduler(signal));
load fichier2.mat;
morceau2 = reconstitution_image(demoduler(signal));
load fichier3.mat;
morceau3 = reconstitution_image(demoduler(signal));
load fichier4.mat;
morceau4 = reconstitution_image(demoduler(signal));
load fichier5.mat;
morceau5 = reconstitution_image(demoduler(signal));
load fichier6.mat;
morceau6 = reconstitution_image(demoduler(signal));
T = [morceau6 morceau1 morceau5;
    morceau2 morceau4 morceau3];
image(T)