(* Exercice 1*)

(* max : int list -> int  *)
(* Paramètre : liste dont on cherche le maximum *)
(* Précondition : la liste n'est pas vide *)
(* Résultat :  l'élément le plus grand de la liste *)
let rec max (lst : int list) : int =
  match lst with
  | [] -> failwith "La liste est vide"
  | [x] -> x
  | hd :: tl -> List.fold_left (fun acc x -> if x > acc then x else acc) hd tl

let%test _ = max [ 1 ] = 1
let%test _ = max [ 1; 2 ] = 2
let%test _ = max [ 2; 1 ] = 2
let%test _ = max [ 1; 2; 3; 4; 3; 2; 1 ] = 4

(* max_max : int list list -> int  *)
(* Paramètre : la liste de listes dont on cherche le maximum *)
(* Précondition : il y a au moins un élement dans une des listes *)
(* Résultat :  l'élément le plus grand de la liste *)
let max_max lst =
    match lst with 
    |[] -> failwith "La liste est vide"
    |[x]->max x
    |hd::tl->List.fold_left (fun acc x -> if (max x) > acc then (max x) else acc) (max hd) tl 

let%test _ = max_max [ [ 1 ] ] = 1
let%test _ = max_max [ [ 1 ]; [ 2 ] ] = 2
let%test _ = max_max [ [ 2 ]; [ 2 ]; [ 1; 1; 2; 1; 2 ] ] = 2
let%test _ = max_max [ [ 2 ]; [ 1 ] ] = 2
let%test _ = max_max [ [ 1; 1; 2; 1 ]; [ 1; 2; 2 ] ] = 2
let%test _ = max_max [ [ 1; 1; 1 ]; [ 2; 1; 2 ]; [ 3; 2; 1; 4; 2 ]; [ 1; 3; 2 ] ] = 4


(* Exercice 2*)

(* suivant : int list -> int list *)
(* Calcule le terme suivant dans une suite de Conway *)
(* Paramètre : le terme dont on cherche le suivant *)
(* Précondition : paramètre différent de la liste vide *)
(* Retour : le terme suivant *)


(*let suivant list =
  let incrementer liste =
    match liste with 
    |c::cq->(c+1)::cq
    |[]->[]
  in
  let rec aux liste acc pre =
  match  liste with 
  | []    -> acc
  | [x]   -> [1;x] @ acc 
  | c::cq ->  if c=pre then aux cq (incrementer acc) c 
              else aux cq (List.append [1;c] acc) c
 in aux  (List.tl (List.rev list)) [1;List.hd (List.rev list)] (List.hd (List.rev list))*)
 let suivant list = 
  let rec sommer list =
    match list with 
    | []->[]
    | [c1;c2] -> [c1;c2]
    | c1::c2::c3::c4::cq -> if c2=c4 then sommer([c1+1;c4]@ cq) else [c1;c2]@(sommer ([c3;c4]@ cq))
    | _->list
  in
  let rec aux lst acc = 
    match lst with 
    |[]     ->acc
    |c::cq  -> aux cq (acc @ [1;c])
  in sommer (aux list [])

  

let%test _ = suivant [ 1 ] = [ 1; 1 ]
let%test _ = suivant [ 2 ] = [ 1; 2 ]
let%test _ = suivant [ 3 ] = [ 1; 3 ]
let%test _ = suivant [ 1; 1 ] = [ 2; 1 ]
let%test _ = suivant [ 1; 2 ] = [ 1; 1; 1; 2 ]
let%test _ = suivant [ 1; 1; 1; 1; 3; 3; 4 ] = [ 4; 1; 2; 3; 1; 4 ]
let%test _ = suivant [ 1; 1; 1; 3; 3; 4 ] = [ 3; 1; 2; 3; 1; 4 ]
let%test _ = suivant [ 1; 3; 3; 4 ] = [ 1; 1; 2; 3; 1; 4 ]
let%test _ = suivant [3;3] = [2;3]

(* suite : int -> int list -> int list list *)
(* Calcule la suite de Conway *)
(* Paramètre taille : le nombre de termes de la suite que l'on veut calculer *)
(* Paramètre depart : le terme de départ de la suite de Conway *)
(* Résultat : la suite de Conway *)
let suite  n depart =
let rec aux n  acc pre=
  if n=1 then acc 
  else let terme_suivant = [(suivant pre)] in aux (n-1) (acc @ terme_suivant ) (suivant pre )
in aux n [depart] depart
let%test _ = suite 1 [ 1 ] = [ [ 1 ] ]
let%test _ = suite 2 [ 1 ] = [ [ 1 ]; [ 1; 1 ] ]
let%test _ = suite 3 [ 1 ] = [ [ 1 ]; [ 1; 1 ]; [ 2; 1 ] ]
let%test _ = suite 4 [ 1 ] = [ [ 1 ]; [ 1; 1 ]; [ 2; 1 ]; [ 1; 2; 1; 1] ]


(* Tests de la conjecture *)
(* "Aucun terme de la suite, démarant à 1, ne comporte un chiffre supérieur à 3" *)
(* TO DO *)
(* Remarque : TO DO *)