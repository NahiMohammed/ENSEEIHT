package Bibliotheque;
import java.util.*;
public class Reservation {
    private Livre livre;
    private Date dateReservation;
    
    public Reservation(Livre livre) {
        this.livre = livre;
        this.dateReservation = new Date();
    }
    public Livre getLivre() {
    	return this.livre;
    }
    
    public Date getDateReservation() {
    	return this.dateReservation;
    }
}
