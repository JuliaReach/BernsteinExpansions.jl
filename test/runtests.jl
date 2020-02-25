using BernsteinExpansions, Test
using DynamicPolynomials # optional polynomial interface
using StaticArrays

using BernsteinExpansions: _univariate! #, _multivariate!

# initialize some variables
@polyvar x y

@testset "Univariate monomial, floating point" begin
    # exported function
    @test univariate(x^3, 3, 1..2) == [1.0, 2.0, 4.0, 8.0]
    @test univariate(x, 5, 0..1) == [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]

    # internals
    coeffs = zeros(MVector{4, Float64})
    @test _univariate!(coeffs, 3, 3, 1.0, 2.0) == @MVector([1.0, 2.0, 4.0, 8.0])
    coeffs = zeros(MVector{6, Float64})
    @test _univariate!(coeffs, 1, 5, 0.0, 1.0) == @MVector([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])
end

@testset "Univariate monomial, rational" begin
    # exported function
    @test univariate(x^3, 3, Interval(1//1, 2//1)) == [1//1, 2//1, 4//1, 8//1]
    @test univariate(x, 5, Interval(0//1, 1//1)) == [0//1, 1//5, 2//5, 3//5, 4//5, 1//1]

    # internals
    coeffs = zeros(MVector{4, Rational{Int}})
    @test _univariate!(coeffs, 3, 3, 1//1, 2//1) == [1//1, 2//1, 4//1, 8//1]
    coeffs = zeros(MVector{6, Rational{Int}})
    @test _univariate!(coeffs, 1, 5, 0//1, 1//1) == [0//1, 1//5, 2//5, 3//5, 4//5, 1//1]
end

#=
@testset "Multivariate monomial in 2D, float input, full expansion" begin
    k = [3, 2]
    l = [3, 2]
    dom = IntervalBox([1, 2], [2, 4])
    ans = [4.0, 8.0, 16.0, 8.0, 16.0, 32.0, 16.0, 32.0, 64.0, 32.0, 64.0, 128.0]

    # test nested tensor (default) algorithm
    m = multivariate(k, l, dom)
    @test generate_tensor_form(m, algorithm="linear_kron") == sol

    #FIXME: Look how to explore multi-dim array in correct fashion
    m_reverse = multivariate(reverse(k), reverse(l), reverse(low), reverse(high));
    @test vcat(generate_tensor_form(m_reverse, algorithm="tensor_generated")...) == sol
end
=#
