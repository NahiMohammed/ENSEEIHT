package Bibliotheque;

public class verificateurEmail {

	public static boolean valider(String email) {
		boolean estValide = true;

		if (email == null) {
			estValide = false;
		}

		// l'index de l'arobase
		int arobaseIndex = email.indexOf('@');

		// l'index du dernier point dans l'email
		int pointIndex = email.lastIndexOf('.');

		// Si l'arobase ou le point sont mal placés ou s'il n'y a pas de caractères
		// entre eux ou après le dernier point, l'email n'est pas valide
		if (arobaseIndex <= 0 || pointIndex <= 0 || pointIndex < arobaseIndex || pointIndex == email.length() - 1) {
			estValide = false;
		}

		// récupèrer les différentes parties de l'email
		String premierePartie = email.substring(0, arobaseIndex);
		String deuxiemePartir = email.substring(arobaseIndex + 1, pointIndex);
		String troisiemePartie = email.substring(pointIndex + 1);

		// Si l'une des parties est vide, l'email n'est pas valide
		if (premierePartie.isEmpty() || deuxiemePartir.isEmpty() || troisiemePartie.isEmpty()) {
			estValide = false;
		}

		// vérifier si chaque caractère de la premiere partie est une lettre, un
		// chiffre, un point, un tiret ou un underscore
		for (char c : premierePartie.toCharArray()) {
			if (!Character.isLetterOrDigit(c) && c != '.' && c != '-' && c != '_') {
				estValide = false;
			}
		}

		// vérifier si chaque caractère de la deuxieme partie est une lettre, un chiffre
		// ou un tiret
		for (char c : deuxiemePartir.toCharArray()) {
			if (!Character.isLetterOrDigit(c) && c != '-') {
				estValide = false;
			}
		}

		// vérifier si chaque caractère de la troisieme partie est une lettre
		for (char c : troisiemePartie.toCharArray()) {
			if (!Character.isLetter(c)) {
				estValide = false;
			}
		}
		return estValide;
	}
}
