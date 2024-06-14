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
 * de la bibliothèque pour les opérations liées au tableau Livre.
 */
public class LivreSQL {
	
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
     * Vérifie si un livre avec un ID spécifique existe dans la base de données.
     *
     * @param id ID du livre.
     * @return true si le livre existe, false sinon.
     */
	public boolean livreExiste(int id) {
		try {
			Connection connection = connect();
			Statement statement = connection.createStatement();
			String commande = "SELECT * FROM livres WHERE id LIKE '%" + id + "%';";
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
     * Recherche des livres dans la base de données en fonction d'un mot clé.
     *
     * @param motCle Mot clé pour la recherche qui peut id,titre,categorie...
     * @return Liste des livres correspondant au mot clé.
     */
	public List<Livre> chercherLivres(String motCle) {
		List<Livre> ResultatLivres = new ArrayList<>();
		
		try {
			Connection connection = connect();
			Statement statement = connection.createStatement();
			String commande = "SELECT * FROM livres WHERE id LIKE '%" + motCle + "%' OR titre LIKE '%" 
			                + motCle + "%' OR auteur LIKE '%" + motCle + "%' OR categorie LIKE '%" 
					           + motCle + "%';";
			ResultSet resultSet = statement.executeQuery(commande);
			
			while (resultSet.next()) {
				int id = resultSet.getInt("id");
                String titre = resultSet.getString("titre");
                String auteur = resultSet.getString("auteur");
                String categorie = resultSet.getString("categorie");
                String emplacement = resultSet.getString("emplacement");
                boolean disponible = resultSet.getBoolean("disponible");
                
                Livre livre = new Livre(id, titre, auteur, categorie, emplacement, disponible);
                ResultatLivres.add(livre);
			}
		} catch (SQLException e) {
            e.printStackTrace();
            
		}
		return ResultatLivres;
		
	}
	
	/**
     * Ajoute un livre à la base de données.
     *
     * @param livre Livre à ajouter.
     * @throws ExceptionGestion en cas d'erreur lors de l'ajout.
     */
	public void ajouterLivre(Livre livre) throws ExceptionGestion {
		try {
			if (livreExiste(livre.getId())) {
				throw new ExceptionGestion("Le livre avec ce id existe déjà.");
			}
			Connection connection = connect();
			Statement statement = connection.createStatement();
			String commande = "INSERT INTO livres (id, titre, auteur, categorie, emplacement, disponible) VALUES ('"
			                    + livre.getId() + "', '" + livre.getTitre() + "', '" + livre.getAuteur() + "', '"
					            + livre.getCategorie() + "', '" + livre.getEmplacement() + "', " + livre.estDisponible() + ");";
			
			statement.executeUpdate(commande);
		} catch (SQLException e) {
            e.printStackTrace();
            
		} 
	}
	
	/**
     * Met à jour les informations d'un livre dans la base de données.
     *
     * @param livre Livre avec les nouvelles informations.
     * @throws ExceptionGestion en cas d'erreur lors de la mise à jour.
     */
	public void updateLivre(Livre livre) throws ExceptionGestion{
        try {
        	if (!livreExiste(livre.getId())) {
				throw new ExceptionGestion("Le livre avec ce id n'existe pas.Essaye de l'ajouter d'abord");
			}
            Connection connection = connect();
            Statement statement = connection.createStatement();
            String commande =  "UPDATE livres SET titre = '" + livre.getTitre() + "', auteur = '" + livre.getAuteur() 
                                  + "', categorie = '" + livre.getCategorie() + "', emplacement = '" + livre.getEmplacement() 
                                  + "', disponible = " + livre.estDisponible() + " WHERE id = " + livre.getId() + ";";
            
            statement.executeUpdate(commande);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
	
	/**
     * Supprime un livre de la base de données.
     *
     * @param id ID du livre à supprimer.
     * @throws ExceptionGestion en cas d'erreur lors de la suppression.
     */
	public void supprimerLivre(int id) throws ExceptionGestion{
        try {
        	if (!livreExiste(id)) {
				throw new ExceptionGestion("Le livre avec ce id n'existe pas.");
			}
            Connection connection = connect();
            Statement statement = connection.createStatement();
            String commande = "DELETE FROM livres WHERE id = " + id + ";";

            statement.executeUpdate(commande);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
	

}
