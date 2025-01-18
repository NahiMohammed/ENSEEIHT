package Bibliotheque;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
class AccueilUtilisateur extends JFrame {

    public AccueilUtilisateur(Catalogue catalogue) {
        JFrame fenetre = new JFrame("Compte Utilisateur");

        Container contenu = fenetre.getContentPane();
        contenu.setLayout(new BorderLayout());

        JPanel header = new JPanel();
        header.setPreferredSize(new Dimension(800, 50));
        header.setBackground(Color.GREEN);

        JTextArea text = new JTextArea();
        text.setText("Compte Utilisateur");
        text.setBackground(Color.GREEN);
        text.setFont(new Font("Ink Free", Font.BOLD, 30));
        text.setEditable(false);

        header.add(text);

        JPanel sidebar = new JPanel();
        sidebar.setPreferredSize(new Dimension(200, 800));
        sidebar.setBackground(Color.BLUE);
        sidebar.setLayout(new BoxLayout(sidebar, BoxLayout.Y_AXIS));

        JButton livres = new JButton("Livres");
        livres.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        livres.setFocusable(false);
        sidebar.add(livres);

        JButton accueil = new JButton("Accueil");
        accueil.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        accueil.setFocusable(false);
        sidebar.add(accueil);

        JButton reservations = new JButton("Réservations");
        reservations.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        reservations.setFocusable(false);
        sidebar.add(reservations);

        JButton prets = new JButton("Prêts");
        prets.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        prets.setFocusable(false);
        sidebar.add(prets);

        JPanel content = new JPanel();
        content.setBackground(Color.GRAY);
        content.setLayout(new BorderLayout());
        content.add(sidebar, BorderLayout.WEST);
        content.add(header, BorderLayout.NORTH);

        JTextArea Bienvenue = new JTextArea("Bienvenue\n dans votre espace personnel");
        Bienvenue.setFont(new Font("Arial", Font.BOLD, 30));

        content.add(Bienvenue, BorderLayout.CENTER);
        contenu.add(content, BorderLayout.CENTER);

        fenetre.setSize(650, 650);
        fenetre.setResizable(false);
        fenetre.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        fenetre.setVisible(true);

        livres.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Livres livres = new Livres(catalogue);
                livres.setVisible(true);
                fenetre.dispose();
            }
        });

        accueil.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Accueil accueil = new Accueil(catalogue);
                accueil.setVisible(true);
                fenetre.dispose();
            }
        });

        reservations.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Reservations reservations = new Reservations(catalogue);
                reservations.setVisible(true);
                fenetre.dispose();
            }
        });

        prets.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Prets prets = new Prets(catalogue);
                prets.setVisible(true);
                fenetre.dispose();
            }
        });
    }
}
