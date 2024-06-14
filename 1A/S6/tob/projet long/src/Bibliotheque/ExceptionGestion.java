package Bibliotheque;
/**
 * La classe ExceptionGestion représente une exception liee a la gestion de la bibliotheque.
 */
public class ExceptionGestion extends Exception {

	/** Initaliser une ConfigurationException avec le message précisé.
	  * @param message le message explicatif
	  */
	public ExceptionGestion(String message) {
		super(message);
	}

}
