package Bibliotheque;
import java.util.*;
public class Emprunt {
    private Livre livre;
    private Date dateEmprunt;
    private Date dateRetour;

    public Emprunt(Livre livre) {
        this.livre = livre;
        this.dateEmprunt = new Date();
        Calendar cal = Calendar.getInstance();
        cal.setTime(this.dateEmprunt);
        cal.add(Calendar.MONTH, 1);
        this.dateRetour = cal.getTime();
    }

    public Livre getLivre() {
        return livre;
    }

    public Date getDate_Emprunt() {
        return dateEmprunt;
    }

    public Date getDate_Retour() {
        return dateRetour;
    }

    public void setDate_Emprunt(Date dateEmprunt) {
        this.dateEmprunt = dateEmprunt;
    }

    public void setDate_Retour(Date dateRetour) {
        this.dateRetour = dateRetour;
    }
    
    public void prolonger() { 
        Calendar cal = Calendar.getInstance();
        cal.setTime(this.dateRetour);
        cal.add(Calendar.DAY_OF_MONTH, 15);
        this.dateRetour = cal.getTime();  	
    }


}