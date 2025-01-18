(******* TRIS ******)

(*  Tri par insertion **)

(*CONTRAT
Fonction qui ajoute un élément dans une liste triée, selon un ordre donné
Type : ('a->'a->bool)->'a->'a list -> 'a list
Paramètre : ordre  ('a->'a->bool), un ordre sur les éléments de la liste
Paramètre : elt, l'élement à ajouter
Paramètre : l, la liste triée dans laquelle ajouter elt
Résultat : une liste triée avec les éléments de l, plus elt
*)

let rec insert ordre e liste = 
  match liste with 
  | []      ->   [e]
  |t::q     -> if ordre t e then t::(insert ordre e q)  else  e::liste

(* TESTS *)
let%test _ = insert (fun x y -> x<y) 3 []=[3]
let%test _ = insert (fun x y -> x<y) 3 [2;4;5]=[2;3;4;5]
let%test _ = insert (fun x y -> x > y) 6 [3;2;1]=[6;3;2;1]



(*CONTRAT
Fonction qui trie une liste, selon un ordre donné
Type : ('a->'a->bool)->'a list -> 'a list
Paramètre : ordre  ('a->'a->bool), un ordre sur les éléments de la liste
Paramètre : l, la liste à trier
Résultat : une liste triée avec les éléments de l
*)

let rec tri_insertion ordre l =
  match l with 
  | []->[]
  | t::q -> insert ordre t (tri_insertion ordre q)

(* TESTS *)
let%test _ = tri_insertion (fun x y -> x<y) [] =[]
let%test _ = tri_insertion (fun x y -> x<y) [4;2;4;3;1] =[1;2;3;4;4]
let%test _ = tri_insertion (fun x y -> x > y) [4;7;2;4;1;2;2;7]=[7;7;4;4;2;2;2;1]


(*  Tri fusion **)

(* CONTRAT
Fonction qui décompose une liste en deux listes de tailles égales à plus ou moins un élément
Paramètre : l, la liste à couper en deux
Retour : deux listes
*)

let rec scinde l =  match l with 
| [] -> [],[]
| [a] -> [a],[]
| a::b::q -> let (a1,a2)=scinde q in (a::a1,b::a2)

