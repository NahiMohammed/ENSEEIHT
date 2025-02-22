(* module containing typical values of the floating-point format
 * used, binary16, in order to simulate binary16 computations
 * with standard ocaml float values
 *)
module Bounds =
  struct
    let name = "b16"
    (* machine epsilon = smallest representable positive value *)
    let eps = 0.000000059604645
    (* largest representable values = interval [min, max] *)
    let max = 65504.
    let min = -. max
  end

(* *)
let name = "BE"

module Itv = Intervals_double

let base_type = Ast.RealT

(* no option *)
let parse_param _ = ()

let fprint_help fmt = Format.fprintf fmt "Le domaine par défaut. Mini float en intervalles"

(* To implement your own non relational abstract domain,
 * first give the type of its elements.
 * an abstract element is a tuple x=(isNan, isMInf, isPInf, interval)
 * where:
 * - isNan  tells whether NaN is present in gamma(x)
 * - isMInf tells whether -∞  is present in gamma(x)
 * - isPInf tells whether +∞  is present in gamma(x)
 * - interval is the interval of normal values in binary16 range
 *   present in gamma(x)
 *)
type t = bool * bool * bool * Itv.t
       
(* a printing function (useful for debuging), *)
let fprint ff = function
  | (isNan, isMInf, isPInf, itv) ->
     begin
       if isNan  then Format.fprintf ff "NaN ⊔ ";
       if isMInf then Format.fprintf ff "-∞ ⊔ ";
       if isPInf then Format.fprintf ff "+∞ ⊔ ";
       Itv.fprint ff itv
     end
        
(* the order of the lattice. *)
let order (isNan1, isMInf1, isPInf1, itv1) (isNan2, isMInf2, isPInf2, itv2) =
  match (isNan1, isMInf1, isPInf1, itv1), (isNan2, isMInf2, isPInf2, itv2) with
  | (true, _ , _ ,_), (false, _, _, _ )  -> false
  | (_, true , _ ,_), (_, false, _, _ )  -> false
  | (_, _ , true ,_), (_, _, false, _ )  -> false
  | (_, _, _, itv1), (_, _, _, itv2) -> Itv.order itv1 itv2
     
(* and infimums of the lattice. *)
let top = true, true, true, Itv.top
let bottom = false, false, false, Itv.bottom

let is_bottom x = x = bottom
  
(* All the functions below are safe overapproximations.
 * You can keep them as this in a first implementation,
 * then refine them only when you need it to improve
 * the precision of your analyses. *)

 let join (isNan1, isMInf1, isPInf1, itv1) (isNan2, isMInf2, isPInf2, itv2) =
  ((isNan1 || isNan2), (isMInf1 || isMInf2), (isPInf1 || isPInf2), (Itv.join itv1 itv2)) 

let meet (isNan1, isMInf1, isPInf1, itv1) (isNan2, isMInf2, isPInf2, itv2) =
  ((isNan1 && isNan2), (isMInf1 && isMInf2), (isPInf1 && isPInf2), (Itv.meet itv1 itv2)) 

let widening (isNan1, isMInf1, isPInf1, itv1) (isNan2, isMInf2, isPInf2, itv2) =
  match Itv.widening itv1 itv2 with
  | Itv(a,b)-> (isNan1 || isNan2, isMInf1 || isMInf2 || a=None, isPInf1 || isPInf2 || b=None , Itv.widening itv1 itv2)
  | Bot -> bottom

let sem_itv n1 n2 = 
  match Itv.sem_itv n1 n2 with
  | Itv(Some a, Some b)-> (false, (a < Bounds.min) , (b > Bounds.max), Itv.sem_itv n1 n2)
  | Itv(Some a, None  )-> (false,  (a < Bounds.min) , true, Itv(Some a, None))
  | Itv(None  , Some b)-> (false, true, (b > Bounds.max), Itv(None, Some b))
  | Itv(None  , None  )-> (true, true, true, Itv(None, None))
  | Bot -> bottom


  let sem_plus x y =
    match x, y with
    | (isNan1, isMInf1, isPInf1, itv1), (isNan2, isMInf2, isPInf2, itv2) ->
      let itv = Itv.sem_plus itv1 itv2 in
      match itv with
      | Itv(Some n1, Some n2) -> (isNan1 || isNan2, isMInf1 || isMInf2 || (n1 < Bounds.min), isPInf1 || isPInf2 || (n2 > Bounds.max), itv)
      | Itv(None, Some n2) ->    (isNan1 || isNan2, true                                   , isPInf1 || isPInf2 || (n2 > Bounds.max), itv)
      | Itv(Some n1, None) ->    (isNan1 || isNan2, isMInf1 || isMInf2 || (n1 < Bounds.min), true                                   , itv)
      | Itv(None, None) ->       (isNan1 || isNan2, true                                   , true                                   , itv)
      | Bot -> bottom

