package allumettes;

public class StrategieRapide implements Strategie {
	
	/**Obtenir le nombre maximum d'allumettes possible a retirer afin de terminer la partie le plus rapide possible.*/
	public int getPrise(Jeu jeuEnCours, Joueur joueur) {
		
        assert jeuEnCours != null && joueur != null;
		assert (jeuEnCours.getNombreAllumettes() > 0);
		
		return Math.min(jeuEnCours.getNombreAllumettes(), Jeu.PRISE_MAX);
	}

	@Override
	public String getStrategie() {
		return ("rapide");
	}
}
	