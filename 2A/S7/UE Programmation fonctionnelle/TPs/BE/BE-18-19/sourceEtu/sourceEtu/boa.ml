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

module type Regle =
sig
  (* Type des identifiants de règles *)
  type tid = int 
  (* Type des termes *)
  type td 
  (* Identifiant de la règle *)
  val id : tid 
  (* Applique la règle à un terme donné et renvoie une liste de termes résultants *)
  val appliquer : td -> td list
end

module Regle1 :Regle with type td=char list=
struct 
  type tid = int
  type td =char list 
  let id =1 
  let appliquer chaine=
    match List.rev chaine with 
    |'O'::cq->[chaine @ ['A']] 
    |_->[chaine]
end

module Regle2 :Regle with type td=char list=
struct 
  type tid = int
  type td =char list 
  let id =2 
  let    appliquer chaine=
    match chaine with 
    |'B'::cb->[chaine@cb]
    |_->[chaine]
end


module Regle4 :Regle with type td=char list=
struct 
  type tid = int
  type td =char list 
  let id =4 
  let appliquer chaine=
    let rec aux ch =
      match ch with 
      |'A'::'A'::cq->aux cq 
      |c::'A'::'A'::cq ->c::(aux cq)
      |c::cq -> c::(aux cq)
      |[] -> []
    in [aux chaine] 
end
  (*----------------------------------------------------------------------------------------*)
module type ArbreReecriture =
sig 
  type tid = int
  type td
  type arbre_reecriture =Noeud of (td * branches list) 
  and branches = tid * arbre_reecriture

  val creer_noeud : td -> branches list -> arbre_reecriture
    
  (* Renvoie le terme stocké dans le nœud racine de l'arbre de réécriture. *)
  val racine : arbre_reecriture -> td 
    
  (* Renvoie la liste des fils de la racine de l'arbre de réécriture donné. *)                                    
  val fils : arbre_reecriture -> branches list

  (* Vérifie si un terme donné appartient à l'arbre de réécriture. *)
  val appartient : td -> arbre_reecriture -> bool 
  val arbre :arbre_reecriture
end

module ArbreReecritureBOA:ArbreReecriture with type td = char list =
struct 
  type tid =int 
  type td =char list 
  type arbre_reecriture =Noeud of (td * branches list) 
  and branches = tid * arbre_reecriture
  let rec creer_noeud terme branches =
    Noeud (terme, branches)
  let racine (arbre : arbre_reecriture) =
    match arbre with
    | Noeud (terme, _) -> terme
  let fils (arbre : arbre_reecriture) =
    match arbre with
    | Noeud (_, branches) -> branches
  let rec appartient terme arbre =
    if terme = racine arbre then
      true
    else
      List.exists (fun (_, enfant) -> appartient terme enfant) (fils arbre)

  let arbre =Noeud(['B';'O';'O'],[(2,Noeud(['B';'O';'O';'O';'O'],[(1,Noeud(['B';'O';'O';'O';'O';'A'],[]));(2,Noeud(['B';'O';'O';'O';'O';'O';'O';'O';'O'],[]));(3,Noeud(['B';'A';'O'],[]));(3,Noeud(['B';'O';'A'],[]))]));(1,Noeud(['B';'O';'O';'A'],[(2,Noeud(['B';'O';'O';'A';'O';'O';'A'],[]))]))])
  
end

module SystemeBOA =
struct
  open ArbreReecritureBOA  (* Importez le module d'arbre BOA que vous avez défini précédemment *)
  open Regle1  (* Importez le module de la règle 1 *)
  open Regle2  (* Importez le module de la règle 2 *)
               
  open Regle4  (* Importez le module de la règle 4 *) 
               
  let rec decompose_couple (a, b) =
    match b with
    | [liste] -> [a, Noeud (liste,[])]  (* Si b est une seule liste, renvoie le couple (a, liste) dans une liste *)
    | _ ->  (* Si b est composé de plusieurs listes, utilise une récursion pour diviser b en listes individuelles *)
        let rec aux acc = function
          | [] -> acc
          | hd :: tl -> aux ((a, Noeud (hd,[])) :: acc) tl
        in
        aux [] b a
 
                  
  let construit_arbre terme n =
    let applique_regle terme regle =
      match regle with
      | "Regle1" -> Regle1.appliquer terme
      | "Regle2" -> Regle2.appliquer terme
                    (*| "Regle3" -> Regle3.appliquer terme*)
      | "Regle4" -> Regle4.appliquer terme
    in
    
    
    let regles = match n with 
      | 1 -> [(1,"Regle1")]
      | 2 -> [(1,"Regle1");(2,"Regle2")]
      | 3 -> [(1,"Regle1");(2,"Regle2");(3,"Regle4")]
       (*| 4 -> [(1,"Regle1");(2,"Regle2");(3,"Regle3");(4,"Regle4")]*)
      | _ -> failwith "n n est pas valide" in
    let fils =List.map ( fun (i,"Regle") -> (i,applique_regle terme "Regle" )) regles in 
    let rec aux fils acc=
      match fils with
      | [] -> acc
      | (a,b)::cq ->aux cq (List.append acc  (decompose_couple (a, b)) )
    in Noeud(terme, (aux fils [])) 
      
             
end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  