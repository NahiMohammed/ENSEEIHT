package Bibliotheque;
public class Utilisateur {
    private String nom; // Le nom de l'utilisateur
    private String prenom; // Le prénom de l'utilisateur
    private String adresse; // L'adresse de l'utilisateur
    private String email; // L'adresse email de l'utilisateur
    private String telephone; // Le numéro de téléphone de l'utilisateur
    private String motDePasse; // Le mot de passe de l'utilisateur 
    private String dateDeNaissance;
    private boolean estEmploye;
    
   /**Construire un utilisateur.
	  * @param nom       : le nom de l'utilisateur 
	  * @param prenom    : le prénom de l'utilisateur
    * @param adresse   : l'adresse de l'utilisateur
    * @param email     : l'email de l'utilisateur
    * @param telephone : le telephone  de l'utilisateur
	  */
    public Utilisateur(String nom, String prenom, String adresse, String email, String telephone,String motDePasse,String dateDeNaissance,boolean estEmploye) {
        assert nom!=null && prenom!=null && adresse!=null && email!=null && telephone!=null && motDePasse!=null ;
        this.nom = nom;
        this.prenom = prenom;
        this.adresse = adresse;
        this.email = email;
        this.telephone = telephone;
        this.motDePasse = motDePasse;
        this.estEmploye= estEmploye;
        this.dateDeNaissance=dateDeNaissance;
    }
  
   /**Obtenir le nom de l'utilisateur
    *@return le nom de l'utilisateur
    */
    public String getNom() {
        return this.nom;
    }
      
   /**Changer le nom de l'utilisateur
    *@param nom : le nom de l'utilisateur
    */
    public void setNom(String nom) {
        assert nom!=null;
        this.nom = nom;
    }
    
   /**Obtenir le prenom de l'utilisateur
    *@return le le prenom de l'utilisateur
    */
    public String getPrenom() {
        return this.prenom;
    }
    
   /**Changer le prenom de l'utilisateur
    *@param prenom : le prenom de l'utilisateur
    */
    public void setPrenom(String prenom) {
        assert prenom!=null;
        this.prenom = prenom;
    }
    
   /**Obtenir l'adresse de l'utilisateur
    *@return le l'adresse de l'utilisateur
    */
    public String getAdresse() {
        return this.adresse;
    }
    
   /**Changer l'adresse de l'utilisateur
    *@param adresse : l'adresse de l'utilisateur
    */
    public void setAdresse(String adresse) {
        assert adresse!=null;
        this.adresse = adresse;
    }
    
   /**Obtenir l'email de l'utilisateur
    *@return l'email nom de l'utilisateur
    */
    public String getEmail() {
        return this.email;
    }
    
   /**Changer l'email de l'utilisateur
    *@param nom : l'email de l'utilisateur
    */
    public void setEmail(String email) {
        assert email!=null;
        this.email = email;
    }
    
   /**Obtenir le telephone de l'utilisateur
    *@return le telephone de l'utilisateur
    */
    public String getTelephone() {
        return this.telephone;
    }
    
   /**Changer le telephone de l'utilisateur
    *@param nom : le telephone de l'utilisateur
    */
    public void setTelephone(String telephone) {
        assert telephone!=null;
        this.telephone = telephone;
    }
    
   /**Obtenir le mot de passe de l'utilisateur
    *@return le mot de passe  de l'utilisateur
    */
    public String getMotDePasse() {
        return this.motDePasse;
    }
    
    public String getDateNaissance() {
        return this.dateDeNaissance;
    }
    
    public boolean EstEmploye() {
        return this.estEmploye;
    }
    
   /**Changer le mot de passe de l'utilisateur
    *@param motDePasse : le mot de passe  de l'utilisateur
    */
    public void setMotDePasse(String motDePasse) {
        assert motDePasse!=null;
        this.motDePasse = motDePasse;
    }
}
