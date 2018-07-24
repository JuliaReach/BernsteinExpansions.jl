using BernsteinExpansions
using Base.Test

@time @testset "Univariate monomial, floating point input" begin
@test univariate(3, 3, 1.0, 2.0) == [1.0, 2.0, 4.0, 8.0]
@test univariate(1, 5, 0.0, 1.0) == [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
end

@time @testset "Univariate monomial, rational input" begin
@test univariate(3, 3, 1//1, 2//1) == [1//1, 2//1, 4//1, 8//1]
@test univariate(1, 5, 0//1, 1//1) == [0//1, 1//5, 2//5, 3//5, 4//5, 1//1]
end

@time @testset "Univariate monomial, rational input" begin
@test univariate(3, 3, 1//1, 2//1) == [1//1, 2//1, 4//1, 8//1]
@test univariate(1, 5, 0//1, 1//1) == [0//1, 1//5, 2//5, 3//5, 4//5, 1//1]
end


m = multivariate([5,5,5,5,5,5,5,5],[10,10,10,10,10,10,10,10],
                 [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0],
                 [2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0]);
@time @testset "Multivariate monomial, float input, implicit form" begin

# test loop (default) algorithm
@test generate_tensor_form(m, algorithm="loop") == multivariate_tensor([5,5,5,5,5,5,5,5],
                                                     [10,10,10,10,10,10,10,10],
                                                     [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0],
                                                     [2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0], algorithm="loop")

# test kron algorithm
@test generate_tensor_form(m, algorithm="kron") == multivariate_tensor([5,5,5,5,5,5,5,5],
                                                                       [10,10,10,10,10,10,10,10],
                                                                       [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0],
                                                                       [2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0], algorithm="kron")
end
