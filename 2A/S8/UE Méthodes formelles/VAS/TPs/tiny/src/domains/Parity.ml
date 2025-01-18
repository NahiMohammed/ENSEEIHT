(* Template to write your own non relational abstract domain. *)

(* To implement your own non relational abstract domain,
 * first give the type of its elements, *)
 type t = T | B | Even of int| Odd of int

 (* a printing function (useful for debuging), *)
 let fprint ff = function
   | T -> Format.fprintf ff "(top)"
   | B -> Format.fprintf ff "(bottom)"
   | Even x -> Format.fprintf ff "(Even : %x)" x
   | Odd x -> Format.fprintf ff "(Odd : %x)" x
 
 (* the order of the lattice. *)
 let order x y =
 match x, y with
   | B, _ -> true
   | _, T -> true
   | Even x, Even y | Even x, Odd y | Odd x, Even y| Odd x, Odd y -> x < y
   | Even _, B | Odd _, B -> false
   | T, (Even _ | B|Odd _)  -> false
 
 (* and infimums of the lattice. *)
 let top = (T)
 let bottom = (B)
 
 (* All the functions below are safe overapproximations.
  * You can keep them as this in a first implementation,
  * then refine them only when you need it to improve
  * the precision of your analyses. *)
 
 let join x y =
 match x, y with
   | B, x | x, B -> x
   | T, y | y, T -> T
   | Even x, Odd y | Odd x, Even y ->  T
   | Even x, Even y ->  Even x 
   | Odd x, Odd y ->   Odd x 
 
 let meet x y =
 match x, y with
   | B, x | x, B -> B
   | T, y | y, T -> y
   | Even x, Odd y | Odd x, Even y ->  B
   | Even x, Even y ->   Even x 
   | Odd x, Odd y ->   Odd x 
 
 let widening = join  (* Ok, maybe you'll need to implement this one if your
                       * lattice has infinite ascending chains and you want
                       * your analyses to terminate. *)
 
 let sem_itv n1 n2 =
   if n1 == n2 then
     if n1 mod 2 == 0 then
       Even n1
     else
       Odd n1
   else 
     if n1 > n2 then B else T
 
 let sem_plus x y =
 match x, y with
 | B, _ | _, B -> B
 | T, _ | _, T -> T
 | Even x, Odd y | Odd x, Even y ->  Odd (x + y)
 | Even x, Even y | Odd x, Odd y ->  Even (x + y) 
 
 let sem_minus x y =
 match x, y with
 | B, _ | _, B -> B
 | T, _ | _, T -> T
 | Even x, Odd y | Odd x, Even y ->  Odd (x - y)
 | Even x, Even y | Odd x, Odd y ->  Even (x - y) 
 
 let sem_times x y = 
 match x, y with
 | B, _ | _, B -> B
 | T, _ | _, T -> T
 | Even x, Odd y | Odd x, Even y | Even x, Even y ->  Even (x * y)
 | Odd x, Odd y ->  Odd (x * y) 
 
 let sem_div x y = top
 
 let sem_guard = function
 | B -> B
 | T -> T
 | (Even i) as c -> if i > 0 then c else B
 | (Odd i) as c -> if i > 0 then c else B
 
 let backsem_plus x y r = x, y
 let backsem_minus x y r = x, y
 let backsem_times x y r = x, y
 let backsem_div x y r = x, y