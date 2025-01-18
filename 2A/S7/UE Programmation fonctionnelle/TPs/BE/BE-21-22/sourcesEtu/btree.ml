open Util

(* Type de base : arbre binaire avec information dans les feuilles. *)
type btree = Node of btree * btree | Leaf of char

(* Un exemple pour la suite *)
let bt1 =
    Node (
        Node (
            Node (
                Leaf 'a',
                Leaf 'b'
            ),
            Leaf _0
        ), Node (
            Leaf _0,
            Node (
                Leaf 'c',
                Leaf 'd'
            )
        )
    )



(* empty_btree : btree
 * Retourne l'arbre vide (qui ne "contient que des _0")
 *)
 let rec empty_tree = Leaf '0'

(* height : btree -> int
 * Calcule la hauteur d'un arbre binaire.
 *
 * Paramètre :
 *   tr : btree, arbre dont on veut la hauteur
 * Retour :
 *   hauteur de l'arbre
 *)
 let rec height tree =
    match tree with
    | Leaf _ -> 0  (* Une feuille a une hauteur de 0. *)
    | Node (left, right) ->
      let left_height = height left in
      let right_height = height right in
      1 + max left_height right_height

let%test "height-0" =
    height (Leaf _0) = 0
let%test "height-1" =
    height (Node (Leaf _0, Node (Leaf _0, Leaf _0))) = 2
let%test "height-2" =
    height bt1 = 3

(* num_nodes : btree -> int
 * Calcule le nombre de noeuds de l'arbre passé en paramètre
 *
 * Paramètres :
 *   tr : btree, arbre dont on veut le nombre de noeuds
 * Retour :
 *   nombre de noeuds
 *)
 let rec num_nodes tree =
    match tree with
    | Leaf _ -> 1  (* Une feuille compte pour 1. *)
    | Node (left, right) ->
      let left_nodes = num_nodes left in
      let right_nodes = num_nodes right in
      1 + left_nodes + right_nodes
  

let%test "num_nodes-0" = (num_nodes (Leaf _0)) = 1
let%test "num_nodes-1" = (num_nodes (Node (Leaf 'a', Leaf 'b'))) = 3
let%test "num_nodes-2" = (num_nodes bt1) = 11

(* num_values : btree -> int
 * Calcule le nombre de valeurs stockées dans l'arbre qui ne sont pas
 * égales à _0.
 *
 * Paramètres :
 *   tr : btree, arbre dont on veut compter les valeurs
 * Retour :
 *   nombre de valeurs non nulles
 *)
 let rec num_values tree =
    match tree with
    | Leaf c ->
      if c <> _0 then 1
      else 0
    | Node (left, right) ->
      let left_values = num_values left in
      let right_values = num_values right in
      left_values + right_values
  

let%test "num_values-0" = (num_values (Leaf _0)) = 0
let%test "num_values-1" = (num_values (Leaf 'a')) = 1
let%test "num_values-2" = (num_values (Node (Leaf 'a', Leaf 'b'))) = 2
let%test "num_values-3" = (num_values bt1) = 4

(* bits : int -> int -> int list
 * Transforme une nombre binaire en liste de 0 et 1 de la taille
 * désirée, du bit le plus faible (la puissance de deux la plus basse) au
 * bit le plus fort.
 *
 * Paramètres :
 *   n : int, taille de la liste résultante
 *   addr : int, adresse
 * Retour :
 *   liste de taille n contenant les bits de addr du plus faible au plus fort
 * Pré-conditions :
 *   addr peut être codé sur n bits
 *)
 let rec bits n addr =
    if n <= 0 then
      []
    else
      let bit = addr mod 2 in
      bit :: bits (n - 1) (addr / 2)
  

let%test "bits-0" = (bits 0 546) = []
let%test "bits-1" = (bits 2   3) = [1; 1]
let%test "bits-2" = (bits 6  11) = [1; 1; 0; 1; 0; 0]
let%test "bits-3" = (bits 3 121) = [1; 0; 0]
let%test "bits-4" = (bits 0   6) = []
let%test "bits-5" = (bits 1   6) = [0]
let%test "bits-6" = (bits 2   6) = [0;1]
let%test "bits-7" = (bits 3   6) = [0;1;1]
let%test "bits-8" = (bits 4   6) = [0;1;1;0]
let%test "bits-9" = (bits 5   6) = [0;1;1;0;0]
let%test "bits-10" = (bits 4   12) = [0;0;1;1]
let%test "bits-11" = (bits 4   13) = [1;0;1;1]

