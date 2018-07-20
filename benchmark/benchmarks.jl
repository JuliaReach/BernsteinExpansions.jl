using BernsteinExpansions
using Compat, BenchmarkTools, PkgBenchmark

@benchgroup "Univariate monomials" begin
    @bench "Univariate monomial, floating point input, degree 3" univariate(3, 3, 1.0, 2.0)
    @bench "Univariate monomial, floating point input, degree 5" univariate(1, 5, 0.0, 1.0)
end

@benchgroup "High-dim multivariate expansion" begin
    k = [1,2,3,4,5,2,3,4]
    l = [5,5,5,5,5,5,5,5]

    low = [1//1,1//1,1//1,1//1,1//1,1//1,1//1,1//1]
    high = [2//1,2//1,2//1,2//1,2//1,2//1,2//1,2//1]
    @bench "Rational multivariate expansion" multivariate($k, $l, $low, $high)

    low = [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0]
    high = [2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0]
    @bench "Float64 multivariate expansion" multivariate($k, $l, $low, $high)

    m = multivariate([5,5,5,5,5,5,5,5],[10,10,10,10,10,10,10,10],
                     [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0],
                     [2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0]);

    @bench "Float64 multivariate expansion" generate_tensor_form($m)                 

end

#=
#println("Benchmarking: Univariate monomial, floating point input, degree 3")
# 331.143 ns without @fastmath, and 301ns using @fastmath
@benchmark univariate(3, 3, 1.0, 2.0)

#println("Benchmarking: Univariate monomial, floating point input, degree 5")
# 331.143 ns without @fastmath and 301ns using @fastmath
@benchmark univariate(1, 5, 0.0, 1.0)

#println("Univariate monomial, rational input, degree 3")
@benchmark univariate(3, 3, 1//1, 2//1)

#println("Univariate monomial, rational input, degree 3")
@benchmark univariate(1, 5, 0//1, 1//1)
=#
