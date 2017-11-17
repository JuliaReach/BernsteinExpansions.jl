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
