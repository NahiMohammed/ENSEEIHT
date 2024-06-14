package allumettes;

public class StrategieTricheur implements Strategie {
	
	public int getPrise(Jeu jeuEnCours, Joueur joueur) {
		
        assert jeuEnCours != null && joueur!=null;
        
        System.out.println("[Je triche...]");
        try {
            while (jeuEnCours.getNombreAllumettes() > 2) {
                jeuEnCours.retirer(1);
                }
                System.out.println("[Allumettes restantes : 2]");
        } catch (CoupInvalideException e) {
            System.out.println("impossible");
        }
        return 1;
        }

	@Override
	public String getStrategie() {
		return ("tricheur");
	}

}