let sem_minus x y = 
    match x, y with
    | (isNan1, isMInf1, isPInf1, itv1), (isNan2, isMInf2, isPInf2, itv2) ->
      let itv = Itv.sem_minus itv1 itv2 in
      match itv with
      | Itv(Some n1, Some n2) -> (isNan1 || isNan2, isMInf1 || isMInf2 || (n1 < Bounds.min), isPInf1 || isPInf2 || (n2 > Bounds.max), itv)
      | Itv(None, Some n2) ->    (isNan1 || isNan2, true                                   , isPInf1 || isPInf2 || (n2 > Bounds.max), itv)
      | Itv(Some n1, None) ->    (isNan1 || isNan2, isMInf1 || isMInf2 || (n1 < Bounds.min), true                                   , itv)
      | Itv(None, None) ->       (isNan1 || isNan2, true                                   , true                                   , itv)
      | Bot -> bottom

let sem_times x y =
  match x,y with
  | (isNan1, isMInf1, isPInf1, itv1), (isNan2, isMInf2, isPInf2, itv2) ->
    let itv = Itv.sem_times itv1 itv2 in
      match itv with
        | Itv(Some n1, Some n2) -> (isNan1 || isNan2, isMInf1 || isMInf2 || (n1 < Bounds.min), isPInf1 || isPInf2 || (n2 > Bounds.max), itv)
        | Itv(None, Some n2) ->    (isNan1 || isNan2, true                                   , isPInf1 || isPInf2 || (n2 > Bounds.max), itv)
        | Itv(Some n1, None) ->    (isNan1 || isNan2, isMInf1 || isMInf2 || (n1 < Bounds.min), true                                   , itv)
        | Itv(None, None) ->       (isNan1 || isNan2, true                                   , true                                   , itv)
        | Bot -> bottom


      
      
let sem_div x y =
  match x,y with
  | (isNan1, isMInf1, isPInf1, itv1), (isNan2, isMInf2, isPInf2, itv2) ->
    let itv = Itv.sem_div itv1 itv2 in
      match itv with
        | Itv(Some n1, Some n2) -> (isNan1 || isNan2, isMInf1 || isMInf2 || (n1 < Bounds.min), isPInf1 || isPInf2 || (n2 > Bounds.max), itv)
        | Itv(None, Some n2) ->    (isNan1 || isNan2, true                                   , isPInf1 || isPInf2 || (n2 > Bounds.max), itv)
        | Itv(Some n1, None) ->    (isNan1 || isNan2, isMInf1 || isMInf2 || (n1 < Bounds.min), true                                   , itv)
        | Itv(None, None) ->       (isNan1 || isNan2, true                                   , true                                   , itv)
        | Bot -> bottom

let sem_geq0 = meet (false, false, true, Itv( Some 0., None))


(* imprecise abstractions for trigonometric functions sine and cosine.
 * We have:
 * sin(Nan) = sin(+oo) = sin(-oo) = Nan
 * sin([a, b]) = [-1, 1]
 *)
let sem_sin ((isNan1, isMInf1, isPInf1, itv1):t) : t =
  (isNan1 || isMInf1 || isPInf1, false, false, Itv.sem_itv (-. 1.) 1.)

let sem_cos = sem_sin

let sem_exp (isNan, isMInf, isPInf, itv1) =  match itv1 with 
    | Itv.Itv((Some a, Some b)) -> (isNan, (exp a) < Bounds.min , (exp b) > Bounds.max, Itv.mk_itv (Some(exp a)) (Some(exp b)))
    | Itv.Itv(Some a, None) -> (isNan, (exp a) < Bounds.min , true, Itv.mk_itv (Some(exp a)) (None))
    |Itv.Itv (None, Some b) -> (isNan, false, (exp b) > Bounds.max, Itv.mk_itv (Some(0.)) (Some(exp b)))
    | Itv.Itv(None, None) -> (isNan, false, true, Itv.mk_itv (Some(0.)) (None))
    | Bot -> bottom



  
    
  





let sem_call funname arg_list =
  match funname, arg_list with
  | "sin", [x] -> sem_sin x
  | "cos", [x] -> sem_cos x
  | "exp", [x] -> sem_exp x
  | "ln", [x]  -> top
  | _          -> bottom 

let backsem_plus x y r = meet x (sem_minus r y), meet y (sem_minus r x)

let backsem_minus x y r = meet x (sem_plus y r), meet y (sem_minus x r)




  let backsem_times x y r =
    let backsem_times_left x y r =
      (* [contains_0 x] renvoie true si l'intervalle x contient 0 *)
      let contains_0 x = meet x (false,false,false, Itv.mk_itv (Some 0.) (Some 0.)) <> bottom in
      if contains_0 y && contains_0 r then
        x  (* si y et r peuvent être 0, x * y = r ne nous apprend rien sur x *)
      else
        meet x (sem_div r y)
    in
    backsem_times_left x y r, backsem_times_left y x r
  
let backsem_div x y r =(x,y)
  (* La division est une division euclidienne, donc x / y = z n'implique pas
         que x = z * y mais plutôt x = z * y + r avec r \in [-|y|+1, |y|-1] *)

(*      let remaining y = match y with
        | (_, _, _, Itv.Itv (Some a, Some b)) ->
          let c = max (abs_float a) (abs_float b) in
          Itv.mk_itv (Some (1. -. c)) (Some (c -. 1.))
        | _ -> top
      in
      let backsem_div_left x y r =
        meet x (sem_plus (sem_times r y) (remaining y))
      in
      let backsem_div_right x y r =
        let x' = sem_plus x (remaining y) in
        meet y (fst (backsem_times y r x'))
      in
      backsem_div_left x y r, backsem_div_right x y r*)
    