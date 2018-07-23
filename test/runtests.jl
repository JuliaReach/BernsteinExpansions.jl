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
@test generate_tensor_form(m) == multivariate_tensor([5,5,5,5,5,5,5,5],
                                                     [10,10,10,10,10,10,10,10],
                                                     [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0],
                                                     [2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0])
end


# random timing test
# d = rand(3:6,10); l = [maximum(d) for i in 1:10];lb = [d[i]/maximum(d) for i in 1:10];ub = [1.0 for i in 1:10]
# @time multivariate_tensor(d,l,lb,ub)
