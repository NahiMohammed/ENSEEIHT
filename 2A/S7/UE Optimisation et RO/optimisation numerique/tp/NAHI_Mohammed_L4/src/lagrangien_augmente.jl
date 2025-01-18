using LinearAlgebra
include("../src/newton.jl")
include("../src/regions_de_confiance.jl")
"""

Approximation d'une solution au problème 

    min f(x), x ∈ Rⁿ, sous la c c(x) = 0,

par l'algorithme du lagrangien augmenté.

# Syntaxe

    x_sol, f_sol, flag, nb_iters, μs, λs = lagrangien_augmente(f, gradf, hessf, c, gradc, hessc, x0; kwargs...)

# Entrées

    - f      : (Function) la ftion à minimiser
    - gradf  : (Function) le gradient de f
    - hessf  : (Function) la hessienne de f
    - c      : (Function) la c à valeur dans R
    - gradc  : (Function) le gradient de c
    - hessc  : (Function) la hessienne de c
    - x0     : (Vector{<:Real}) itéré initial
    - kwargs : les options sous formes d'arguments "keywords"
        • max_iter  : (Integer) le nombre maximal d'iterations (optionnel, par défaut 1000)
        • tol_abs   : (Real) la tolérence absolue (optionnel, par défaut 1e-10)
        • tol_rel   : (Real) la tolérence relative (optionnel, par défaut 1e-8)
        • λ0        : (Real) le multiplicateur de lagrange associé à c initial (optionnel, par défaut 2)
        • μ0        : (Real) le facteur initial de pénalité de la c (optionnel, par défaut 10)
        • τ         : (Real) le facteur d'accroissement de μ (optionnel, par défaut 2)
        • algo_noc  : (String) l'algorithme sans c à utiliser (optionnel, par défaut "rc-gct")
            * "newton"    : pour l'algorithme de Newton
            * "rc-cauchy" : pour les régions de confiance avec pas de Cauchy
            * "rc-gct"    : pour les régions de confiance avec gradient conjugué tronqué

# Sorties

    - x_sol    : (Vector{<:Real}) une approximation de la solution du problème
    - f_sol    : (Real) f(x_sol)
    - flag     : (Integer) indique le critère sur lequel le programme s'est arrêté
        • 0 : convergence
        • 1 : nombre maximal d'itération dépassé
    - nb_iters : (Integer) le nombre d'itérations faites par le programme
    - μs       : (Vector{<:Real}) tableau des valeurs prises par μk au cours de l'exécution
    - λs       : (Vector{<:Real}) tableau des valeurs prises par λk au cours de l'exécution

# Exemple d'appel

    f(x)=100*(x[2]-x[1]^2)^2+(1-x[1])^2
    gradf(x)=[-400*x[1]*(x[2]-x[1]^2)-2*(1-x[1]) ; 200*(x[2]-x[1]^2)]
    hessf(x)=[-400*(x[2]-3*x[1]^2)+2  -400*x[1];-400*x[1]  200]
    c(x) =  x[1]^2 + x[2]^2 - 1.5
    gradc(x) = 2*x
    hessc(x) = [2 0; 0 2]
    x0 = [1; 0]
    x_sol, _ = lagrangien_augmente(f, gradf, hessf, c, gradc, hessc, x0, algo_noc="rc-gct")

"""
function lagrangien_augmente(f::Function, gradf::Function, hessf::Function, 
        c::Function, gradc::Function, hessc::Function, x0::Vector{<:Real}; 
        max_iter::Integer=1000, tol_abs::Real=1e-10, tol_rel::Real=1e-8,
        λ0::Real=2, μ0::Real=10, τ::Real=2, algo_noc::String="rc-gct")

    #
    x_sol = x0
    f_sol = f(x_sol)
    flag  = -1
    μs = [μ0] # vous pouvez faire μs = vcat(μs, μk) pour concaténer les valeurs
    λs = [λ0]

    nb_iters        = 0
    beta            = 0.9
    η_constante     = 0.1258925 
    alpha           = 0.1 
    epsilon0        = 1 / μ0 
    η0              =(η_constante)/(μ0 ^ alpha)

    x_k      =x0
    μ_k      =μ0
    λ_k      =λ0
    epsilon_k=epsilon0
    η_k      =η0

    while (true)

        La_f(x) = f(x) + transpose(λ_k) * c(x) + (μ_k/2) * (norm(c(x)))^2
        La_gradf(x) = gradf(x) + transpose(λ_k) * gradc(x) + μ_k * gradc(x) * c(x)
        La_hessf(x) = hessf(x) + transpose(λ_k) * hessc(x) + μ_k * hessc(x) * c(x) + μ_k * gradc(x) * transpose(gradc(x))

        if algo_noc == "newton"
            x_k, _, _, _,_ = newton(La_f, La_gradf, La_hessf, x_k)
        elseif algo_noc == "rc-cauchy" 
            x_k, _, _, _ ,_= regions_de_confiance(La_f, La_gradf, La_hessf, x_k , algo_pas="cauchy")
        
          elseif algo_noc =="rc-gct"
            x_k, _, _, _ ,_= regions_de_confiance(La_f, La_gradf, La_hessf, x_k , algo_pas="gct")  end
        
        gradLNA(x,lambda)= gradf(x) +transpose(lambda)*gradc(x)
        
        if norm(gradLNA(x_k,λ_k)) <= max(epsilon_k, tol_rel * norm(gradLNA(x0,λ0))) || norm(c(x_k)) <= max(tol_abs, tol_rel * norm(c(x0)))&& norm(c(x_k)) <= max(tol_abs, tol_rel * norm(c(x0)))&& norm(c(x_k)) <= max(tol_abs, tol_rel * norm(c(x0)))
          flag = 0
          break
        elseif nb_iters == max_iter
          flag = 1
          break
        end

        if norm(c(x_k)) <= η_k 
          λ_k =  λ_k + μ_k * c(x_k)
          μ_k=μ_k
          epsilon_k = epsilon_k / μ_k
          η_k = η_k / (μ_k ^ beta)
          
        else
          λ_k =  λ_k
          μ_k = τ*μ_k
          epsilon_k = epsilon0 / μ_k
          η_k = η_constante / (μ_k ^ alpha)
        end

        nb_iters=nb_iters+1
        μs = vcat(μs, μ_k)
        λs = vcat(λs, λ_k)
      end
      x_sol = x_k
      f_sol = f(x_sol)

        
    return x_sol, f_sol, flag, nb_iters, μs, λs

end
