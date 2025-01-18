package Bibliotheque;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Classe MusiqueSQL utilisée pour interagir avec la base de données 
 * de la bibliothèque pour les opérations liées au tableau musique.
 */
public class MusiqueSQL {
	
	/**
     * Établit une connexion avec la base de données de la bibliothèque.
     *
     * @return Connection à la base de données (null en cas d'erreur).
     */
	private Connection connect() {
        Connection connection = null;
        String url = "jdbc:mysql://localhost:3306/bibliotheque";
        String user = "root";
        String password = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); 
            connection = DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return connection;
    }
	
	/**
     * Vérifie si une musique avec un ID spécifique existe dans la base de données.
     *
     * @param id ID de la musique.
     * @return true si la musique existe, false sinon.
     */
	
	public boolean musiqueExiste(int id) {
		try {
			Connection connection = connect();
			Statement statement = connection.createStatement();
			String commande = "SELECT * FROM musiques WHERE id LIKE '%" + id + "%';";
			ResultSet resultSet = statement.executeQuery(commande);
			if (resultSet.next()) {
                return true;
                
            }
		} catch (SQLException e) {
            e.printStackTrace();
            
		}
		return false;
	}
	

	/**
     * Recherche des musiques dans la base de données en fonction d'un mot clé.
     *
     * @param motCle Mot clé pour la recherche qui peut id,titre,categorie...
     * @return Liste des musiques correspondant au mot clé.
     */

	public List<Media> chercherMusiques(String motCle) {
		List<Media> ResultatMusiques = new ArrayList<>();
		
		try {
			Connection connection = connect();
			Statement statement = connection.createStatement();
			String commande = "SELECT * FROM musiques WHERE id LIKE '%" + motCle + "%' OR titre LIKE '%" + motCle
					          + "%' OR realisateur LIKE '%" + motCle+ "%' OR duree LIKE '%" + motCle
			                  + "%' OR categorie LIKE '%" + motCle + "%';";
			ResultSet resultSet = statement.executeQuery(commande);
			
			while (resultSet.next()) {
				int id = resultSet.getInt("id");
                String titre = resultSet.getString("titre");
                String realisateur = resultSet.getString("realisateur");
                int duree = resultSet.getInt("duree");
                String categorie = resultSet.getString("categorie");
                String emplacement = resultSet.getString("emplacement");
                boolean disponible = resultSet.getBoolean("disponible");
                
                Media musique = new Media(id, titre, realisateur,  duree,  categorie,  emplacement,  disponible);
                ResultatMusiques.add(musique);
			}
		} catch (SQLException e) {
            e.printStackTrace();
            
		}
		return ResultatMusiques;
		
	}
	
	/**
     * Ajoute une nouvelle musique à la base de données.
     *
     * @param musique Musique à ajouter.
     * @throws ExceptionGestion en cas d'erreur lors de l'ajout.
     */
	public void ajouterMusique(Media musique) throws ExceptionGestion {
		try {
			if (musiqueExiste(musique.getId())) {
				throw new ExceptionGestion("La musique avec ce id existe déjà.");
			}
			Connection connection = connect();
			Statement statement = connection.createStatement();
			String commande = "INSERT INTO musiques (id, titre, realisateur,duree, categorie, emplacement, disponible) VALUES ('"
			                    + musique.getId() + "', '" + musique.getTitre() + "', '" + musique.getRealisateur() + "', '"
			                    + musique.getDuree() + "', '" + musique.getCategorie() + "', '" + musique.getEmplacement() 
			                    + "', " + musique.estDisponible() + ");";
			
			statement.executeUpdate(commande);
		} catch (SQLException e) {
            e.printStackTrace();
            
		} 
	}

	/**
     * Met à jour les informations d'une musique dans la base de données.
     *
     * @param musique Musique avec les nouvelles informations.
     * @throws ExceptionGestion en cas d'erreur lors de la mise à jour.
     */

    public void updateMusique(Media musique) throws ExceptionGestion{
        try {
        	if (!musiqueExiste(musique.getId())) {
				throw new ExceptionGestion("La musique avec ce id n'existe pas.Essaye de l'ajouter d'abord");
			}
            Connection connection = connect();
            Statement statement = connection.createStatement();
            String commande =  "UPDATE musiques SET titre = '" + musique.getTitre() + "', realisateur = '" + musique.getRealisateur() 
                               + "', duree = '" + musique.getDuree() + "', categorie = '" + musique.getCategorie() 
                               + "', emplacement = '" + musique.getEmplacement() + "', disponible = " + musique.estDisponible() 
                               + " WHERE id = " + musique.getId() + ";";
            
            statement.executeUpdate(commande);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
	
    /**
     * Supprime une musique de la base de données.
     *
     * @param id ID de la musique à supprimer.
     * @throws ExceptionGestion en cas d'erreur lors de la suppression.
     */
	public void supprimerMusique(int id) throws ExceptionGestion{
        try {
        	if (!musiqueExiste(id)) {
				throw new ExceptionGestion("La musique avec ce id n'existe pas.");
			}
            Connection connection = connect();
            Statement statement = connection.createStatement();
            String commande = "DELETE FROM musiques WHERE id = " + id + ";";

            statement.executeUpdate(commande);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
	

}
