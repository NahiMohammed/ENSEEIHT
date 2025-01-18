package Bibliotheque;

public class VerificateurMotDePasse {

    public static boolean estValide(String motDePasse) {

    	// Vérifie la longueur
        if (motDePasse.length() < 8 && motDePasse.length() > 15) {
            return false;
        }
        
        boolean aMajuscule = false;
        boolean aMinuscule = false;
        boolean aChiffre = false;
        boolean aCarcSpec = false;
        
        
        // Vérifie chaque caractère
        for (int i = 0; i < motDePasse.length(); i++) {
            char c = motDePasse.charAt(i);
            if (Character.isUpperCase(c)) {
                aMajuscule = true;
            } else if (Character.isLowerCase(c)) {
                aMinuscule = true;
            } else if (Character.isDigit(c)) {
                aChiffre = true;
            } else if (isCaracSpec(c)) {
                aCarcSpec = true;
            }
                
       }
        
        // Vérifie qu'il y a au moins une lettre majuscule, une lettre minuscule et un chiffre et un caractere special
        if (!aMajuscule || !aMinuscule || !aChiffre || !aCarcSpec) {
            return false;
        }
        
        return true;
    }

    public static boolean isCaracSpec(char cr) {
        // Vérifie si le caractère est un caractère spécial
        // Retourne true s'il est spécial, false sinon
        char[] caracteresSpeciaux = {'!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '-', '=', '{', '}', '|', '[', ']', '\\', ':', '\"', ';', '\'', '<', '>', '?', ',', '.', '/'};
        for (char c : caracteresSpeciaux) {
             if (c == cr) {
             return true;
             }
        }
    return false;
    }

}

