
  (****** Algorithmes combinatoires et listes *******)


(*** Code binaires de Gray ***)

(*CONTRAT
Fonction qui génère un code de Gray
Paramètre n : la taille du code
Resultat : le code sous forme de int list list
*)

let gray_code n = 
  let rec generate_grey n =
    if n=0 then [[]] else 
    if n=1 then [[0]; [1]]
    else 
      let prev_grey =generate_grey (n-1) in
      let add_prefix prefix list = List.map (fun x -> prefix :: x) list in
      let zero_prefixed = add_prefix 0 prev_grey in
      let one_prefixed = add_prefix 1 prev_grey in
      zero_prefixed @ (List.rev one_prefixed)
    in
    generate_grey n


(* TESTS *)
let%test _ = gray_code 0 = [[]]
let%test _ = gray_code 1 = [[0]; [1]]
let%test _ = gray_code 2=  [[0; 0]; [0; 1]; [1; 1]; [1; 0]]
let%test _ = gray_code 3 = [[0; 0; 0]; [0; 0; 1]; [0; 1; 1]; [0; 1; 0]; [1; 1; 0]; [1; 1; 1]; [1; 0; 1];
 [1; 0; 0]]
 let%test _ = gray_code 4 = [[0; 0; 0; 0]; [0; 0; 0; 1]; [0; 0; 1; 1]; [0; 0; 1; 0]; [0; 1; 1; 0];
  [0; 1; 1; 1]; [0; 1; 0; 1]; [0; 1; 0; 0]; [1; 1; 0; 0]; [1; 1; 0; 1];
  [1; 1; 1; 1]; [1; 1; 1; 0]; [1; 0; 1; 0]; [1; 0; 1; 1]; [1; 0; 0; 1];
  [1; 0; 0; 0]]


