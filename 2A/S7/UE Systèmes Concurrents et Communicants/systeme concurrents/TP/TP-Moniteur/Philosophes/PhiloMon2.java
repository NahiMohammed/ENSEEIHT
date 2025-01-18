import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class PhiloMon2 implements StrategiePhilo {

    private enum EtatPhilosophe { Pense, Demande, Mange }

    private EtatPhilosophe[] etat;
    private Lock mutex;
    private Condition[] conditionPriorite;
    private long[] tempsAttente;

    public PhiloMon2(int nbPhilosophes) {
        this.etat = new EtatPhilosophe[nbPhilosophes];
        this.mutex = new ReentrantLock();
        this.conditionPriorite = new Condition[nbPhilosophes];
        this.tempsAttente = new long[nbPhilosophes];

        for (int i = 0; i < nbPhilosophes; i++) {
            etat[i] = EtatPhilosophe.Pense;
            conditionPriorite[i] = mutex.newCondition();
            tempsAttente[i] = 0;
        }
    }

    public void demanderFourchettes(int no) throws InterruptedException {
        mutex.lock();
        try {
            etat[no] = EtatPhilosophe.Demande;
            tempsAttente[no] = System.currentTimeMillis();

            // Attendre la priorité basée sur le temps d'attente
            while (!peutManger(no, tempsAttente[no])) {
                conditionPriorite[no].await();
            }

            etat[no] = EtatPhilosophe.Mange;
            tempsAttente[no] = 0; // Réinitialiser le temps d'attente
            IHMPhilo.poser(Main.FourchetteGauche(no), EtatFourchette.AssietteDroite);
            IHMPhilo.poser(Main.FourchetteDroite(no), EtatFourchette.AssietteGauche);
        } finally {
            mutex.unlock();
        }
    }

    public void libererFourchettes(int no) {
        mutex.lock();
        try {
            IHMPhilo.poser(Main.FourchetteGauche(no), EtatFourchette.Table);
            IHMPhilo.poser(Main.FourchetteDroite(no), EtatFourchette.Table);
            etat[no] = EtatPhilosophe.Pense;

            // Réveiller les philosophes voisins pour qu'ils puissent obtenir la priorité
            conditionPriorite[(no + 1) % etat.length].signal();
            conditionPriorite[(no - 1) % etat.length].signal();
        } finally {
            mutex.unlock();
        }
    }

    public String nom() {
        return "Moniteur avec Priorité basée sur le Temps d'Attente";
    }

    private boolean peutManger(int no, long tempsDebutAttente) {
        // Vérifier si aucun voisin ne mange avec une priorité basée sur le temps d'attente
        int voisinGauche = (no - 1) % etat.length;
        int voisinDroite = (no + 1) % etat.length;
        return (etat[voisinGauche] != EtatPhilosophe.Mange && tempsAttente[voisinGauche] < tempsDebutAttente) &&
               (etat[voisinDroite] != EtatPhilosophe.Mange && tempsAttente[voisinDroite] < tempsDebutAttente);
    }
}
