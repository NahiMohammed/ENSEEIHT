package allumettes;

import java.util.Scanner;

public class StrategieHumain implements Strategie {
	
	private static final Scanner scanner = new Scanner(System.in);
	
	/**Donner le choix a l'utilisateur de saisir sa prise.*/
	public int getPrise(Jeu jeuEnCours, Joueur joueur){
		
		assert jeuEnCours != null && joueur != null;
		assert (jeuEnCours.getNombreAllumettes() > 0);
		
		int nbPrise = 0 ;
		boolean coupValide = false;
		
		do {
			try {
				String entree = this.scanner.nextLine();				
                if (entree.contentEquals("triche")) {                	
                    System.out.println("[Une allumette en moins, plus que 4. Chut !]");
                    try {
                        jeuEnCours.retirer(1);
                        System.out.print(joueur.getNom() + ", combien d'allumettes ? ");
                    } catch (CoupInvalideException h) {
                        System.out.println("pas possible");
                    }
                } else {
               nbPrise = Integer.parseInt(entree);
               coupValide = true;
               }
           } catch (NumberFormatException e) {
           System.out.print("Vous devez donner un entier.\n"
         + joueur.getNom() + ", combien d'allumettes ? ");
        }
	    } while (!coupValide);
    return nbPrise;
    }

	@Override
	public String getStrategie() {
		return "humain";
	}
}
