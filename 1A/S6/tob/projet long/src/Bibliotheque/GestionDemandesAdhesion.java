package Bibliotheque;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.util.List;
import java.util.Vector;

import javax.swing.*;
import javax.swing.table.*;


/**
 * La classe GestionDemandesAdhesion est utilisée pour gérer les demandes d'adhesion dans la bibliothèque.
 * Elle fournit une interface graphique pour voir les differantes demandes , les accepter ou les refuser.
 */
public class GestionDemandesAdhesion extends JFrame{
	
	/** Champ de recherche.*/
    private JTextField champRecherche;
    /** Bouton de recherche.*/
    private JButton boutonRecherche;
    /** Tableau des demandes. */
    private JTable tableau;
    
    private DefaultTableModel tableModel;
    /**Champs de saisie pour les détails de la demande . */
    private JTextField nomField;
    private JTextField prenomField;
    private JTextField adresse_mailField;
    private JTextField mdpField;
    private JTextField date_de_naissanceField;
    private JTextField adresseField;
    private JTextField telephoneField;
    
    private JCheckBox checkBoxUtilisateur; 
    private JCheckBox checkBoxEmploye; 
    
    /**Boutons pour ajouter, modifier et supprimer des livres.*/
    private JButton addButton;
    private JButton refuseButton;

	
	
