package allumettes;
import org.junit.*;

public class StrategieRapideTest {

    //les joueurs du sujet
    private Joueur joueurRapide;

    //les jeux du sujet
    private Jeu jeuTest1, jeuTest2, jeuTest3,jeuTest4;

    @Before public void setUp() {
		// Construction des parties de jeux
        jeuTest1 = new implantationJeu(1);
        jeuTest2 = new implantationJeu(2);
        jeuTest3 = new implantationJeu(7);
        jeuTest4 = new implantationJeu(11);

        // Construire un joueur de stratégie rapide
        joueurRapide = new Joueur("JoueurRapide",new StrategieRapide());
    }
    @Test public void testerPrise(){
            assertEquals("Prise incorrecte pour un jeu avec 1 allumette restante", 1, joueurRapide.getPrise(jeuTest1,joueurRapide));
    
            assertEquals("Prise incorrecte pour un jeu avec 2 allumettes restantes", 2, joueurRapide.getPrise(jeuTest2,joueurRapide));

            assertEquals("Prise incorrecte pour un jeu avec 3 allumettes restantes", 3, joueurRapide.getPrise(jeuTest3,joueurRapide));

            assertEquals("Prise incorrecte pour un jeu avec 13 allumettes restantes", 3, joueurRapide.getPrise(jeuTest4,joueurRapide));
    }
    
}