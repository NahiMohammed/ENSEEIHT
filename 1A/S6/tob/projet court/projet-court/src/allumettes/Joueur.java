package allumettes;

public class Joueur {
	
	private String nom;
	private Strategie strategie;
	
	/**Construire un joueur.
	 * @param nom       : le nom du joueur 
	 * @param strategie : la strategie du joueur 
	 */
	public Joueur(String nom, Strategie strategie) {
		assert nom!=null && strategie!=null;
		this.nom=nom;
		this.strategie=strategie;
	}
	
	/**obtenir le nom du joueur.
	 *@return le nom du joueur
	 */
	public String getNom() {
		return this.nom;
	}
	
	/**obtenir la strategie du joueur.
	 *@return la strategie  du joueur
	 */
	public String getNomStrategie() {
		return this.strategie.getStrategie();
	}
	
	
	
	/**Obtenir le nombre d'allumettes prise par le joueur.
	 * @param jeuEnCours
	 * @param joueur
	 * @return nombre d'allumettes; choisi
	 */
	
	public int getPrise(Jeu jeuEnCours, Joueur joueur) {
		
		assert jeuEnCours!=null && joueur!=null;
		
		return this.strategie.getPrise(jeuEnCours, joueur);
	}
}
