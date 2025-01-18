(* CONTRAT 
[combinaisons l k] renvoie la liste de toutes les combinaisons possibles
    de k éléments choisis parmi la liste l.
    
    Préconditions:
    - k doit être un entier positif ou nul.
    
    Postconditions:
    - Le résultat est une liste de listes, chaque sous-liste étant une combinaison de k
      éléments de la liste l.
    - Si k est supérieur à la longueur de la liste l, le résultat est une liste vide.
    
  
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
let%test _ = combinaisons [1; 2; 3; 4] 0 = [[]]

let%test _ = combinaisons [1; 2; 3; 4] 1 = [[1]; [2]; [3]; [4]]

let%test _ =combinaisons [1; 2; 3; 4] 3 = [[1; 2; 3]; [1; 2; 4]; [1; 3; 4]; [2; 3; 4]]

let%test _ =combinaisons [1; 2; 3] 2 = [[1; 2]; [1; 3]; [2; 3]]

let%test _ = combinaisons [1; 2; 3] 4 = []

let%test _ = combinaisons [] 2 = []
