
package Bibliotheque;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;

/**
 * La classe AccueilEmployer fournit une interface graphique pour gérer la bibliothèque.
 */
class AccueilEmployer extends JFrame {

    public AccueilEmployer() {
        JFrame fenetre = new JFrame("Compte Admin");

        Container contenu = fenetre.getContentPane();
        contenu.setLayout(new BorderLayout());

        JPanel header = new JPanel();
        header.setPreferredSize(new Dimension(800, 50));
        header.setBackground(Color.BLUE);

        JTextArea text = new JTextArea();
        text.setText(" Gestion de la bibliothèque         Compte Admin");
        text.setBackground(Color.BLUE);
        text.setFont(new Font("Ink Free", Font.BOLD, 30));
        text.setEditable(false);

        header.add(text);

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

        JPanel content = new JPanel();
        content.setBackground(Color.GRAY);
        content.setLayout(new BorderLayout());
        content.add(sidebar, BorderLayout.WEST);
        content.add(header, BorderLayout.NORTH);

        JTextArea Bienvenue = new JTextArea("Bienvenue\n");
        Bienvenue.setFont(new Font("Arial", Font.BOLD, 30));

        content.add(Bienvenue, BorderLayout.CENTER);
        contenu.add(content, BorderLayout.CENTER);

        fenetre.setSize(650, 650);
        fenetre.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        fenetre.setVisible(true);

        accueil.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                AccueilEmployer accueil = new AccueilEmployer();
                accueil.setVisible(true);
                fenetre.dispose();
            }
        });


        livres.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                GestionLivres livres = new GestionLivres();
                livres.setVisible(true);
                fenetre.dispose();
            }
        });
        
        demandeAdh.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                GestionDemandesAdhesion demandeAdh = new GestionDemandesAdhesion();
                livres.setVisible(true);
                fenetre.dispose();
            }
        });
        
        
        
        film.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
            	GestionFilms films = new GestionFilms();
            	films.setVisible(true);
                fenetre.dispose();
            }
        });
        
        musiques.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
            	GestionMusiques musiques = new GestionMusiques();
            	musiques.setVisible(true);
                fenetre.dispose();
            }
        });


        deconnexion.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                FenetrePrincipale deconnexion = new FenetrePrincipale();
                deconnexion.setVisible(true);
                fenetre.dispose();
            }
        });

    }
}



