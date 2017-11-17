using BernsteinExpansions, BenchmarkTools

@benchgroup begin "univariate_monomials" begin
    @bench "Univariate monomial, floating point input, degree 3"
           univariate(3, 3, 1.0, 2.0)

    @bench "Univariate monomial, floating point input, degree 5"
           univariate(1, 5, 0.0, 1.0)
end

# For later:
# using PkgBenchmark
# benchmarkpkg("BernsteinExpansions")

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
