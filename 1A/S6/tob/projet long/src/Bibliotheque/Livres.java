package Bibliotheque;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;
import javax.swing.table.*;

public class Livres extends JFrame {
    public Livres(Catalogue catalogue) {
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
        sidebar.setBackground(Color.WHITE);
        sidebar.setLayout(new BoxLayout(sidebar, BoxLayout.Y_AXIS));

        JButton livres = new JButton();
        livres.setText("Livres");
        livres.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        livres.setFocusable(false);
        livres.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Livres livres = new Livres(catalogue);
                livres.setVisible(true);
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
                setVisible(false);
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
                setVisible(false);
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
                setVisible(false);
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
        
        String[] columnNames = {"NO", "Title", "Author"};
        DefaultTableModel tableModel = new DefaultTableModel(columnNames, 0);

        int no = 1;
        for (Livre livre : catalogue.getLivres_disponibles()) {
            Object[] rowData = {no++, livre.getTitre(), livre.getAuteur()};
            tableModel.addRow(rowData);
        }
        JTable Table_livres = new JTable(tableModel);
        JScrollPane scrollPane = new JScrollPane(Table_livres);
        scrollPane.setPreferredSize(new Dimension(600, 750));
        content.add(scrollPane, BorderLayout.CENTER);
        

        JComboBox<Integer> Numeros = new JComboBox<Integer>();
        for (int i = 1; i <= catalogue.getLivres_disponibles().size(); i++) {
            Numeros.addItem(i);
        }

        JButton BoutonReserver = new JButton("Réserver");
        BoutonReserver.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                int Index = Numeros.getSelectedIndex();
                if (Index >= 0) {
                    catalogue.Reserver_livre(catalogue.getLivres_disponibles().get(Index));
                    JOptionPane.showMessageDialog(Livres.this, "Le livre a été réservé. Vous pouvez le trouver dans la rubrique Réservations");
                    setVisible(false);
                    Livres livres_actualise = new Livres(catalogue);
                    livres_actualise.setVisible(true);
                } 
            }
        });

        JPanel Selection = new JPanel(new FlowLayout());
        Selection.add(new JLabel("Choisir le numéro du livre : "));
        Selection.add(Numeros);
        Selection.add(BoutonReserver);
        content.add(Selection, BorderLayout.SOUTH);


        
        
        add(content);
        
    }
}