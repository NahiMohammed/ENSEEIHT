package allumettes;

public class Arbitre {
	
	private Joueur joueur1;
	private Joueur joueur2;
	private int tour=1;
	private boolean isConfiant;
	
	public Arbitre(Joueur joueur1, Joueur joueur2) {
		assert joueur1!=null && joueur2!=null;
		this.joueur1=joueur1;
		this.joueur2=joueur2;
	}
	
	public Arbitre(Joueur joueur1, Joueur joueur2, boolean isConfiant) {
	    this(joueur1,joueur2);
		this.isConfiant=isConfiant;
	}

	
	public void arbitrer(Jeu jeuEnCours) {
		assert jeuEnCours!=null;
		Joueur joueurActuel = null;
		
		
		System.out.println("Nombre d'allumettes restantes :" + jeuEnCours.getNombreAllumettes());
		do {
            try {
            	if (tour%2==1) {
        			joueurActuel = this.joueur1;
        		}else {
        			joueurActuel = this.joueur2;
        		}
            	if (joueurActuel.getNomStrategie().equals("humain")) {
                	System.out.print(joueurActuel.getNom() + ", combien d'allumettes ? "); 	
                }
                int nbPrises = 0;
                if (this.isConfiant) {
                    nbPrises = joueurActuel.getPrise(jeuEnCours, joueurActuel);
                }
                else {nbPrises = joueurActuel.getPrise(new Proxy((implantationJeu)jeuEnCours), joueurActuel);
    		    }
                if (nbPrises > 1) {
                    System.out.print(joueurActuel.getNom() + " prend " + nbPrises + " allumettes.\n");
                } 
                else {
                    System.out.print(joueurActuel.getNom() + " prend " + nbPrises + " allumette.\n");
                }
                jeuEnCours.retirer(nbPrises);
                tour=tour+1;
                
    		    }
                catch (CoupInvalideException e) {
    		    	
    		    	System.out.print("Impossible ! Nombre invalide : " + e.getCoup() + " (" + e.getProbleme() + ")\n");
    		    }
                catch (OperationInterditeException e) {System.out.println("Abandon de la partie car " + joueurActuel.getNom() + " triche !");
                ;
            }
                if (jeuEnCours.getNombreAllumettes() > 1) {
                	System.out.println("\n Allumettes restantes "+ jeuEnCours.getNombreAllumettes());
                }
		} while (jeuEnCours.getNombreAllumettes() > 0);
		if (tour%2==0) {

			System.out.println("\n" + joueur1.getNom() + " perd !");
			System.out.println(joueur2.getNom() + " gagne !");

		} else {

	        System.out.println("\n" + joueur2.getNom() + " perd !");
	        System.out.println(joueur1.getNom() + " gagne !");
		}
    }
}
