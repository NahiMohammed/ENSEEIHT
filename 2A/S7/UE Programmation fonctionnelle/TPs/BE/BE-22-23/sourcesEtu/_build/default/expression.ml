(* Exercice 3 *)
module type Expression = sig
  (* Type pour représenter les expressions *)
  type exp

  (* eval : exp -> int *)
  (* Évalue l'expression donnée et renvoie le résultat en tant qu'entier. *)
  val eval : exp -> int
end


(* Exercice 4 *)

module ExpAvecArbreBinaire : Expression = struct
  (* Type pour représenter les opérateurs binaires *)
  type op = Moins | Plus | Mult | Div

  (* Type pour représenter les expressions binaires *)
  type exp = Binaire of exp * op * exp | Entier of int

  (* Fonction pour évaluer une expression *)
  let rec eval expression =
    match expression with
    | Entier n -> n
    | Binaire (left, op, right) ->
      let left_value = eval left in
      let right_value = eval right in
      match op with
      | Moins -> left_value - right_value
      | Plus -> left_value + right_value
      | Mult -> left_value * right_value
      | Div -> left_value / right_value

     

let%test _ = eval (Binaire(Binaire(Entier 3, Plus, Entier 4), Moins, Entier 12)) = (-5)
let%test _ = eval (Binaire(Entier 10, Div, Entier 2))= 5
let%test _ = eval (Binaire(Binaire(Entier 4, Plus, Entier 5), Mult, Binaire(Entier 2, Moins, Entier 1)))= 9
let%test _ = eval (Binaire(Entier 5, Mult, Entier 3))= 15

end  

      


(* Exercice 5 *)

module ExpAvecArbreNaire : Expression = struct
  (* Type pour représenter les opérateurs binaires *)
  type op = Moins | Plus | Mult | Div

  (* Type pour représenter les expressions n-aires *)
  type exp = Naire of op * exp list | Valeur of int

  (* Fonction pour évaluer une expression n-aire *)
  let rec eval expression =
    match expression with
    | Valeur n -> n
    | Naire (op, operands) ->
      match op with
      | Moins ->
        (match operands with
        | hd :: tl -> List.fold_left (fun acc operand -> acc - eval operand) (eval hd) tl
        | _ -> failwith "Pas assez d'opérandes pour la soustraction")
      | Plus -> List.fold_left (fun acc operand -> acc + eval operand) 0 operands
      | Mult -> List.fold_left (fun acc operand -> acc * eval operand) 1 operands
      | Div ->
        (match operands with
        | hd :: tl -> List.fold_left (fun acc operand -> acc / eval operand) (eval hd) tl
        | _ -> failwith "Pas assez d'opérandes pour la division")

  (* Tests : Vous pouvez ajouter des tests ici *)
  let rec bienformee (expression ) : bool =
    let count_operands operands =
      List.length operands
    in
    match expression with
    | Valeur _ -> true  (* Les feuilles sont toujours bien formées *)
    | Naire (op, operands) ->
      match op with
      | Plus | Mult ->
        if count_operands operands >= 2 then
          List.for_all bienformee operands
        else
          false
      | Moins | Div ->
        if count_operands operands = 2 then
          List.for_all bienformee operands
        else
          false
  
          let en1 = Naire (Plus, [ Valeur 3; Valeur 4; Valeur 12 ])
          let en2 = Naire (Moins, [ en1; Valeur 5 ])
          let en3 = Naire (Mult, [ en1; en2; en1 ])
          let en4 = Naire (Div, [ en3; Valeur 2 ])
          let en1err = Naire (Plus, [ Valeur 3 ])
          let en2err = Naire (Moins, [ en1; Valeur 5; Valeur 4 ])
          let en3err = Naire (Mult, [ en1 ])
          let en4err = Naire (Div, [ en3; Valeur 2; Valeur 3 ])
          
          let%test _ = bienformee en1
          let%test _ = bienformee en2
          let%test _ = bienformee en3
          let%test _ = bienformee en4
          let%test _ = not (bienformee en1err)
          let%test _ = not (bienformee en2err)
          let%test _ = not (bienformee en3err)
          let%test _ = not (bienformee en4err)
end

