package Bibliotheque;

import javax.swing.*;

import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.Vector;
import java.util.List;

/**
 * La classe GestionMusiques est utilisée pour gérer les musiques dans la bibliothèque.
 * Elle fournit une interface graphique pour ajouter, modifier et supprimer des musiques.
 */

public class GestionMusiques extends JFrame {

	/** Champ de recherche.*/
    private JTextField champRecherche;
    /** Bouton de recherche.*/
    private JButton boutonRecherche;
    /** Tableau des films. */
    private JTable tableau;
    /** Modèle de tableau pour les films.*/
    private DefaultTableModel tableModel;
    /**Champs de saisie pour les détails du film. */
    private JTextField idField;
    private JTextField titleField;
    private JTextField authorField;
    private JTextField dureeField;
    private JTextField categoryField;
    private JTextField locationField;
    /** Case à cocher pour la disponibilité.*/
    private JCheckBox availableCheckBox;
    /**Boutons pour ajouter, modifier et supprimer des livres.*/
    private JButton addButton;
    private JButton updateButton;
    private JButton supprimerButton;

    /**
     * Constructeur de la classe GestionMusiques.
     * Il initialise l'interface graphique
     */
    public GestionMusiques() {
        setTitle("Gestion musiques");
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLayout(new BorderLayout());
        
        JPanel content = new JPanel();
        content.setBackground(Color.BLUE);
        content.setLayout(new BorderLayout());

        // Barre de recherche
        JPanel searchPanel = new JPanel();
        champRecherche = new JTextField(20);
        boutonRecherche = new JButton("Rechercher");
        boutonRecherche.addActionListener(e -> chercherMusiques());
        searchPanel.add(champRecherche);
        searchPanel.add(boutonRecherche);
        content.add(searchPanel, BorderLayout.NORTH);

        // Tableau des musiques
        tableModel = new DefaultTableModel(new String[]{"ID", "Titre", "Artiste","Duree", "Catégorie", "Emplacement", "Disponible"}, 0);
        tableau = new JTable(tableModel);
        
     // Ajout de l'écouteur de la souris
        tableau.addMouseListener(new MouseAdapter() {
         public void mouseClicked(MouseEvent e) {
             int row = tableau.getSelectedRow();
             String id = tableau.getModel().getValueAt(row, 0).toString();
             String titre = tableau.getModel().getValueAt(row, 1).toString();
             String auteur = tableau.getModel().getValueAt(row, 2).toString();
             String duree = tableau.getModel().getValueAt(row, 3).toString();
             String categorie = tableau.getModel().getValueAt(row, 4).toString();
             String emplacement = tableau.getModel().getValueAt(row, 5).toString();
             Boolean disponible = (Boolean) tableau.getModel().getValueAt(row, 6);

             //remplir les champs de formulaire
             idField.setText(id);
             titleField.setText(titre);
             authorField.setText(auteur);
             dureeField.setText(duree);
             categoryField.setText(categorie);
             locationField.setText(emplacement);
             availableCheckBox.setSelected(disponible);
         }
     });
        
        JScrollPane booksTableScrollPane = new JScrollPane(tableau);
        content.add(booksTableScrollPane, BorderLayout.CENTER);
        chercherMusiques(); // Afficher la liste des films

     // Formulaire pour ajouter ,modifier ou supprimer une musique
        JPanel addBookPanel = new JPanel();
        addBookPanel.setLayout(new BoxLayout(addBookPanel, BoxLayout.Y_AXIS));

        JPanel idPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        idPanel.add(new JLabel("ID:"));
        idField = new JTextField(15);
        idPanel.add(idField);
        addBookPanel.add(idPanel);

        JPanel titlePanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        titlePanel.add(new JLabel("Titre:"));
        titleField = new JTextField(15);
        titlePanel.add(titleField);
        addBookPanel.add(titlePanel);

        JPanel authorPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        authorPanel.add(new JLabel("Réalisateur:"));
        authorField = new JTextField(15);
        authorPanel.add(authorField);
        addBookPanel.add(authorPanel);
        
        JPanel dureePanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        dureePanel.add(new JLabel("Duree:"));
        dureeField = new JTextField(15);
        dureePanel.add(dureeField);
        addBookPanel.add(dureePanel);

        JPanel categoryPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        categoryPanel.add(new JLabel("Catégorie:"));
        categoryField = new JTextField(15);
        categoryPanel.add(categoryField);
        addBookPanel.add(categoryPanel);

        JPanel locationPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        locationPanel.add(new JLabel("Emplacement:"));
        locationField = new JTextField(15);
        locationPanel.add(locationField);
        addBookPanel.add(locationPanel);

        JPanel availablePanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        availablePanel.add(new JLabel("Disponible:"));
        availableCheckBox = new JCheckBox();
        availablePanel.add(availableCheckBox);
        addBookPanel.add(availablePanel);

        JPanel buttonsPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        addButton = new JButton("Ajouter");
        addButton.addActionListener(e -> ajouterFilm());
        buttonsPanel.add(addButton);

        updateButton = new JButton("Modifier");
        updateButton.addActionListener(e -> updateMusiques());
        buttonsPanel.add(updateButton);

        supprimerButton = new JButton("Supprimer");
        supprimerButton.addActionListener(e -> supprimerMusiques());
        buttonsPanel.add(supprimerButton);

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
    
    
    /**
     * Cherche les musiques dans la base de données et met à jour la table des musiques.
     */
    private void chercherMusiques(){
    	MusiqueSQL musiqueql = new MusiqueSQL();
        List<Media> musiques = musiqueql.chercherMusiques(champRecherche.getText());
        
        tableModel.setRowCount(0);
        for (Media musique : musiques) {
            Vector<Object> rowData = new Vector<>();
            rowData.add(musique.getId());
            rowData.add(musique.getTitre());
            rowData.add(musique.getRealisateur());
            rowData.add(musique.getDuree());
            rowData.add(musique.getCategorie());
            rowData.add(musique.getEmplacement());
            rowData.add(musique.estDisponible());
            tableModel.addRow(rowData);
        }
    }

    /**
     * Ajoute une musique à la base de données.
     */
    private void ajouterFilm() {
    	int id = Integer.parseInt(idField.getText());
        String titre = titleField.getText();
        String artiste = authorField.getText();
        int duree = Integer.parseInt(dureeField.getText());
        String categorie = categoryField.getText();
        String emplacement = locationField.getText();
        boolean disponible = availableCheckBox.isSelected();
        
        Media musique = new Media(id, titre, artiste,duree, categorie, emplacement, disponible);
        
        MusiqueSQL musiqueql = new MusiqueSQL();
        
        try {
        	musiqueql.ajouterMusique(musique);
        } catch (ExceptionGestion e) {
        	JOptionPane.showMessageDialog(null, e.getMessage());
        }
        
        chercherMusiques(); // Mettre à jour la liste des livres
    }

    /**
     * Met à jour les informations d'une musique dans la base de données.
     */   
    private void updateMusiques() {
    	int id = Integer.parseInt(idField.getText());
        String titre = titleField.getText();
        String artiste = authorField.getText();
        int duree = Integer.parseInt(dureeField.getText());
        String categorie = categoryField.getText();
        String emplacement = locationField.getText();
        boolean disponible = availableCheckBox.isSelected();
        
        Media musique = new Media(id, titre, artiste,duree, categorie, emplacement, disponible);
        
        MusiqueSQL musiqueql = new MusiqueSQL();
        
        try {
        	musiqueql.updateMusique(musique);
        } catch (ExceptionGestion e) {
        	JOptionPane.showMessageDialog(null, e.getMessage());
        }
        
        chercherMusiques(); // Mettre à jour la liste des livres
    }
    
    /**
     * Supprime une musique de la base de données.
     */
    private void supprimerMusiques() {
    	int id = Integer.parseInt(idField.getText());
    	
    	MusiqueSQL musiqueql = new MusiqueSQL();
         
         try {
        	 musiqueql.supprimerMusique(id);
         } catch (ExceptionGestion e) {
        	 JOptionPane.showMessageDialog(null, e.getMessage());
         }
         
         chercherMusiques(); // Mettre à jour la liste des livres
    	
    }


    
}
