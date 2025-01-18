# Ecrire les tests de l'algorithme du pas de Cauchy
using Test

function tester_cauchy(cauchy::Function)
    
    # Tolérance utilisé dans les tests
    tol_test = 1e-3


    @testset "Pas de Cauchy" begin
   
        # le cas de test 1
            g = [0; 0]
            H = [7 0 ; 0 2]
            delta = 1
            s= cauchy(g,H,delta)
            @test  s ≈ [0.0 ; 0.0] atol = tol_test
        
        # le cas de test 2
            g = [6; 2]
            H = [7 0 ; 0 2]
            delta = 1
            s = cauchy(g,H,delta)
            sol = -(norm(g)^2/(g'*H*g))*g
            @test  s ≈ sol atol = tol_test
        
        # le cas de test 3
            g = [6; 2]
            H = [7 0 ; 0 2]
            delta = 0.9
            s= cauchy(g,H,delta)
            sol = -(delta/norm(g))*g
            @test  s ≈ sol atol = tol_test 
        
        # le cas de test 4
            g = [-2; 1]
            H = [-2 0 ; 0 10]
            delta = 6
            s = cauchy(g,H,delta)
            sol = -(norm(g)^2/(g'*H*g))*g
            @test  s ≈ sol atol = tol_test 

        # le cas de test 5
            g = [-2; 1]
            H = [-2 0 ; 0 10]
            delta = 5
            s= cauchy(g,H,delta)
            sol = -(delta/norm(g))*g
            @test  s ≈ sol atol = tol_test 
       
        # le cas de test 6
            g = [3; 1]
            H = [-2 0 ; 0 10]
            delta = 5
            s = cauchy(g,H,delta)
            sol = -(delta/norm(g))*g
            @test  s ≈ sol atol = tol_test 

        # le cas de test 7
            g = [1,2]
            H = [2 -1 ; 4 -2]
            delta = 5
            s = cauchy(g,H,delta)
            sol = -(delta/norm(g))*g
            @test  s ≈ sol atol = tol_test

    end
    end
