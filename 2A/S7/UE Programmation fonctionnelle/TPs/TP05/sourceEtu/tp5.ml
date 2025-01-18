(* Evaluation des expressions simples *)
type env = (string * int) list
(* Module abstrayant les expressions *)


module type ExprSimple =
sig
  type t
  val const : int -> t
  val plus : t -> t -> t
  val mult : t-> t -> t
end
module type ExprVar =
sig
  type t
  val var : string -> t
  val define : string -> t -> t -> t
end
module type Expr =
sig
  include ExprSimple
  include ExprVar with type t := t
end



(* Module réalisant l'évaluation d'une expression *)
module EvalSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = c
  let plus e1 e2 = e1 + e2
  let mult e1 e2 = e1 * e2
end
module EvalSimpleEnv : ExprSimple with type t = env -> int=
struct
  type t = env -> int
  let const c env = c
  let plus e1 e2 env = (e1 env) + (e2 env)
  let mult e1 e2 env = (e1 env) * (e2 env)
end
module EvalVar : ExprVar with type t = env -> int =
struct
  type t = env -> int
  let var x env = List.assoc x env
  let define x e1 e2 env = e2 ((x, e1 env) :: env)
end
module Eval : Expr with type t = env-> int =
struct
  include EvalSimpleEnv
  include EvalVar
end



module PrintSimple : ExprSimple with type t = string =
struct
  type t = string
  let const c = string_of_int c
  let plus e1 e2 = "(" ^ e1 ^ " + " ^ e2 ^ ")"
  let mult e1 e2 = "(" ^ e1 ^ " * " ^ e2 ^ ")"
end
module PrintVar : ExprVar with type t = string =
struct
  type t = string
  let var v = v
  let define v expr1 expr2 = "let " ^ v ^ " = " ^ expr1 ^ " in " ^ expr2
  let let_in v expr1 expr2 = "let " ^ v ^ " = " ^ expr1 ^ " in " ^ expr2
end
module Print : Expr with type t = string =
struct
  include PrintSimple
  include PrintVar 
end



module CompteSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = 0
  let plus e1 e2 = e1 + e2 + 1
  let mult e1 e2 = e1 + e2 + 1
end



(* Solution 1 pour tester *)
(* A l'aide de foncteur *)
(* Définition des expressions *)
module ExemplesSimples (E:ExprSimple) =
struct
  (* 1+(2*3) *)
  let exemple1  = E.(plus (const 1) (mult (const 2) (const 3)) )
  (* (5+2)*(2*3) *)
  let exemple2 =  E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )
end

(* Module d'évaluation des exemples *)
module EvalExemples =  ExemplesSimples (EvalSimple)
let%test _ = (EvalExemples.exemple1 = 7)
let%test _ = (EvalExemples.exemple2 = 42)

module PrintExemples = ExemplesSimples (PrintSimple)
let%test _ = (PrintExemples.exemple1 = "(1 + (2 * 3))")
let%test _ = (PrintExemples.exemple2 = "((5 + 2) * (2 * 3))")

module CompteExemples = ExemplesSimples (CompteSimple)
let%test _ = (CompteExemples.exemple1 = 2)
let%test _ = (CompteExemples.exemple2 = 3)


module ExprGeneric (E : Expr) =
struct
  open E
  let example1 =
    define "x" (plus (const 1) (const 2)) (mult (var "x") (const 3))
end

module Exemples (E:Expr) =
struct
  let exemple11  = E.(define "x" (plus (const 1) (const 2)) (mult (var "x") (const 3)))
end
module PrintExemples2 = Exemples(Print)
let%test _ = (PrintExemples2.exemple11 = "let x = (1 + 2) in (x * 3)")


module EvalExemplesSimple = ExemplesSimples (EvalSimpleEnv)
module EvalExemplesGeneric = ExprGeneric (Eval)

