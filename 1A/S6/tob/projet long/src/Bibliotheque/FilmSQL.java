package Bibliotheque;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Classe FilmSQL utilisée pour interagir avec la base de données 
 * de la bibliothèque pour les opérations liées au tableau Film.
 */
public class FilmSQL {
	
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
     * Vérifie si un film avec un ID spécifique existe dans la base de données.
     *
     * @param id ID du film.
     * @return true si le film existe, false sinon.
     */
	public boolean filmExiste(int id) {
		try {
			Connection connection = connect();
			Statement statement = connection.createStatement();
			String commande = "SELECT * FROM films WHERE id LIKE '%" + id + "%';";
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
     * Recherche des films dans la base de données en fonction d'un mot clé.
     *
     * @param motCle Mot clé pour la recherche qui peut id,titre,categorie...
     * @return Liste des films correspondant au mot clé.
     */
	public List<Media> chercherFilms(String motCle) {
		List<Media> ResultatFilms = new ArrayList<>();
		
		try {
			Connection connection = connect();
			Statement statement = connection.createStatement();
			String commande = "SELECT * FROM films WHERE id LIKE '%" + motCle + "%' OR titre LIKE '%" + motCle
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
                
                Media film = new Media(id, titre, realisateur,  duree,  categorie,  emplacement,  disponible);
                ResultatFilms.add(film);
			}
		} catch (SQLException e) {
            e.printStackTrace();
            
		}
		return ResultatFilms;
		
	}
	
	/**
     * Ajoute un film à la base de données.
     *
     * @param film Film à ajouter.
     * @throws ExceptionGestion en cas d'erreur lors de l'ajout.
     */
	public void ajouterFilm(Media film) throws ExceptionGestion {
		try {
			if (filmExiste(film.getId())) {
				throw new ExceptionGestion("Le film avec ce id existe déjà.");
			}
			Connection connection = connect();
			Statement statement = connection.createStatement();
			String commande = "INSERT INTO films (id, titre, realisateur,duree, categorie, emplacement, disponible) VALUES ('"
			                    + film.getId() + "', '" + film.getTitre() + "', '" + film.getRealisateur() + "', '"
			                    + film.getDuree() + "', '" + film.getCategorie() + "', '" + film.getEmplacement() 
			                    + "', " + film.estDisponible() + ");";
			
			statement.executeUpdate(commande);
		} catch (SQLException e) {
            e.printStackTrace();
            
		} 
	}
	
	/**
     * Met à jour les informations d'un film dans la base de données.
     *
     * @param film Film avec les nouvelles informations.
     * @throws ExceptionGestion en cas d'erreur lors de la mise à jour.
     */
	public void updateFilm(Media film) throws ExceptionGestion{
        try {
        	if (!filmExiste(film.getId())) {
				throw new ExceptionGestion("Le film avec ce id n'existe pas.Essaye de l'ajouter d'abord");
			}
            Connection connection = connect();
            Statement statement = connection.createStatement();
            String commande =  "UPDATE films SET titre = '" + film.getTitre() + "', realisateur = '" + film.getRealisateur() 
                               + "', duree = '" + film.getDuree() + "', categorie = '" + film.getCategorie() 
                               + "', emplacement = '" + film.getEmplacement() + "', disponible = " + film.estDisponible() 
                               + " WHERE id = " + film.getId() + ";";
            
            statement.executeUpdate(commande);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
	
	/**
     * Supprime un film de la base de données.
     *
     * @param id ID du film à supprimer.
     * @throws ExceptionGestion en cas d'erreur lors de la suppression.
     */
	public void supprimerFilm(int id) throws ExceptionGestion{
        try {
        	if (!filmExiste(id)) {
				throw new ExceptionGestion("Le film avec ce id n'existe pas.");
			}
            Connection connection = connect();
            Statement statement = connection.createStatement();
            String commande = "DELETE FROM films WHERE id = " + id + ";";

            statement.executeUpdate(commande);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
	

}
