LISTE DES CODES FOURNIS

--->fichier1: ce code contient le modulateur et le démodulateur par filtrage
avec un ordre égal à 61, F0=6000 et F1=2000

--->fichier2: ce code contient le modulateur et le démodulateur par filtrage
avec un ordre égal à 201, F0=1180 et F1=980

--->fichier3: ce code contient le modulateur et le démodulateur par un récepteur 
dans un contexte de synchronisation idéale avec F0=1180 et F1=980

--->fichier4: ce code contient le modulateur et le démodulateur par un récepteur 
avec gestion de l'erreur de synchronisation de phase porteuse avec F0=1180 et F1=980

--->demoduler: C'est une fonction qui a comme parametre un signal modulé et qui retourne un signal demodulé en implantant le Démodulateur de fréquence adapté à la norme V21

--->imageee : ce code permet de reconstituer les 6 morceaux a partir des fichiers (f1,f2,f3,f4,f5,f6) et de les regrouper afin d'obtenir une image 