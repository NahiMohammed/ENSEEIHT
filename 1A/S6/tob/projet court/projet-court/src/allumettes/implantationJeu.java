package allumettes;

public class implantationJeu implements Jeu {
	
	private int nombreAllumettes;
	
	public implantationJeu(int nb_allumettes) {
		this.nombreAllumettes=nb_allumettes;
	}
	

	public int getNombreAllumettes() {
		return this.nombreAllumettes;
	}
	

	
	public void retirer(int nbPrises) throws CoupInvalideException {
		
		if (nbPrises < 1) {
			
	        throw new CoupInvalideException(nbPrises, "< 1");
	    } else if (nbPrises > this.nombreAllumettes) {
	        throw new CoupInvalideException(nbPrises, "> " + this.nombreAllumettes);
	    } else if (nbPrises > Jeu.PRISE_MAX) {
	        throw new CoupInvalideException(nbPrises, "> " + Jeu.PRISE_MAX);
	    }
	    this.nombreAllumettes = this.nombreAllumettes - nbPrises;
	    }
}
