using LinearAlgebra
"""
Approximation de la solution du problème 

    min qₖ(s) = s'gₖ + 1/2 s' Hₖ s, sous la contrainte ‖s‖ ≤ Δₖ

# Syntaxe

    s = gct(g, H, Δ; kwargs...)

# Entrées

    - g : (Vector{<:Real}) le vecteur gₖ
    - H : (Matrix{<:Real}) la matrice Hₖ
    - Δ : (Real) le scalaire Δₖ
    - kwargs  : les options sous formes d'arguments "keywords", c'est-à-dire des arguments nommés
        • max_iter : le nombre maximal d'iterations (optionnel, par défaut 100)
        • tol_abs  : la tolérence absolue (optionnel, par défaut 1e-10)
        • tol_rel  : la tolérence relative (optionnel, par défaut 1e-8)

# Sorties

    - s : (Vector{<:Real}) une approximation de la solution du problème

# Exemple d'appel

    g = [0; 0]
    H = [7 0 ; 0 2]
    Δ = 1
    s = gct(g, H, Δ)

"""
function gct(g::Vector{<:Real}, H::Matrix{<:Real}, Δ::Real; 
    max_iter::Integer = 100, 
    tol_abs::Real = 1e-10, 
    tol_rel::Real = 1e-8)

    nb_iters=0
    gj=g
    sj=zeros(length(g))
    pj=-g
    q(s)=(transpose(g))*s + (1/2)*transpose(s)*H*s
    

    while nb_iters <= max_iter && norm(gj)>max(norm(g)*tol_rel,tol_abs)
        kj = transpose(pj)*H*pj
        if kj <= 0

            # mettre a jour les coefficients de l'équation 
            a = norm(pj)^2
            b = 2*transpose(sj)*pj
            c = norm(sj)^2 - Δ^2

            # calcul des racines de l'équation
            delta= sqrt(b^2 - 4*a*c)
            phi_1 = (-b+delta)/(2*a)
            phi_2 = (-b-delta)/(2*a)
            
            # Choix de la racine
            if q(phi_2*pj+sj) > q(phi_1*pj+sj)
                phi_j=phi_1
            else 
                phi_j=phi_2
            end   

            sj = sj+phi_j*pj 

            break
        end

        alpha_j=(transpose(gj)*gj)/kj
        if  norm(sj+alpha_j*pj)>=Δ

            a=norm(pj)^2
            b= 2*transpose(sj)*pj
            c= norm(sj)^2 - Δ^2

            delta=sqrt(b^2 -4*a*c)
            phi_1 = (-b+delta)/(2*a)
            phi_2 =(-b-delta)/(2*a)

            if phi_1>0
                phi_j=phi_1
            elseif phi_2>0
                phi_j=phi_2          
            end

            sj=sj+phi_j*pj

            break

        end

        nb_iters+=1 
        sj=sj+alpha_j*pj
        gj_1=gj+alpha_j*H*pj
        betaj=(gj_1'*gj_1)/(gj'*gj)
        pj= -gj_1 + betaj*pj
        gj=gj_1

    end
    return sj
end
