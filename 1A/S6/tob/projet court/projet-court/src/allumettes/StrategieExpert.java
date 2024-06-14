package allumettes;
import java.util.Random;
public class StrategieExpert implements Strategie{

	public int getPrise(Jeu jeuEnCours, Joueur joueur) {
		int nombrePrise = 0;
		if (jeuEnCours.getNombreAllumettes()%(Jeu.PRISE_MAX + 1)!=1) {
			nombrePrise = (jeuEnCours.getNombreAllumettes() - 1) % (Jeu.PRISE_MAX + 1);
   			
		} else { 
			Random rand = new Random();
			return rand.nextInt(Math.min(Jeu.PRISE_MAX, jeuEnCours.getNombreAllumettes())) + 1 ;
		}
		return nombrePrise ;
	}

	@Override
	public String getStrategie() {
		return "expert";
	}
	
}
