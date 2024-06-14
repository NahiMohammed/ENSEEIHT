package Bibliotheque;
public class Employe {
    private String nom; // Le nom de l'employé
    private String prenom; // Le prénom de l'employé
    private String adresse; // L'adresse de l'employé
    private String email; // L'adresse email de l'employé
    private String telephone; // Le numéro de téléphone de l'employé
    private String motDePasse; // Le mot de passe de l'employé 
    private String poste; // Le poste de l'employé
    
   /**Construire un employé.
	 * @param nom       : le nom de l'employé 
	 * @param prenom    : le prénom de l'employé
     * @param adresse   : l'adresse de l'employé
     * @param email     : l'email de l'employé
     * @param telephone : le téléphone de l'employé
     * @param motDePasse: le mot de passe de l'employé
     * @param poste     : le poste de l'employé
	 */
    public Employe(String nom, String prenom, String adresse, String email, String telephone, String motDePasse, String poste) {
        assert nom!=null && prenom!=null && adresse!=null && email!=null && telephone!=null && motDePasse!=null && poste!=null;
        this.nom = nom;
        this.prenom = prenom;
        this.adresse = adresse;
        this.email = email;
        this.telephone = telephone;
        this.motDePasse = motDePasse;
        this.poste = poste;
    }
  
   /**Obtenir le nom de l'employé
    *@return le nom de l'employé
    */
    public String getNom() {
        return nom;
    }
      
   /**Changer le nom de l'employé
    *@param nom : le nom de l'employé
    */
    public void setNom(String nom) {
        assert nom!=null;
        this.nom = nom;
    }
    
   /**Obtenir le prénom de l'employé
    *@return le prénom de l'employé
    */
    public String getPrenom() {
        return prenom;
    }
    
   /**Changer le prénom de l'employé
    *@param prenom : le prénom de l'employé
    */
    public void setPrenom(String prenom) {
        assert prenom!=null;
        this.prenom = prenom;
    }
    
   /**Obtenir l'adresse de l'employé
    *@return l'adresse de l'employé
    */
    public String getAdresse() {
        return adresse;
    }
    
   /**Changer l'adresse de l'employé
    *@param adresse : l'adresse de l'employé
    */
    public void setAdresse(String adresse) {
        assert adresse!=null;
        this.adresse = adresse;
    }
    
   /**Obtenir l'email de l'employé
    *@return l'email de l'employé
    */
    public String getEmail() {
        return email;
    }
    
   /**Changer l'email de l'employé
    *@param email : l'email de l'employé
    */
    public void setEmail(String email) {
        assert email!=null;
        this.email = email;
    }
    
   /**Obtenir le telephone de l'employé
    *@return le telephone de l'employé
    */
    public String getTelephone() {
        return telephone;
    }
    
   /**Changer le telephone de l'employé
    *@param nom : le telephone de l'employé
    */
    public void setTelephone(String telephone) {
        assert telephone!=null;
        this.telephone = telephone;
    }
    /**Obtenir le mot de passe de l'employé
    *@return le mot de passe  de l'employé
    */
     public String getMotDePasse() {
        return motDePasse;
    }

    /**Changer le mot de passe de l'employé
    *@param motDePasse : le mot de passe  de l'employé
    */
    public void setMotDePasse(String motDePasse) {
        assert motDePasse!=null;
        this.motDePasse = motDePasse;
    }
}