	/**
     * Constructeur de la classe GestionLivres.
     * Il initialise l'interface graphique
     */
    public GestionDemandesAdhesion()  {
        setTitle("Gestion des demandes d'adhesion");
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLayout(new BorderLayout());
        
        JPanel content = new JPanel();
        content.setBackground(Color.BLUE);
        content.setLayout(new BorderLayout());

        // Barre de recherche
        JPanel searchPanel = new JPanel();
        champRecherche = new JTextField(20);
        boutonRecherche = new JButton("Rechercher");
        boutonRecherche.addActionListener(e -> chercherDemandes());
        searchPanel.add(champRecherche);
        searchPanel.add(boutonRecherche);
        content.add(searchPanel, BorderLayout.NORTH);

        // Tableau des livres
        tableModel = new DefaultTableModel(new String[]{"NOM", "PRENOM", "ADRESSE MAIL", "MOT DE PASSE", "TELEPHONE", "DATE DE NAISSANCE","ADRESSE","DEMANDE EN TANT QUE :"}, 0);
        tableau = new JTable(tableModel);

     // Ajout de l'écouteur de la souris
        tableau.addMouseListener( new MouseAdapter() {
         public void mouseClicked(MouseEvent e) {
             int row = tableau.getSelectedRow();
             String nom = tableau.getModel().getValueAt(row, 0).toString();
             String prenom = tableau.getModel().getValueAt(row, 1).toString();
             String adresse_mail = tableau.getModel().getValueAt(row, 2).toString();
             String mdp = tableau.getModel().getValueAt(row, 3).toString();
             String telephone = tableau.getModel().getValueAt(row, 4).toString();
             String date_de_naissance = tableau.getModel().getValueAt(row, 5).toString();
             String adresse = tableau.getModel().getValueAt(row, 6).toString();
             String typeUtilisateur = tableau.getModel().getValueAt(row, 7).toString();

             //remplir les champs de formulaire
             nomField.setText(nom);
             prenomField.setText(prenom);
             adresse_mailField.setText(adresse_mail);
             mdpField.setText(mdp);
             telephoneField.setText(telephone);
             date_de_naissanceField.setText(date_de_naissance);
             adresseField.setText(adresse);
             
             if (typeUtilisateur.equals("utilisateur")) {
            	    checkBoxUtilisateur.setSelected(true);
            	} else if (typeUtilisateur.equals("employe")) {
            	    checkBoxEmploye.setSelected(true);
            	}
         }
     });
     
        JScrollPane booksTableScrollPane = new JScrollPane(tableau);
        content.add(booksTableScrollPane, BorderLayout.CENTER);
        chercherDemandes(); // Afficher la liste des livres
        
        
        



     // Formulaire pour ajouter ,modifier ou supprimer un livre
        JPanel addBookPanel = new JPanel();
        addBookPanel.setLayout(new BoxLayout(addBookPanel, BoxLayout.Y_AXIS));

        JPanel nomPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        nomPanel.add(new JLabel("nom :"));
        nomField = new JTextField(15);
        nomPanel.add(nomField);
        addBookPanel.add(nomPanel);

        JPanel prenomPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        prenomPanel.add(new JLabel("Prenom :"));
        prenomField = new JTextField(15);
        prenomPanel.add(prenomField);
        addBookPanel.add(prenomPanel);

        JPanel adresse_mailPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        adresse_mailPanel.add(new JLabel("adresse_mail :"));
        adresse_mailField = new JTextField(15);
        adresse_mailPanel.add(adresse_mailField);
        addBookPanel.add(adresse_mailPanel);

        JPanel mdpPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        mdpPanel.add(new JLabel("mot de passe :"));
        mdpField = new JTextField(15);
        mdpPanel.add(mdpField);
        addBookPanel.add(mdpPanel);

        JPanel telephonePanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        telephonePanel.add(new JLabel("telephone :"));
        telephoneField = new JTextField(15);
        telephonePanel.add(telephoneField);
        addBookPanel.add(telephonePanel);

        JPanel date_de_naissancePanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        date_de_naissancePanel.add(new JLabel("date de naissance :"));
        date_de_naissanceField = new JTextField(15);
        date_de_naissancePanel.add(date_de_naissanceField);
        addBookPanel.add(date_de_naissancePanel);
        
        JPanel adressePanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        adressePanel.add(new JLabel("adresse :"));
        adresseField = new JTextField(15);
        adressePanel.add(adresseField);
        addBookPanel.add(adressePanel);
        
        JPanel TypeUtilisateurPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        TypeUtilisateurPanel.add(new JLabel("Demande en tant que :"));
        checkBoxUtilisateur = new JCheckBox();
        checkBoxEmploye = new JCheckBox();
        TypeUtilisateurPanel.add(checkBoxUtilisateur);
        TypeUtilisateurPanel.add(checkBoxEmploye);
        
        addBookPanel.add(TypeUtilisateurPanel);
       

        JPanel buttonsPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        
        addButton = new JButton("Accepter");
        addButton.addActionListener(e -> accepterDemande());
        buttonsPanel.add(addButton);

        refuseButton = new JButton("Refuser");
        refuseButton.addActionListener(e ->refuserDemande());
        buttonsPanel.add(refuseButton);

        addBookPanel.add(buttonsPanel);

        
     // Nouveau JPanel pour les tableaux
        JPanel tablesPanel = new JPanel(new BorderLayout());
        tablesPanel.add(booksTableScrollPane, BorderLayout.CENTER);
        tablesPanel.add(addBookPanel, BorderLayout.SOUTH);

        content.add(tablesPanel, BorderLayout.CENTER); // Ajoutez le nouveau JPanel à droite
        
     // Sidebar
        JPanel sidebar = new JPanel();
        sidebar.setPreferredSize(new Dimension(200, 800));
        sidebar.setBackground(Color.BLUE);
        sidebar.setLayout(new BoxLayout(sidebar, BoxLayout.Y_AXIS));

        JButton accueil = new JButton("Accueil");
        accueil.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        accueil.setFocusable(false);
        sidebar.add(accueil);

        JButton membres = new JButton("gérer les membres");
        membres.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        membres.setFocusable(false);
        sidebar.add(membres); 


        JButton demandeAdh = new JButton("Les demandes d'adhésions");
        demandeAdh.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        demandeAdh.setFocusable(false);
        sidebar.add(demandeAdh); 


        JButton plan = new JButton("plan de la biblio");
        plan.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        plan.setFocusable(false);
        sidebar.add(plan);


        JButton livres = new JButton("gérer les livres");
        livres.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        livres.setFocusable(false);
        sidebar.add(livres); 

        JButton film = new JButton("gérer les films");
        film.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        film.setFocusable(false);
        sidebar.add(film);

        JButton musiques = new JButton("musiques");
        musiques.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        musiques.setFocusable(false);
        sidebar.add(musiques);

        JButton activite = new JButton("gérer les activités");
        activite.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        activite.setFocusable(false);
        sidebar.add(activite);

        JButton deconnexion = new JButton("deconnexion");
        deconnexion.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        deconnexion.setFocusable(false);
        sidebar.add(deconnexion);
        
        content.add(sidebar, BorderLayout.WEST);
        
        add(content);

        setSize(800, 600);
        setVisible(true);
        
        accueil.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                AccueilEmployer accueil = new AccueilEmployer();
                accueil.setVisible(true);
                dispose();
            }
        });
        
        livres.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                GestionLivres livres = new GestionLivres();
                livres.setVisible(true);
                dispose();
            }
        });
        
        film.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
            	GestionFilms films = new GestionFilms();
            	films.setVisible(true);
                dispose();
            }
        });
        
        musiques.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
            	GestionMusiques musiques = new GestionMusiques();
            	musiques.setVisible(true);
                dispose();
            }
        });
        
        deconnexion.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                FenetrePrincipale deconnexion = new FenetrePrincipale();
                deconnexion.setVisible(true);
                dispose();
            }
        });
    }



	private void chercherDemandes() {
		DemandesAdhesionSQL demandesql = new DemandesAdhesionSQL();
        List<Utilisateur> demandes = demandesql.chercherDemande(champRecherche.getText());
        
        tableModel.setRowCount(0);
        for (Utilisateur utilisateur : demandes) {
            Vector<Object> rowData = new Vector<>();
            rowData.add(utilisateur.getNom());
            rowData.add(utilisateur.getPrenom());
            rowData.add(utilisateur.getEmail());
            rowData.add(utilisateur.getMotDePasse());
            rowData.add(utilisateur.getTelephone());
            rowData.add(utilisateur.getDateNaissance());
            rowData.add(utilisateur.getAdresse());
            rowData.add(utilisateur.EstEmploye());
            
            tableModel.addRow(rowData);
        }
    }



	private Object refuserDemande() {
		// TODO next iteration
		return null;
	}



	private Object accepterDemande() {
		// TODO next iteration
		return null;
	}
}
        
