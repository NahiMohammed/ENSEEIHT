package Bibliotheque;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.SimpleDateFormat;

import javax.swing.*;
import javax.swing.table.*;

public class Reservations extends JFrame {
    public Reservations(Catalogue catalogue) {
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
        
        String[] columnNames = {"NO", "Titre", "Auteur","Date de réservation"};
        DefaultTableModel tableModel = new DefaultTableModel(columnNames, 0);

        int no = 1;
        for (Reservation reservation : catalogue.getReservations()) {
        	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            Object[] rowData = {no++, reservation.getLivre().getTitre(),reservation.getLivre().getAuteur(),dateFormat.format(reservation.getDateReservation())};
            tableModel.addRow(rowData);
        }
        JTable Table_livres = new JTable(tableModel);
        JScrollPane scrollPane = new JScrollPane(Table_livres);
        scrollPane.setPreferredSize(new Dimension(600, 750));
        content.add(scrollPane, BorderLayout.CENTER);

        add(content);
        
    }
}