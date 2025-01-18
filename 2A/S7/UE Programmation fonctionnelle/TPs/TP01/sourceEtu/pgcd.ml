(*  pgcd : int -> int -> int
fonction qui calcule le pgcd de deux nombres entiers non nuls
Paramètres a et b : les deux entiers dont on calcule le pgcd
Résultat : le pgcd *)

let pgcd a b =
  let rec pgcd_positif a b =
    if a = 0 then b
    else if b = 0 then a
    else if a = b then a
    else if a > b then pgcd_positif (a - b) b
    else pgcd_positif a (b - a)
  and valeur_absolue a = if a >= 0 then a else -a
  in
  pgcd_positif (valeur_absolue a) (valeur_absolue b)
;;

(* Deux paramètres positifs *)
(* Cas de base *)
let%test _ = pgcd 4 4 = 4
(* Cas particulier : pgcd à 1 *)
let%test _ = pgcd 1 15 = 1
let%test _ = pgcd 8 1 = 1
let%test _ = pgcd 7 3 = 1
let%test _ = pgcd 3 7 = 1
(* Cas généraux *) 
let%test _ = pgcd 4 6 = 2 
let%test _ = pgcd 15 9 = 3

(* Deux paramètres négatifs *)
(* Cas de base *)
let%test _ = pgcd (-4) (-4) = 4
(* Cas particulier : pgcd à 1 *)
let%test _ = pgcd (-1) (-15) = 1
let%test _ = pgcd (-8) (-1) = 1
let%test _ = pgcd (-7) (-3) = 1
let%test _ = pgcd (-3) (-7) = 1
(* Cas généraux *) 
let%test _ = pgcd (-4) (-6) = 2 
let%test _ = pgcd (-15) (-9) = 3

(* a>0 et b <0 *)
(* Cas de base *)
let%test _ = pgcd 4 (-4) = 4
(* Cas particulier : pgcd à 1 *)
let%test _ = pgcd 1 (-15) = 1
let%test _ = pgcd 8 (-1) = 1
let%test _ = pgcd 7 (-3) = 1
let%test _ = pgcd 3 (-7) = 1
(* Cas généraux *) 
let%test _ = pgcd 4 (-6) = 2 
let%test _ = pgcd 15 (-9) = 3

(* a <0 et b >0 *)
(* Cas de base *)
let%test _ = pgcd (-4) 4 = 4
(* Cas particulier : pgcd à 1 *)
let%test _ = pgcd (-1) 15 = 1
let%test _ = pgcd (-8) 1 = 1
let%test _ = pgcd (-7) 3 = 1
let%test _ = pgcd (-3) 7 = 1
(* Cas généraux *) 
let%test _ = pgcd (-4) 6 = 2 
let%test _ = pgcd (-15) 9 = 3