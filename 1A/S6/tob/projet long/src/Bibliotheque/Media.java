package Bibliotheque;
/**
 * La classe Media représente un film ou une musique.
 */
public class Media {
	private int id;
    private String titre;
    private String realisateur;
    private int duree;
    private String categorie;
    private String emplacement;
    private boolean disponible;

    
    /**
     * Constructeur pour la classe Media.
     * 
     * @param id L'identifiant unique du media.
     * @param titre Le titre du Media.
     * @param realisateur Le realisateur du Media.
     * @param duree   La durée du Media en minutes.
     * @param categorie La catégorie du Media.
     * @param emplacement L'emplacement du Media dans la bibliothèque.
     * @param disponible Si la Media est actuellement disponible.
     */

    public Media(int id, String titre, String realisateur, int duree, String categorie, String emplacement, boolean disponible) {
    	this.id = id;
        this.titre = titre;
        this.realisateur = realisateur;
        this.duree = duree;
        this.categorie = categorie;
        this.emplacement = emplacement;
        this.disponible = disponible;
        
    }

    /**
     * Retourne l'identifiant unique du Media.
     *
     * @return L'identifiant unique du Media.
     */
    public int getId() {
        return this.id;
    }
    
    /**
     * Renvoie le titre du Media.
     *
     * @return Le titre du Media.
     */
    public String getTitre() {
        return this.titre;
    }

    

    /**
     * Renvoie le réalisateur du Media.
     *
     * @return Le réalisateur du Media.
     */
    public String getRealisateur() {
        return this.realisateur;
    }

    

    /**
     * Renvoie la durée du Media en minutes.
     *
     * @return La durée du Media en minutes.
     */
    public int getDuree() {
        return this.duree;
    }

   
    /**
     * Retourne la catégorie du Media.
     *
     * @return La catégorie du Media.
     */
    public String getCategorie() {
        return this.categorie;
    }
    
    /**
     * Retourne l'emplacement du Media dans la bibliothèque.
     *
     * @return L'emplacement du Media dans la bibliothèque.
     */
    public String getEmplacement() {
        return this.emplacement;
    }
    
    /**
     * Indique si la Media est actuellement disponible.
     *
     * @return true si la Media est disponible, false sinon.
     */
    public boolean estDisponible() {
        return this.disponible;
    }

    
}
