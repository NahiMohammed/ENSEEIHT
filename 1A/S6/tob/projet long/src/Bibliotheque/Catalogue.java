package Bibliotheque;
import java.util.*;

public class Catalogue {
    public ArrayList<Livre> livres;
    public ArrayList<Emprunt> emprunts;
    public ArrayList<Reservation> reservations;
    public ArrayList<Livre> livres_disponibles;

    public Catalogue() {
        this.livres = new ArrayList<>();
        livres.add(new Livre("1984","G.Orwell"));
        livres.add(new Livre("L'etranger","A.Camus"));
        livres.add(new Livre("Le Seigneur des Anneaux","J.R.R. Tolkien"));
        livres.add(new Livre("Les Misérables","V.Hugo"));
        livres.add(new Livre("Le Petit Prince","A. de St.Exupéry"));
        livres.add(new Livre("La nuit des temps","René Barjavel"));
        this.livres_disponibles=livres;
        this.emprunts=new ArrayList<>();
        this.reservations=new ArrayList<>();
        Emprunter_livre(new Livre("Le Petit Prince","A. de St.Exupéry"));
        Emprunter_livre(new Livre("La nuit des temps","René Barjavel"));
    }

    public void ajouterLivre(Livre livre) {
        livres.add(livre);
    }

    public void retirerLivre(Livre livre) {
        livres.remove(livre);
    }

    public ArrayList<Livre> getLivres() {
        return this.livres;
    }
    
    public ArrayList<Emprunt> getEmprunts() {
        return this.emprunts;
    }
    
    public ArrayList<Reservation> getReservations() {
        return this.reservations;
    }
    
    public ArrayList<Livre> getLivres_disponibles() {
        return this.livres_disponibles;
    }

    public void Emprunter_livre(Livre livre) {
    	Emprunt emprunt= new Emprunt(livre);
    	emprunts.add(emprunt);
    	//changer le statut emprunte du livre
    	for (int i=0; i<livres.size();i++) {
    		if (livres.get(i).getTitre()==livre.getTitre() ) {
    			livres.get(i).setEstEmprunte(true);
    		}
    			
    	}
    	////Le livre n'est plus disponible
    	for (int i=0; i<livres_disponibles.size();i++) {
    		if (livres_disponibles.get(i).getTitre()==livre.getTitre() ) {
    			livres_disponibles.remove(livres_disponibles.get(i));
    		}
    			
    	}
    			
    }
    
    public void Reserver_livre(Livre livre) {
    	Reservation reservation= new Reservation(livre);
    	reservations.add(reservation);
    	for (int i=0; i<livres.size();i++) {
    		if (livres.get(i).getTitre()==livre.getTitre() ) {
    			livres.get(i).setEstReserve(true);
    		}
    			
    	}
    	for (int i=0; i<livres_disponibles.size();i++) {
    		if (livres_disponibles.get(i).getTitre()==livre.getTitre() ) {
    			livres_disponibles.remove(livres_disponibles.get(i));
    		}
    			
    	}
    			
    }
    
    public void Prolonger_pret(Livre livre) {
    	for (int i=0; i<emprunts.size();i++) {
    		if (emprunts.get(i).getLivre()==livre ) {
    			emprunts.get(i).prolonger();
    		}
    			
    	}
    }
    
}