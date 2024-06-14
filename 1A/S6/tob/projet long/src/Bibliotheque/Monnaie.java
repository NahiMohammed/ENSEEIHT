package Bibliotheque;

public class Monnaie {
	private double montant;
	private String devise;
	
	public Monnaie(double montant, String devise) {
		this.montant = montant;
		this.devise = devise;
	
	}
    public double getMontant() {
    	return this.montant;
    }
    public String getDevise() {
    	return this.devise;
    }
    public void setMontant(double montant) {
    	this.montant = montant;
    }
    public void setDevise(String devise) {
    	this.devise = devise;
    }
}
