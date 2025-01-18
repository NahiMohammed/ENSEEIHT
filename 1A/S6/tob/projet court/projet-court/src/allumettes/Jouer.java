package allumettes;
import java.util.Arrays;
/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	Xavier Crégut
 * @version	$Revision: 1.5 $
 */
public class Jouer {
	
	private static final int NB_ALLUMETTES_INITIAL = 13;

	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) {
		boolean presenceConfiance=false;
			
		try {
			
			verifierNombreArguments(args);

			 // Vérifier si l'arbitre est confiant
	        if (args.length > 0 && args[0].toLowerCase().equals("-confiant")) {
	            args = Arrays.copyOfRange(args, 1, args.length);
	            presenceConfiance=true;
	        }
	        
	        // Extraire les informations des joueurs
	        String[] joueur1Infos = args[0].split("@");
	        String[] joueur2Infos = args[1].split("@");
	        
	        // Creation des joueurs 
	        Joueur joueur1 = new Joueur(joueur1Infos[0],configurerStrategie(joueur1Infos[1]));
	        Joueur joueur2 = new Joueur(joueur2Infos[0],configurerStrategie(joueur2Infos[1]));
	        
	        // Création du jeu
			Jeu jeuEnCours = new implantationJeu(NB_ALLUMETTES_INITIAL);

			// Creation de l'arbitre
			Arbitre arbitre = new Arbitre(joueur1, joueur2,presenceConfiance);
			
			arbitre.arbitrer(jeuEnCours);
			
			
		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
		}
				
			System.exit(1);
			
	}
    
	
	public static Strategie configurerStrategie(String strategieMaj) {
		
		Strategie strategie = null;
		String nomStrategie = strategieMaj.toLowerCase();

		switch (nomStrategie) {
		case "naif" :
			strategie = new StrategieNaif();
			break;

		case "rapide" :
			strategie = new StrategieRapide();
			break;

		case "expert" :
			strategie = new StrategieExpert();
			break;

		case "humain" :
			strategie = new StrategieHumain();
			break;

		case "tricheur" :
			strategie = new StrategieTricheur();
			break;

		default :
			throw new ConfigurationException("La strategie choisie n'existe pas.");
		}
		return strategie;
	}
	
	private static void verifierNombreArguments(String[] args) {
		final int nbJoueurs = 2;
		if (args.length < nbJoueurs) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		}
		if (args.length > nbJoueurs + 1) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Jouer joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Jouer Xavier@humain "
					   + "Ordinateur@naif"
				+ "\n"
				);
	}

}
