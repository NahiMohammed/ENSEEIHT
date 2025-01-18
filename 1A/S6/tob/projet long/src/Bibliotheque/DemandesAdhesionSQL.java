package Bibliotheque;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Classe DemandesAdhesionSQL utilisée pour interagir avec la base de données 
 * de la bibliothèque pour les opérations liées au demandes d'adhésions.
 */
public class DemandesAdhesionSQL {
	
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
     * Recherche des demandes dans la base de données en fonction d'un mot clé.
     *
     * @param motCle Mot clé pour la recherche qui peut nom,prenom,adresse...(pas le mot de passe)
     * @return Liste des livres correspondant au mot clé.
     */
	public List<Utilisateur> chercherDemande(String motCle) {
        List<Utilisateur> Resultat = new ArrayList<>();
		
		try {
			Connection connection = connect();
			Statement statement = connection.createStatement();
			String commande = "SELECT * FROM demandes_adhesion WHERE nom LIKE '%" + motCle + "%' OR prenom LIKE '%" 
			                + motCle + "%' OR adresse LIKE '%" + motCle + "%' OR date_naissance LIKE '%" + motCle + "%'  OR email LIKE '%" 
					       + motCle + "%'  OR telephone LIKE '%" + motCle + "%' ;";
			ResultSet resultSet = statement.executeQuery(commande);
			
			while (resultSet.next()) {
				String nom = resultSet.getString("nom");
                String prenom = resultSet.getString("prenom");
                String adresse = resultSet.getString("adresse");
                String email = resultSet.getString("email");
                String mot_de_passe = resultSet.getString("mot_de_passe");
                String date_naissance = resultSet.getString("date_naissance");
                String telephone = resultSet.getString("telephone");
                
                boolean est_employe = resultSet.getBoolean("est_employe");
                
                Utilisateur utilisateur = new Utilisateur(nom,prenom,adresse,email,telephone,mot_de_passe,date_naissance,est_employe);
                Resultat.add(utilisateur);
			}
		} catch (SQLException e) {
            e.printStackTrace();
            
		}
		return Resultat;
		
	}




	public void ajouterDemande(Utilisateur utilisateur) {
		try {
		
			Connection connection = connect();
			Statement statement = connection.createStatement();
			String commande = "INSERT INTO demandes_adhesion (nom, prenom, email, mot_de_passe, telephone, date_naissance, adresse, est_employe) VALUES ('"
			                    + utilisateur.getNom()           + "', '" 
					            + utilisateur.getPrenom()        + "', '" 
			                    + utilisateur.getEmail()         + "', '"
					            + utilisateur.getMotDePasse()    + "', '" 
			                    + utilisateur.getTelephone()     + "', '" 
					            + utilisateur.getDateNaissance() + "', '" 
			                    + utilisateur.getAdresse()       + "', " 
					            + utilisateur.EstEmploye()       + ");";
			
			statement.executeUpdate(commande);
			
		} catch (SQLException e) {
            e.printStackTrace();
            
		} 
	}

	}
