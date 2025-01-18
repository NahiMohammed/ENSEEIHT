(* Template to write your own non relational abstract domain. *)

(* To implement your own non relational abstract domain,
 * first give the type of its elements, *)
type t = Bot | Itv of int option * int option

 (* a printing function (useful for debuging), *)
let fprint ff = function
 | Bot -> Format.fprintf ff "⊥"
 | Itv (None, None) -> Format.fprintf ff "(-oo, +oo)"
 | Itv (None, Some b) -> Format.fprintf ff "(-oo, %d]" b
 | Itv (Some a, None) -> Format.fprintf ff "[%d, +oo)" a
 | Itv (Some a, Some b) -> Format.fprintf ff "[%d, %d]" a b


(* Extension de <= `a Z U {-oo}. *)
let leq_minf x y = match x, y with
  | None, _ -> true (* -oo <= y *)
  | _, None -> false (* x > -oo (x != -oo) *)
  | Some x, Some y -> x <= y
  (* Extension de <= `a Z U {+oo}. *)
let leq_pinf x y = match x, y with
  | _, None -> true (* x <= +oo *)
  | None, _ -> false (* +oo > y (y != +oo) *)
  | Some x, Some y -> x <= y

 (* the order of the lattice. *)
let order x y = match x, y with
    | Bot, _ -> true
    | _, Bot -> false
    | Itv (a1, b1), Itv (a2, b2) -> leq_minf a2 a1 && leq_pinf b1 b2

   
 
 (* and infimums of the lattice. *)
let top = Itv (None, None)
let bottom = Bot
 
 (* All the functions below are safe overapproximations.
  * You can keep them as this in a first implementation,
  * then refine them only when you need it to improve
  * the precision of your analyses. *)

(* [mk_itv o1 o2] retourne l'intervalle Itv (o1, o2) si o1 <= o2, Bot sinon. *)  
let mk_itv o1 o2 = match o1, o2 with
  | None, _ | _, None -> Itv (o1, o2)
  | Some n1, Some n2 -> if n1 > n2 then Bot else Itv (o1, o2)

let join x y = match x, y with
 | Bot, _ -> y
 | _, Bot -> x
 | Itv (a, b), Itv (c, d) -> Itv
   ((if leq_minf a c then a else c),  (* min a c *)
    (if leq_pinf b d then d else b))  (* max b d *)
   (* a <= b et c <= d donc min a c <= max b d donc pas besoin de mk_itv *)
 
   
let meet x y = match x, y with
  | Bot, _ | _, Bot -> Bot
  | Itv (a, b), Itv (c, d) -> mk_itv
    (if leq_minf a c then c else a)  (* max a c *)
    (if leq_pinf b d then b else d)  (* min b d *)
       (* ici par contre, on peut avoir min b d < max a c,
          donc il faut utiliser mk_itv *)
 
let widening x y =
            match x, y with
            | Bot, _ -> y
            | _, Bot -> x
            | Itv (a, b), Itv (c, d) ->
              let e = if leq_minf a c then a else None in
              let f = if leq_pinf d b then b else None in
              let new_min = match e, a with
                | None, Some v -> Some (v - 1)  (* Retarder l'élargissement en réduisant légèrement l'intervalle *)
                | _ -> e
              in
              let new_max = match f, b with
                | None, Some v -> Some (v + 1)  (* Retarder l'élargissement en augmentant légèrement l'intervalle *)
                | _ -> f
              in
              mk_itv new_min new_max
          
 
 let sem_itv n1 n2 = mk_itv (Some n1) (Some n2)
 
let sem_plus x y = match x, y with
  | Bot, _ | _, Bot -> Bot
  | Itv (a, b), Itv (c, d) ->
    (* Extension de + à Z U {-oo} ou Z U {+oo}. *)
    let plus_inf x y = match x, y with
      | None, _ | _, None -> None
      (* si x ou y est infini, x+y est infini
        (comme x et y peuvent être soit +oo soit -oo mais jamais un mix
        des deux, il n'y a pas de question sur le signe) *)
      | Some x, Some y -> Some (x + y)  (* sinon on fait la somme *) in
    Itv (plus_inf a c, plus_inf b d)
    (* a <= b et c <= d donc a + c <= b + d donc pas besoin de mk_itv *) 
let sem_minus x y = match y with
  | Bot -> Bot
  | Itv (c, d) ->
    (* Extension du - unaire à Z U {-oo} ou Z U {+oo}. *)
    let opp_inf = function None -> None | Some x -> Some (-x) in
    sem_plus x (Itv (opp_inf d, opp_inf c))  (* x - y = x + (-y)
                                                  (et -[c, d] = [-d, -c]) *)
 let sem_times x y = top
 let sem_div x y = top
 
 let sem_guard = meet (Itv (Some 1, None))

 
let backsem_plus x y r = meet x (sem_minus r y), meet y (sem_minus r x)

let backsem_minus x y r = meet x (sem_plus y r), meet y (sem_minus x r)
 let backsem_times x y r = x, y
 let backsem_div x y r = x, y
 