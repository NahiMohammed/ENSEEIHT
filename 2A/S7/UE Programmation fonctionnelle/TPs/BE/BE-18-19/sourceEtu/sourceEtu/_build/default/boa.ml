module type Regle =
sig
  (* Type des identifiants de règles *)
  type tid
  (* Type des termes *)
  type td
  (* Identifiant de la règle *)
  val id : tid
  (* Applique la règle sur un terme donné et renvoie la liste de termes résultants *)
  val appliquer : td -> td list
end

(* Regle1.ml *)
module Regle1 : Regle =
struct
type tid = int
type td = char list
let id = 1
let appliquer terme =
    match List.rev terme with
    | 'O'::rest -> [terme @ ['A']]
    | _ -> [terme]
end



module type ArbreReecriture =
sig
  (*
  type tid = int
  type td
  type arbre_reecriture = ...

  val creer_noeud : ...

  val racine : ...
  val fils : ..

  val appartient : td -> arbre_reecriture -> bool
  *)
end