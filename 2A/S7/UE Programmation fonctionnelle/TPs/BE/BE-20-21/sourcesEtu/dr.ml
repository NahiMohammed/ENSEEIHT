(*  Module qui permet la décomposition et la recomposition de données **)
(*  Passage du type t1 vers une liste d'éléments de type t2 (décompose) **)
(*  et inversement (recopose).**)
module type DecomposeRecompose =
sig
  (*  Type de la donnée **)
  type mot
  (*  Type des symboles de l'alphabet de t1 **)
  type symbole

  val decompose : mot -> symbole list
  val recompose : symbole list -> mot
end

module DRString : DecomposeRecompose =
struct
type mot = string
type symbole = char
(******************************************************************************)
(*                                                                            *)
(*      fonction de décomposition pour les chaînes de caractères              *)
(*                                                                            *)
(*   signature : decompose : string -> char list = <fun>                      *)
(*                                                                            *)
(*   paramètre(s) : une chaîne de caractères                                  *)
(*   résultat     : la liste des caractères composant la chaîne paramètre     *)
(*                                                                            *)
(******************************************************************************)
let decompose (s : mot) : symbole list =
  let rec decompose i accu =
    if i < 0 then accu
    else decompose (i-1) (s.[i]::accu)
  in decompose (String.length s - 1) []


  let%test _ = decompose "" = []
  let%test _ = decompose "a" = ['a']
  let%test _ = decompose "aa" = ['a';'a']
  let%test _ = decompose "ab" = ['a';'b']
  let%test _ = decompose "abcdef" = ['a'; 'b'; 'c'; 'd'; 'e'; 'f']
(******************************************************************************)
(*                                                                            *)
(*      fonction de recomposition pour les chaînes de caractères              *)
(*                                                                            *)
(*   signature : recompose : char list -> string = <fun>                      *)
(*                                                                            *)
(*   paramètre(s) : une liste de caractères                                   *)
(*   résultat     : la chaîne des caractères composant la liste paramètre     *)
(*                                                                            *)
(******************************************************************************)
let recompose (lc : symbole list) : mot =
  List.fold_right (fun t q -> String.make 1 t ^ q) lc ""

let%test _ = recompose [] = ""
let%test _ = recompose ['a'] = "a"
let%test _ = recompose ['a';'a'] = "aa"
let%test _ = recompose ['a';'b'] = "ab"
let%test _ = recompose ['a'; 'b'; 'c'; 'd'; 'e'; 'f'] = "abcdef"
end

module DRNat : DecomposeRecompose =
struct
type mot = int
type symbole = int
(******************************************************************************)
(*                                                                            *)
(*      fonction de décomposition pour les entiers naturels                   *)
(*                                                                            *)
(*   signature : decompose : int ->int list = <fun>                           *)
(*                                                                            *)
(*   paramètre(s) : un entier                                                 *)
(*   résultat     : la liste des entiers composant l'entier                   *)
(*                                                                            *)
(******************************************************************************)
let decompose (s : mot) : symbole list =
  if s=0 then [0]
  else let rec decompose_aux n acc =
    if n=0 then acc
    else decompose_aux (n/10) ((n mod 10)::acc)
  in decompose_aux s []

  let%test _ = decompose 0 = [0]
  let%test _ = decompose 1 = [1]
  let%test _ = decompose 11 = [1;1]
  let%test _ = decompose 12 = [1;2]
  let%test _ = decompose 123456 = [1; 2; 3; 4; 5; 6]
(******************************************************************************)
(*                                                                            *)
(*      fonction de recomposition pour les chaînes de caractères              *)
(*                                                                            *)
(*   signature : recompose : int list -> int = <fun>                          *)
(*                                                                            *)
(*   paramètre(s) : une liste d'etiers'                                       *)
(*   résultat     :entier                                                     *)
(*                                                                            *)
(******************************************************************************)

let recompose (lc : symbole list) : mot =
  let rec recompose_aux lc acc =
    match lc with 
    |[]    ->acc
    |c::cq ->(recompose_aux cq (acc*10+c))
  in recompose_aux lc 0


  let%test _ = recompose [0] = 0
  let%test _ = recompose [1] = 1
  let%test _ = recompose [1;1] = 11
  let%test _ = recompose [1;2] = 12
  let%test _ = recompose [1; 2; 3; 4; 5; 6] = 123456

end