(* TESTS *)
(* Peuvent être modifiés selon l'algorithme choisi *)
let%test _ = scinde [1;2;3;4] = ([1;3],[2;4])
let%test _ = scinde [1;2;3] = ([1;3],[2])
let%test _ = scinde [1] = ([1],[])
let%test _ = scinde [] = ([],[])


(* Fusionne deux listes triées pour en faire une seule triée
Paramètre : ordre  ('a->'a->bool), un ordre sur les éléments de la liste
Paramètre : l1 et l2, les deux listes triées
Résultat : une liste triée avec les éléments de l1 et l2
*)

let rec fusionne ordre l1 l2 = 
  match l1,l2 with 
  |_ , []->l1
  |[],_  ->l2
  |t1::q1,t2::q2-> if ordre t1 t2 then t1::fusionne ordre q1 l2
  else t2::fusionne ordre l1 q2

(*TESTS*)
let%test _ = fusionne (fun x y -> x<y) [1;2;4;5;6] [3;4] = [1;2;3;4;4;5;6]
let%test _ = fusionne (fun x y -> x<y) [1;2;4] [3;4] = [1;2;3;4;4]
let%test _ = fusionne (fun x y -> x<y) [1;2;4] [3;4;8;9;10] = [1;2;3;4;4;8;9;10]
let%test _ = fusionne (fun x y -> x<y) [] [] = []
let%test _ = fusionne (fun x y -> x<y) [1] [] = [1]
let%test _ = fusionne (fun x y -> x<y) [] [1] = [1]
let%test _ = fusionne (fun x y -> x<y) [1] [2] = [1;2]
let%test _ = fusionne (fun x y -> x>y) [1] [2] = [2;1]


(* CONTRAT
Fonction qui trie une liste, selon un ordre donné
Type : ('a->'a->bool)->'a list -> 'a list
Paramètre : ordre  ('a->'a->bool), un ordre sur les éléments de la liste
Paramètre : l, la liste à trier
Résultat : une liste triée avec les éléments de l
*)

let rec tri_fusion ordre l =match l with 
|[] -> []
|[_]->l
| _->let (a1,a2)=scinde l in fusionne ordre (tri_fusion ordre a1) (tri_fusion ordre a2)


(* TESTS *)
let%test _ = tri_fusion (fun x y -> x<y) [] =[]
let%test _ = tri_fusion (fun x y -> x<y) [4;2;4;3;1] =[1;2;3;4;4]
let%test _ = tri_fusion (fun x y -> x > y) [4;7;2;4;1;2;2;7]=[7;7;4;4;2;2;2;1]


(*  Parsing du fichier *)
open Lexing

(* Affiche un quadruplet composé 
- du sexe des personnes ayant reçu ce prénom : 1 pour les hommes, 2 pour les femmes
- du prénom
- de l'année
- du nombre de fois où ce prénom a été donné cette année là
*)
let print_stat (sexe,nom,annee,nb) =
  Printf.eprintf "%s,%s,%d,%d%!\n" (if (sexe=1) then "M" else "F") nom annee nb

(* Analyse le fichier nat2016.txt (stratistique des prénoms entre 1900 et 2016) 
 et construit une liste de quadruplet (sexe,prénom,année,nombre d'affectation)
*)
let listStat = 
  let input = open_in "/home/nahi/Bureau/programmation fonctionnelle/TP02/sourceEtu (1)/nat2016.txt" in 
  let filebuf = Lexing.from_channel input in
  Parser.main Lexer.token filebuf
  

(* Analyse le fichier nathomme2016.txt (stratistique des prénoms d'homme commençant par un A ou un B entre 1900 et 2016) 
 et construit une liste de quadruplets (sexe,prénom,année,nombre d'affectations)
*)
let listStatHomme = 
  let input = open_in "/home/nahi/Bureau/programmation fonctionnelle/TP02/sourceEtu (1)/nathomme2016.txt" in
  let filebuf = Lexing.from_channel input in
  Parser.main Lexer.token filebuf
  

(*  Les contrats et les tests des fonctions suivantes sont à écrire *)
let sorted_listStatHomme = tri_fusion (fun (_, _, _, n1) (_, _, _, n2) -> n1 > n2) listStatHomme
 


(*EXERCICE8*)

let scinde2 liste = 
  let l= List.length liste in 
  let half_length=if l mod 2 =0 then l/2 else (l/2)+1 in
  let rec scinde_en_deux_aux lst len left_list right_list =
    match (lst, len) with
    | ([], _) -> (List.rev left_list,List.rev right_list)  
    | (_, 0) -> (List.rev left_list, lst)  
    | (hd :: tl, n) -> scinde_en_deux_aux tl (n-1) (hd :: left_list) right_list
  in scinde_en_deux_aux liste half_length [] []

let%test _ = scinde2 [1;2;3;4] = ([1;2],[3;4])
let%test _ = scinde2 [1;2;3] = ([1;2],[3])
let%test _ = scinde2 [1] = ([1],[])
let%test _ = scinde2 [] = ([],[])

let fusionne2 ordre liste1 liste2 = 
  let rec fusion_inverse ordre lst1 lst2 acc =
    match (lst1, lst2) with
    | ([], []) -> acc
    | ([], hd2 :: tl2) -> fusion_inverse ordre [] tl2 (hd2 :: acc)
    | (hd1 :: tl1, []) -> fusion_inverse ordre tl1 [] (hd1 :: acc)
    | (hd1 :: tl1, hd2 :: tl2) ->
      if ordre hd1 hd2 then
        fusion_inverse ordre tl1 lst2 (hd1 :: acc)
      else
        fusion_inverse ordre lst1 tl2 (hd2 :: acc)
  in fusion_inverse ordre liste1 liste2 []

  let%test _ = fusionne2 (fun x y -> x<y) [1;2;4;5;6] [3;4] =List.rev [1;2;3;4;4;5;6]
  let%test _ = fusionne2 (fun x y -> x<y) [1;2;4] [3;4] =List.rev [1;2;3;4;4]
  let%test _ = fusionne2 (fun x y -> x<y) [1;2;4] [3;4;8;9;10] =List.rev [1;2;3;4;4;8;9;10]
  let%test _ = fusionne2 (fun x y -> x<y) [] [] = []
  let%test _ = fusionne2 (fun x y -> x<y) [1] [] = [1]
  let%test _ = fusionne2 (fun x y -> x<y) [] [1] = [1]
  let%test _ = fusionne2 (fun x y -> x<y) [1] [2] =List.rev [1;2]
  let%test _ = fusionne2 (fun x y -> x>y) [1] [2] =List.rev [2;1] 
  let tri_fusion2 ordre liste =
    let rec divise_et_fusionne lst =
      match lst with
      | [] -> []
      | [x] -> [x]
      | _ ->
        let gauche, droite = scinde2 lst in
        fusionne2 ordre (List.rev (divise_et_fusionne gauche)) (List.rev (divise_et_fusionne droite))
    in
    divise_et_fusionne liste


    
    (* TESTS *)
let%test _ = tri_fusion2 (fun x y -> x<y) [] =[]
let%test _ = tri_fusion2 (fun x y -> x<y) [4;2;4;3;1] =List.rev [1;2;3;4;4]
let%test _ = tri_fusion2 (fun x y -> x > y) [4;7;2;4;1;2;2;7]=List.rev[7;7;4;4;2;2;2;1]


let sorted_listStat = tri_fusion2 (fun (_, _, _, n1) (_, _, _, n2) -> n1 < n2) listStat



let rec garde_n_premiers n liste =
  if n <= 0 then
    []
  else
    match liste with
    | [] -> []
    | hd :: tl -> hd :: garde_n_premiers (n - 1) tl



