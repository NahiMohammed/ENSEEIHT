open Util
open Mem

(* get_assoc: 'a -> ('a * 'b) list -> 'b -> 'b
   Retourne la valeur associée à la clé e dans la liste l, ou la valeur par défaut def si la clé n'existe pas.*)
 let rec get_assoc e l def =
    match l with
    | [] -> def  (* Si la liste est vide, retourne la valeur par défaut *)
    | (key, value)::rest ->  (* Sinon, examine le premier élément de la liste *)
      if key = e then value  (* Si la clé correspond, retourne la valeur *)
      else get_assoc e rest def  (* Sinon, continue de chercher dans le reste de la liste *) 
  (* Tests unitaires *)
  let%test _ = get_assoc 1 [(1, "one"); (2, "two"); (3, "three")] "not found" = "one"
  let%test _ = get_assoc 4 [(1, "one"); (2, "two"); (3, "three")] "not found" = "not found"
  let%test _ = get_assoc "x" [("x", 42); ("y", 64); ("z", 128)] 0 = 42
  

(* set_assoc : TODO
 *)
let rec set_assoc e l x = 
    match l with 
    | [] -> l @ [(e,x)]
    | (key, value)::rest -> if key = e then ([(e,x)] @ rest)
    else (key, value)::(set_assoc e rest x)

(* Tests unitaires *)
let%test _ = set_assoc 2  [(1, "one"); (2, "two"); (3, "three")] "new_two"= [(1, "one"); (2, "new_two"); (3, "three")]
let%test _ = set_assoc 4 [(1, "one"); (2, "new_two"); (3, "three")] "four"= [(1, "one"); (2, "new_two"); (3, "three"); (4, "four")]



module AssocMemory : Memory =
struct
    (* Type = liste qui associe des adresses (entiers) à des valeurs (caractères) *)
    type mem_type = (int * char) list

    (* Un type qui contient la mémoire + la taille de son bus d'adressage *)
    type mem = int * mem_type

    (* Nom de l'implémentation *)
    let name = "assoc"

    (* Taille du bus d'adressage *)
    let bussize (bs, _) = bs

    (* Taille maximale de la mémoire *)
    let size (bs, _) = pow2 bs

    (* Taille de la mémoire en mémoire *)
    let allocsize (bs, m) =
    let num_entries = List.length m in
    num_entries * 2
  

    let busyness (bs, m) =
        let count_non_default (addr, value) acc =
          if value <> _0 then acc + 1
          else acc
        in
        List.fold_right count_non_default m 0

    (* Construire une mémoire vide *)
    let clear bs = (bs, [])


    (* Lire une valeur *)
    let read (bs, m) addr =
        try
          let value = get_assoc addr m _0 in
          value
        with
        | _ -> raise OutOfBound

    (* Écrire une valeur *)
    let write (bs, m) addr value =
        if addr >= 0 && addr < (pow2 bs) then
          let updated_mem = set_assoc addr m value in
          (bs, updated_mem)
        else
          raise OutOfBound
end
