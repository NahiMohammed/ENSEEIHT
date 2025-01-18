package Bibliotheque;
/**
 * La classe Livre représente un livre dans la bibliothèque.
 */
public class Livre {
	
	private int id;
    private String titre;
    private String auteur;
    private String categorie;
    private String emplacement;
    private boolean disponible;
    
    /**
     * Constructeur pour la classe Livre.
     * 
     * @param id L'identifiant unique du livre.
     * @param titre Le titre du livre.
     * @param auteur L'auteur du livre.
     * @param categorie La catégorie du livre.
     * @param emplacement L'emplacement du livre dans la bibliothèque.
     * @param disponible Si le livre est actuellement disponible.
     */
    public Livre(int id, String titre, String auteur, String categorie, String emplacement, boolean disponible) {
        this.id = id;
    	this.titre = titre;
        this.auteur = auteur;
        this.categorie = categorie;
        this.emplacement = emplacement;
        this.disponible = disponible;
    }

    /**
     * Retourne l'identifiant unique du livre.
     *
     * @return L'identifiant unique du livre.
     */
    public int getId() {
        return this.id;
    }
    
    
    /**
     * Retourne le titre du livre.
     *
     * @return Le titre du livre.
     */
    public String getTitre() {
        return this.titre;
    }

    /**
     * Retourne l'auteur du livre.
     *
     * @return L'auteur du livre.
     */
    public String getAuteur() {
        return this.auteur;
    }

    /**
     * Retourne la catégorie du livre.
     *
     * @return La catégorie du livre.
     */
    public String getCategorie() {
        return this.categorie;
    }
    
    /**
     * Retourne l'emplacement du livre dans la bibliothèque.
     *
     * @return L'emplacement du livre dans la bibliothèque.
     */
    public String getEmplacement() {
        return this.emplacement;
    }
    
    /**
     * Indique si le livre est actuellement disponible.
     *
     * @return true si le livre est disponible, false sinon.
     */
    public boolean estDisponible() {
        return this.disponible;
    }

    
}