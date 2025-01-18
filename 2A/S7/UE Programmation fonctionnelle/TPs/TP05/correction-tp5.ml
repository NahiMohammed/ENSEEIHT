(* Exercice 1 - évaluation des expressions simples *)


(* Module abstrayant les expressions *)
module type ExprSimple =
sig
  type t
  val const : int -> t
  val plus : t -> t -> t
  val mult : t-> t -> t
end

(* Module réalisant l'évaluation d'une expression *)
module EvalSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = c
  let plus e1 e2 = e1 + e2
  let mult e1 e2 = e1 * e2
end


(* Solution 1 pour tester *)
(* A l'aide de foncteur *)

(* Définition des expressions *)
module ExemplesSimples (E:ExprSimple) =
struct
  let exemple1  = E.(plus (const 1) (mult (const 2) (const 3)) )
  let exemple2 =  E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )
end

(* Module d'évaluation des exemples *)
module EvalExemples =  ExemplesSimples (EvalSimple)

let%test _ = (EvalExemples.exemple1 = 7)
let%test _ = (EvalExemples.exemple2 = 42)


(* Exercice 2 - Ajout d'un traitement *)


(* Module réalisant la conversion en chaîne de caractère d'une expression *)
module PrintSimple : ExprSimple with type t = string =
struct
  type t = string
  let const c = string_of_int c
  let plus e1 e2 = "("^e1^"+"^e2^")"
  let mult e1 e2 = "("^e1^"*"^e2^")"
end

(* Solution 1 pour tester *)
(* A l'aide de foncteur *)

(* Module d'affichage des exemples *)
module PrintExemples = ExemplesSimples (PrintSimple)

let%test _ = (PrintExemples.exemple1 = "(1+(2*3))")
let%test _ = (PrintExemples.exemple2 = "((5+2)*(2*3))")


(* Module comptant le nombre d'opérations effectuée *)
module CompteSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = 0
  let plus e1 e2 = e1+e2+1
  let mult e1 e2 = e1+e2+1
end

(* Solution 1 pour tester *)
(* A l'aide de foncteur *)

(* Module d'affichage des exemples *)
module CompteExemples = ExemplesSimples (CompteSimple)

let%test _ = (CompteExemples.exemple1 = 2)
let%test _ = (CompteExemples.exemple2 = 3)


(* Exercice 3 - Ajout des variables aux expressions *)

module type ExprVar =
sig
  type t
  type tname = string
  val var : tname -> t
  val def : (tname * t) -> t -> t
end

module type Expr =
sig
  include ExprSimple
  (* on définit le type t de ExprVar comme étant celui de Exprsimple *)
  include (ExprVar with type t := t)
end

(* Exercice 4 - extension du module d'affichage *)

(* Module réalisant la conversion en chaîne de caractère d'une expression *)
module PrintVar : ExprVar with type t = string =
struct
  type t = string
  type tname = string
  let var n = n
  let def (n,i) e = "let "^n^" = "^i^" in "^e
end

module Print : Expr with type t = string =
struct
  include PrintSimple
  include (PrintVar : ExprVar with type t := t)
end


(* Solution 1 pour tester *)
(* A l'aide de foncteur *)

(* Définition des expressions *)
module ExemplesVars (E : Expr) =
struct
  include ExemplesSimples(E)
  let exemple3 = E.def ("x", E.plus (E.const 1) (E.const 2)) (E.mult (E.var "x") (E.const 3))
end

(* Module d'affichage des exemples *)
module PrintExemples2 = ExemplesVars (Print)
let%test _ = (PrintExemples2.exemple3 = "let x = (1+2) in (x*3)")
let%test _ = (PrintExemples2.exemple1 = "(1+(2*3))")
let%test _ = (PrintExemples2.exemple2 = "((5+2)*(2*3))")

(* Exercice 5 - extension du module d'évaluation *)


type env = (string * int) list

(* Module réalisant l'évaluation d'une expression *)
module EvalVar : ExprVar with type t = env -> int =
struct
  type t = env -> int
  type tname = string
  let var n = fun env -> List.assoc n env
  let def (n,i) e = fun env -> e ((n,i env)::env)
end

(* Besoin de reprendre l'évaluation des expressions simples *)
module EvalSimpleEnv : ExprSimple with type t = env -> int =
struct
  type t =  env -> int
  let const c = fun env ->  c
  let plus e1 e2 = fun env -> ((e1 env) + (e2 env))
  let mult e1 e2 = fun env -> ( (e1 env) * (e2 env))
end


module Eval : Expr  with type t = env -> int =
struct
  include EvalSimpleEnv
  include (EvalVar : ExprVar with type t := t)
end

(* Solution 1 pour tester *)
(* A l'aide de foncteur *)
(* Module d'évaluation des exemples *)
module EvalExemplesVars = ExemplesVars (Eval)

let%test _ = (EvalExemplesVars.exemple3 [] = 9)

(* Tests de non regression *)
(* on rejoue les anciens tests sur les expressions simples *)
module EvalExemplesSimples = ExemplesSimples (Eval)
let%test _ = (EvalExemplesSimples.exemple1 [] = 7)
let%test _ = (EvalExemplesSimples.exemple2 [] = 42)
