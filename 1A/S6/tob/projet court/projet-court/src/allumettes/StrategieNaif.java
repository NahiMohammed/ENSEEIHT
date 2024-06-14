package allumettes;
import java.util.Random;
public class StrategieNaif implements Strategie{
	
	/**Obtenir un nombre aleatoire entre 1 et le minimum de 3 et le nombre d'allumettes encore restantes.*/
	public int getPrise(Jeu jeuEnCours, Joueur joueur) {
		
		assert jeuEnCours != null && joueur != null;
		assert (jeuEnCours.getNombreAllumettes() > 0);
		
		Random rand = new Random();
		
		return rand.nextInt(Math.min(Jeu.PRISE_MAX, jeuEnCours.getNombreAllumettes())) + 1;
		
		
	}

	@Override
	public String getStrategie() {
		return "naif";
	}

}
