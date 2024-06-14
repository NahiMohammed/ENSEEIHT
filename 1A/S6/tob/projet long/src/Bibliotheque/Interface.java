package Bibliotheque;

import javax.swing.*;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;
import java.util.Vector;

/**
 * La classe principale qui démarre l'application du gestion du bibliotheque.
 */



/**
 * La classe FenetrePrincipale représente la fenêtre 
 * principale de l'application.
 */

class FenetrePrincipale extends JFrame {

    public FenetrePrincipale() {
    	JFrame fenetre = new JFrame("Ma bibliothèque");

        Container contenu = fenetre.getContentPane();
        contenu.setLayout(new BorderLayout());

        JPanel boutons = new JPanel(new FlowLayout());
        contenu.add(boutons, BorderLayout.CENTER);

        JButton btnEmploye = new JButton("Employé");
        boutons.add(btnEmploye);

        JButton btnUtilisateur = new JButton("Utilisateur");
        boutons.add(btnUtilisateur);

        JButton btnInscription = new JButton("S'inscrire");
        boutons.add(btnInscription);

        fenetre.pack();
        fenetre.setVisible(true);

        btnInscription.addActionListener(new ActionListener() 
           {
               @Override
               public void actionPerformed(ActionEvent e) {
                  fenetre.dispose(); // Ferme la fenêtre principale
                  new FenetreInscription();
                }
           }
        );

        btnEmploye.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                fenetre.dispose(); // Ferme la fenêtre principale
                new FenetreConnexionEmploye();
            }
        });

        btnUtilisateur.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                fenetre.dispose(); // Ferme la fenêtre principale
                new FenetreConnexionUtilisateur();
            }
        });

        
        

    }
}

/**
 * La classe FenetreInscription représente la fenêtre d'inscription 
 * pour un nouveau utilisateur.
 */

class FenetreInscription extends JFrame {
	
	


    public FenetreInscription() {
    	JFrame fenetre = new JFrame("Inscription");
       

        Container contenu = fenetre.getContentPane();
        contenu.setLayout(new BorderLayout());

        JPanel formulaire = new JPanel(new GridLayout(8, 2));
        contenu.add(formulaire, BorderLayout.CENTER);

        formulaire.add(new JLabel("Nom :"));
        JTextField txtNom = new JTextField();
        formulaire.add(txtNom);
        
        formulaire.add(new JLabel("Prénom :"));
        JTextField txtPrenom = new JTextField();
        formulaire.add(txtPrenom);
        
        formulaire.add(new JLabel("Adresse mail : "));
        JTextField txtEmail = new JTextField();
        formulaire.add(txtEmail);
        
        formulaire.add(new JLabel("Mot de passe :"));
        JTextField txtMotDePasse = new JPasswordField();
        formulaire.add(txtMotDePasse);
        
        formulaire.add(new JLabel("Numéro de téléphone :"));
        JTextField txtTelephone = new JTextField();
        formulaire.add(txtTelephone);


        formulaire.add(new JLabel("Date de naissance (JJ/MM/AAAA):"));
        JTextField txtDateNaissance = new JTextField();
        formulaire.add(txtDateNaissance);
        
        formulaire.add(new JLabel("Adresse :"));
        JTextField txtAdresse = new JTextField();
        formulaire.add(txtAdresse);

        JCheckBox chkEmploye = new JCheckBox("Envoyer en tant qu'employé");
        formulaire.add(chkEmploye);


        JPanel boutons = new JPanel(new FlowLayout());
        contenu.add(boutons, BorderLayout.SOUTH);

        JButton btnEnvoyer = new JButton("Envoyer ma demande d'adhésion");
        boutons.add(btnEnvoyer);

        fenetre.pack();
        fenetre.setVisible(true);
        
        


        btnEnvoyer.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e)  {
        	String nom = txtNom.getText();
        	String prenom = txtPrenom.getText();
        	String Email = txtEmail.getText();
        	String mdp = txtMotDePasse.getText();
        	String telephone = txtTelephone.getText();
        	String date_naissance = txtDateNaissance.getText();
        	String adresse = txtAdresse.getText();
            boolean estEmploye = chkEmploye.isSelected();
            
            Utilisateur utilisateur = new Utilisateur(nom,prenom,adresse,Email,telephone,mdp,date_naissance,estEmploye);
            
            DemandesAdhesionSQL demandesql = new DemandesAdhesionSQL();
            demandesql.ajouterDemande(utilisateur);
            JOptionPane.showMessageDialog(null, "Votre demande d'adhésion a été envoyée.");
            System.exit(0);
           
           }
            
        });

    }
}