(*** Combinaisons d'une liste ***)

(* CONTRAT 
[combinaisons l k] renvoie la liste de toutes les combinaisons possibles
    de [k] éléments choisis parmi la liste [l].
    
    {b Préconditions} :
    - [k] doit être un entier positif ou nul.
    
    {b Postconditions} :
    - Le résultat est une liste de listes, chaque sous-liste étant une combinaison de [k]
      éléments de la liste [l].
    - Les éléments dans chaque combinaison respectent l'ordre original dans la liste [l].
    - Si [k] est supérieur à la longueur de la liste [l], le résultat est une liste vide.
    
    {b Exemple d'utilisation} :
    [combinaisons [1; 2; 3; 4] 3] renvoie [[1; 2; 3]; [1; 2; 4]; [1; 3; 4]; [2; 3; 4]]
    [combinaisons [1; 2; 3] 0] renvoie [[]] (une seule combinaison possible : la liste vide)
    [combinaisons [] 2] renvoie [] (pas de combinaisons possibles si la liste est vide)
*)


let rec combinaisons l k =
  if k = 0 then
    [[]] (* Une seule combinaison possible : la liste vide *)
  else
    match l with
    | [] -> [] (* Pas de combinaisons possibles si la liste est vide *)
    | x :: xs ->
      let with_x = List.map (fun c -> x :: c) (combinaisons xs (k - 1)) in
      let without_x = combinaisons xs k in
      with_x @ without_x
;;

(* TESTS *)
let%test "combinaisons test 1" = combinaisons [1; 2; 3; 4] 0 = [[]]

let%test "combinaisons test 2" = combinaisons [1; 2; 3; 4] 1 = [[1]; [2]; [3]; [4]]

let%test "combinaisons test 3" =
  combinaisons [1; 2; 3; 4] 3 = [[1; 2; 3]; [1; 2; 4]; [1; 3; 4]; [2; 3; 4]]

let%test "combinaisons test 4" =
  combinaisons [1; 2; 3] 2 = [[1; 2]; [1; 3]; [2; 3]]

let%test "combinaisons test 5" = combinaisons [1; 2; 3] 4 = []

let%test "combinaisons test 6" = combinaisons [] 2 = []




(*** Permutations d'une liste ***)

(* CONTRAT
Fonction prend en paramètre un élément e et une liste l et qui insére e à toutes les possitions possibles dans l
Pamaètre e : ('a) l'élément à insérer
Paramètre l : ('a list) la liste initiale dans laquelle insérer e
Reesultat : la liste des listes avec toutes les insertions possible de e dans l
*)

let rec insertion e l = 
  match l with 
  | []   ->  [[e]]
  | t::q -> (e::l) :: (List.map (fun y ->t::y) (insertion e q))

(* TESTS *)
let%test _ = insertion 0 [1;2] = [[0;1;2];[1;0;2];[1;2;0]]
let%test _ = insertion 0 [] = [[0]]
let%test _ = insertion 3 [1;2] = [[3;1;2];[1;3;2];[1;2;3]]
let%test _ = insertion 3 [] = [[3]]
let%test _ = insertion 5 [12;54;0;3;78] =[[5; 12; 54; 0; 3; 78]; [12; 5; 54; 0; 3; 78]; [12; 54; 5; 0; 3; 78]; [12; 54; 0; 5; 3; 78]; [12; 54; 0; 3; 5; 78]; [12; 54; 0; 3; 78; 5]]
let%test _ = insertion 'x' ['a';'b';'c']=[['x'; 'a'; 'b'; 'c']; ['a'; 'x'; 'b'; 'c']; ['a'; 'b'; 'x'; 'c'];['a'; 'b'; 'c'; 'x']]


(* CONTRAT
Fonction qui renvoie la liste des permutations d'une liste
Paramètre l : une liste
Résultat : la liste des permutatiions de l (toutes différentes si les élements de l sont différents deux à deux 
*)

let rec permutations l = 
match l with 
|[]->[[]]
|hd::q-> List.concat (List.map ( insertion  hd ) ( permutations q))


(* TESTS *)

let l1 = permutations [1;2;3]
let%test _ = List.length l1 = 6
let%test _ = List.mem [1; 2; 3] l1 
let%test _ = List.mem [2; 1; 3] l1 
let%test _ = List.mem [2; 3; 1] l1 
let%test _ = List.mem [1; 3; 2] l1 
let%test _ = List.mem [3; 1; 2] l1 
let%test _ = List.mem [3; 2; 1] l1 
let%test _ = permutations [] =[[]]
let l2 = permutations ['a';'b']
let%test _ = List.length l2 = 2
let%test _ = List.mem ['a';'b'] l2 
let%test _ = List.mem ['b';'a'] l2 



(*** Partition d'un entier ***)

(* partition int -> int list
Fonction qui calcule toutes les partitions possibles d'un entier n
Paramètre n : un entier dont on veut calculer les partitions
Préconditions : n >0
Retour : les partitions de n


let rec partition n =
  if n = 0 then
    []  (* Une seule partition valide, la liste vide *)
  else
    let rec aux t n =
      if t > n then
        [[]]  (* Aucune partition valide, la liste vide *)
      else
        let with_t = List.map (fun p -> t :: p) (aux t (n - t)) in
        let without_t = aux (t + 1) n in
        match with_t ,without_t with 
        |_, [[]]->with_t
        |[[]],_-> without_t
        |_,_->with_t @ without_t
        
    in
    aux 1 n
;;

*)


let partition n =
  let rec aux n max =
    if n = 0 then
      [[]]
    else if n < 0 || max = 0 then
      []
    else
      let with_max = List.map (fun p -> max :: p) (aux (n - max) max) in
      let without_max = aux n (max - 1) in
      with_max @ without_max
  in
  aux n n
;;


(* TEST *)
let%test _ = partition 1 = [[1]]
let%test _ = partition 2 = List.rev [[1;1];[2]]
let%test _ = partition 3 = [[3]; [2; 1]; [1; 1; 1]]
let%test _ = partition 4 = [[4]; [3; 1]; [2; 2]; [2; 1; 1]; [1; 1; 1; 1]]

