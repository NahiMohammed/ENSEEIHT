package Bibliotheque;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
public class Accueil extends JFrame {

    public Accueil(Catalogue catalogue) {
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(650, 650);
        setResizable(false);

        // Create a panel for the header
        JPanel header = new JPanel();
        header.setPreferredSize(new Dimension(800, 50));
        header.setBackground(Color.GREEN);

        JTextArea text = new JTextArea();
        text.setText("Compte Utilisateur");
        text.setBackground(Color.GREEN);
        text.setFont(new Font("Ink Free", Font.BOLD, 30));
        text.setEditable(false);

        header.add(text);

        // Create a panel for the sidebar
        JPanel sidebar = new JPanel();
        sidebar.setPreferredSize(new Dimension(200, 800));
        sidebar.setBackground(Color.BLUE);
        sidebar.setLayout(new BoxLayout(sidebar, BoxLayout.Y_AXIS));

        

        JButton livres = new JButton();
        livres.setText("Livres");
        livres.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        livres.setFocusable(false);
        livres.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Livres livres = new Livres(catalogue);
                livres.setVisible(true);
                dispose();
            }
        });
        
        JButton accueil = new JButton();
        accueil.setText("Accueil");
        accueil.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        accueil.setFocusable(false);
        accueil.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Accueil accueil = new Accueil(catalogue);
                accueil.setVisible(true);
                dispose();
            }
        });

        JButton reservations = new JButton();
        reservations.setText("Réservations");
        reservations.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        reservations.setFocusable(false);
        reservations.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Reservations reservations = new Reservations(catalogue);
                reservations.setVisible(true);
                dispose();
            }
        });

        JButton prets = new JButton();
        prets.setText("Prêts");
        prets.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        prets.setFocusable(false);
        prets.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Prets prets = new Prets(catalogue);
                prets.setVisible(true);
                dispose();
            }
        });
          
	    sidebar.add(accueil);
	    sidebar.add(livres);
	    sidebar.add(reservations);
	    sidebar.add(prets);

        JPanel content = new JPanel();
        content.setBackground(Color.GRAY);
        content.setLayout(new BorderLayout());
        content.add(sidebar, BorderLayout.WEST);
        content.add(header, BorderLayout.NORTH);
        
        JTextArea Bienvenue = new JTextArea("Bienvenue\n dans votre espace personnel");
        Bienvenue.setFont(new Font("Arial", Font.BOLD, 30));
        
        content.add(Bienvenue);
        add(content);
        


        add(content);
        
    }
}