class FenetreConnexionUtilisateur extends JFrame {

    public FenetreConnexionUtilisateur() {
    	JFrame fenetre = new JFrame("Connexion utilisateur");

        Container contenu = fenetre.getContentPane();
        contenu.setLayout(new BorderLayout());

        JPanel formulaire = new JPanel(new GridLayout(2, 2));
        contenu.add(formulaire, BorderLayout.CENTER);

        formulaire.add(new JLabel("Nom d'utilisateur"));
        JTextField txtNomUtilisateur = new JTextField();
        formulaire.add(txtNomUtilisateur);

        formulaire.add(new JLabel("Mot de passe"));
        JPasswordField txtMotDePasse = new JPasswordField();
        formulaire.add(txtMotDePasse);

        JPanel boutons = new JPanel(new FlowLayout());
        contenu.add(boutons, BorderLayout.SOUTH);

        JButton btnConnexion = new JButton("Se connecter");
        boutons.add(btnConnexion);

        fenetre.pack();
        fenetre.setVisible(true);

        btnConnexion.addActionListener(new ActionListener() 
           {
               @Override
               public void actionPerformed(ActionEvent e) {
                  String nomUtilisateur = txtNomUtilisateur.getText();
                  String motDePasse = new String(txtMotDePasse.getPassword());

                  // Vérifier les informations de connexion de l'utilisateur ici
                

                  fenetre.dispose(); // Ferme la fenêtre de connexion
                  // Ouvrir l'interface de l'utilisateur connecté ici
                  Accueil accueil = new Accueil (new Catalogue());
                  accueil.setVisible(true);
                }
           }
        );
    }
}

class FenetreConnexionEmploye extends JFrame {

    public FenetreConnexionEmploye() {
    	JFrame fenetre = new JFrame("Connexion Employé");

        Container contenu = fenetre.getContentPane();
        contenu.setLayout(new BorderLayout());

        JPanel formulaire = new JPanel(new GridLayout(2, 2));
        contenu.add(formulaire, BorderLayout.CENTER);

        formulaire.add(new JLabel("Nom d'employé"));
        JTextField txtNomEmploye = new JTextField();
        formulaire.add(txtNomEmploye);

        formulaire.add(new JLabel("Mot de passe"));
        JPasswordField txtMotDePasse = new JPasswordField();
        formulaire.add(txtMotDePasse);

        JPanel boutons = new JPanel(new FlowLayout());
        contenu.add(boutons, BorderLayout.SOUTH);

        JButton btnConnexion = new JButton("Se connecter");
        boutons.add(btnConnexion);

        fenetre.pack();
        fenetre.setVisible(true);

        btnConnexion.addActionListener(new ActionListener() 
           {
               @Override
               public void actionPerformed(ActionEvent e) {
                  String NomEmploye = txtNomEmploye.getText();
                  String motDePasse = new String(txtMotDePasse.getPassword());

                  // Vérifier les informations de connexion de l'employe ici
                

                  fenetre.dispose(); // Ferme la fenêtre de connexion
                  // Ouvrir l'interface de l'Employe connecté ici

                  AccueilEmployer accueilemp = new AccueilEmployer ();
                  accueilemp.setVisible(true);
                }
           }
        );
    }
}