(* search : btree -> int list -> char
 * Parcours un arbre binaire selon l'adresse donnée et récupère
 * la valeur au bout du chemin.
 *
 * Paramètre :
 *   tr : btree, arbre à parcourir
 *   addr : int list, addresse du chemin, sous forme de liste de bits
 * Retour :
 *   valeur à la feuille au bout du chemin, ou _0 si le chemin n'existe pas
 *
 * Pré-condition
 *   la taille de l'addresse est supérieure à la profondeur de l'arbre
 *   => traité avec une exception pour avoir un patter matching exhaustif...
 *)
 let rec search tree path =
    match (tree, path) with
    | (Leaf c, []) -> c  (* Nous avons atteint une feuille et épuisé le chemin, renvoyons la valeur de la feuille. *)
    | (Leaf _, _) | (Node (_, _), []) -> _0 (* Nous avons épuisé le chemin, mais la feuille est manquante ou le nœud n'a pas de valeur. *)
    | (Node (left, right), 0 :: rest) -> search left rest  (* Suivre le chemin à gauche (0). *)
    | (Node (left, right), 1 :: rest) -> search right rest  (* Suivre le chemin à droite (1). *)
    | (_, _) -> _0  (* Autre cas inattendu, renvoyer '0' par défaut. *)
  

let%test "search-0" =
    search bt1 [0; 0; 0] = 'a'
let%test "search-1" =
    search bt1 [0; 1; 0] = _0
let%test "search-2" =
    search bt1 [1; 0; 1] = _0
let%test "search-3" =
    search bt1 [1; 1; 0] = 'c'
let%test "search-4" =
    search bt1 [1; 1; 1] = 'd'

(* sprout : char -> int list -> btree
 * Crée un arbre contenant le chemin correspondant à l'addresse passée en
 * paramètre, au bout duquel se trouve la valeur passée en paramètre.
 * Le reste de l'arbre résultant ne contient que des _0.
 *
 * Paramètres :
 *   x : char, valeur à rajouter
 *   addrl : int list, adresse de la valeur, sous forme d'une liste de bits
 * Retour :
 *   arbre qui contient la valeur x au bout du chemin de addr et des _0 partout
 *   ailleurs
 *)
 let rec sprout x addr =
    match addr with
    | [] -> Leaf x  (* Nous avons atteint l'emplacement spécifié, créons une feuille avec la valeur x. *)
    | 0 :: rest -> Node (sprout x rest, Leaf  _0)  (* Suivre le chemin à gauche (0) et ajouter une feuille '0' à droite. *)
    | 1 :: rest -> Node (Leaf  _0, sprout x rest)  (* Suivre le chemin à droite (1) et ajouter une feuille '0' à gauche. *)
    | _ -> Leaf  _0  (* Adresse inattendue, renvoyer une feuille '0'. *)
  

let%test "sprout-0" =
    let tr = sprout 'z' [] in
        height tr = 0 &&
        search tr [] = 'z'
let%test "sprout-1" =
    let tr = sprout 'z' [0] in
        height tr = 1 &&
        search tr [0] = 'z' &&
        search tr [1] = _0
let%test "sprout-2" =
    let tr = sprout 'z' [1;0;1] in
        height tr = 3 &&
        search tr [0;0;0] = _0  &&
        search tr [1;0;0] = _0  &&
        search tr [0;1;0] = _0  &&
        search tr [1;1;0] = _0  &&
        search tr [0;0;1] = _0  &&
        search tr [1;0;1] = 'z' &&
        search tr [0;1;1] = _0  &&
        search tr [1;1;1] = _0

(* update : btree -> char -> int list -> btree
 * Remplace une valeur au chemin donné par la valeur passée en paramètre, le
 * chemin étant spécifié par une adresses (sous forme de liste de bits).
 *
 * Si le chemin n'existe pas complètement, cette fonction le crée.
 *
 * Paramètres :
 *   tr : btree, arbre à mettre à jour
 *   x : char, valeur à changer
 *   addrl : int list, adresse à modifier, sous forme de liste de bits
 * Retour :
 *   arbre modifié
 *
 * Pré-condition :
 *   la taille de l'adresse est supérieure ou égale à la profondeur de l'arbre
 *   => assuré par une exception pour avoir le pattern-matching exhaustif, mais ne 
 *   devrait pas arriver !
 *)

 let rec update tree x addr =
    match (tree, addr) with
    | (Leaf _, []) -> Leaf x  (* Nous avons atteint l'emplacement spécifié, mettons à jour la valeur. *)
    | (Leaf c, _) -> sprout x addr  (* Nous avons atteint une feuille, mais il reste des éléments dans l'adresse, construisons le bon (sous-)bit tree avec sprout. *)
    | (Node (left, right), 0 :: rest) -> Node (update left x rest, right)  (* Suivre le chemin à gauche (0) et mettre à jour le sous-arbre gauche. *)
    | (Node (left, right), 1 :: rest) -> Node (left, update right x rest)  (* Suivre le chemin à droite (1) et mettre à jour le sous-arbre droit. *)
    | (_, _) -> tree  (* Autre cas inattendu, ne modifions rien. *)
  

let%test "update-0" =
    let tr = update (Leaf _0) 'a' [] in
        height tr = 0 &&
        search tr [] = 'a'
let%test "update-1" =
    let tr = update (Node (Leaf _0, Leaf _0)) 'a' [1] in
        height tr = 1 &&
        search tr [0] = _0 &&
        search tr [1] = 'a'
let%test "update-2" =
    let tr = update bt1 'z' [0; 0; 0] in
        height bt1 = 3 &&
        search tr [0;0;0] = 'z' &&
        search tr [1;0;0] = _0  &&
        search tr [0;1;0] = _0  && 
        search tr [1;1;0] = 'c' &&
        search tr [0;0;1] = 'b' &&
        search tr [1;0;1] = _0  &&
        search tr [0;1;1] = _0  &&
        search tr [1;1;1] = 'd'
let%test "update-3" =
    let tr = update bt1 'z' [0; 1; 1] in
        height bt1 = 3 &&
        search tr [0;0;0] = 'a' &&
        search tr [1;0;0] = _0  &&
        search tr [0;1;0] = _0  &&
        search tr [1;1;0] = 'c' &&
        search tr [0;0;1] = 'b' &&
        search tr [1;0;1] = _0  &&
        search tr [0;1;1] = 'z' &&
        search tr [1;1;1] = 'd'

