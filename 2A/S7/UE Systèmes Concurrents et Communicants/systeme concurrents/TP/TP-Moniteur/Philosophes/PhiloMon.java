import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.Condition;

public class PhiloMon implements StrategiePhilo {

    private EtatPhilosophe[] etat;
    private Lock verrou;
    private Condition[] conditionPhilosophes;

    public PhiloMon(int nbPhilosophes) {
        this.etat = new EtatPhilosophe[nbPhilosophes];
        this.verrou = new ReentrantLock();
        this.conditionPhilosophes = new Condition[nbPhilosophes];

        for (int i = 0; i < nbPhilosophes; i++) {
            etat[i] = EtatPhilosophe.Pense;
            conditionPhilosophes[i] = verrou.newCondition();
        }
    }

    public void demanderFourchettes(int no) throws InterruptedException {
        verrou.lock();
        try {
            etat[no] = EtatPhilosophe.Demande;
            while (voisinsMangent(no)) {
                conditionPhilosophes[no].await(); // Attendre que les voisins arrêtent de manger
            }

            etat[no] = EtatPhilosophe.Mange;
            // J'ai les fourchettes G et D
            IHMPhilo.poser(Main.FourchetteGauche(no), EtatFourchette.AssietteDroite);
            IHMPhilo.poser(Main.FourchetteDroite(no), EtatFourchette.AssietteGauche);
        } finally {
            verrou.unlock();
        }
    }

    public void libererFourchettes(int no) {
        verrou.lock();
        try {
            IHMPhilo.poser(Main.FourchetteGauche(no), EtatFourchette.Table);
            IHMPhilo.poser(Main.FourchetteDroite(no), EtatFourchette.Table);
            etat[no] = EtatPhilosophe.Pense;

            // Réveiller les voisins pour qu'ils puissent vérifier s'ils peuvent manger
            conditionPhilosophes[(no + 1) % etat.length].signal();
            conditionPhilosophes[(no - 1 + etat.length) % etat.length].signal();
        } finally {
            verrou.unlock();
        }
    }

    private boolean voisinsMangent(int no) {
        return etat[(no + 1) % etat.length] == EtatPhilosophe.Mange
                || etat[(no - 1 + etat.length) % etat.length] == EtatPhilosophe.Mange;
    }

    public String nom() {
        return "Moniteur";
    }
}


