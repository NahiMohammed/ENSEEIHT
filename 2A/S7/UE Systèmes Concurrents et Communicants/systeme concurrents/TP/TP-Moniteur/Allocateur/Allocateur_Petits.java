// Time-stamp: <28 oct 2022 10:31 queinnec@enseeiht.fr>
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.Condition;

public class Allocateur_Petits implements Allocateur {

    // Nombre total de ressources.
    private final int nbRessources;

    // Nombre de ressources actuellement disponibles
    private int nbLibres;

    // Protection des variables partagées
    private Lock moniteur;

    // Une condition de blocage par taille de demande
    // tableau [nbRessources+1] dont on n'utilise pas la case 0
    private Condition[] classe;

    // Le nombre de processus en attente à chaque étage
    // tableau [nbRessources+1] dont on n'utilise pas la case 0
    private int[] tailleClasse;

    /** Initilialise un nouveau gestionnaire de ressources pour nbRessources. */
    public Allocateur_Petits(int nbRessources) {
        this.nbRessources = nbRessources;
        this.nbLibres = nbRessources;
        this.moniteur = new ReentrantLock();
        this.classe = new Condition[nbRessources + 1];
        this.tailleClasse = new int[nbRessources + 1];

        for (int i = 1; i <= nbRessources; i++) {
            classe[i] = moniteur.newCondition();
            tailleClasse[i] = 0;
        }
    }

    /** Demande à obtenir `demande' ressources. */
    public void allouer(int demande) throws InterruptedException {
        moniteur.lock();
        try {
            // Votre code ici
            while (nbLibres < demande) {
                classe[demande].await();
            }

            // Réduire le nombre de ressources disponibles
            nbLibres -= demande;
        } finally {
            moniteur.unlock();
        }
    }

    /** Libère `rendu' ressources. */
    public void liberer(int rendu) throws InterruptedException {
        moniteur.lock();
        try {
            // Votre code ici
            nbLibres += rendu;

            // Réveiller les processus en attente de ressources
            for (int i = 1; i <= rendu; i++) {
                classe[i].signal();
            }
        } finally {
            moniteur.unlock();
        }
    }

    /** Chaîne décrivant la stratégie d'allocation. */
    public String nomStrategie() {
        return "Priorité aux petits demandeurs";
    }
}

