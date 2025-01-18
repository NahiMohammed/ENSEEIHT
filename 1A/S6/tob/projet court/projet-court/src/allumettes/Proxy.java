package allumettes;

public class Proxy implements Jeu{
	
	private implantationJeu jeu;
	
	public Proxy(implantationJeu jeuEnCours) {
		
		assert (jeuEnCours != null);
		this.jeu=jeuEnCours;
	}
	@Override
	public int getNombreAllumettes() {

		return this.jeu.getNombreAllumettes();
	}

	@Override
	public void retirer(int nbPrises) throws OperationInterditeException {
		throw new OperationInterditeException("..");
	}
}