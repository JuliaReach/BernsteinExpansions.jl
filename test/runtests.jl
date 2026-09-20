using BernsteinExpansions, Test
using DynamicPolynomials # optional polynomial interface
using StaticArrays

using BernsteinExpansions: _univariate!, _binomial_quotients_cached, BINOM_QUOT_CACHE #, _multivariate!

# initialize some variables
@polyvar x y

@testset "Univariate monomial, floating point" begin
    # exported function
    @test univariate(x^3, 3, interval(1, 2)) == [1.0, 2.0, 4.0, 8.0]
    @test univariate(x, 5, interval(0, 1)) == [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]

    # internals
    coeffs = zeros(MVector{4,Float64})
    @test _univariate!(coeffs, 3, 3, 1.0, 2.0) == @MVector([1.0, 2.0, 4.0, 8.0])
    coeffs = zeros(MVector{6,Float64})
    @test _univariate!(coeffs, 1, 5, 0.0, 1.0) == @MVector([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])
end

@testset "Univariate monomial, binomial quotient cache" begin
    # the cache is populated lazily, keyed by (k, m); a second call with the
    # same (k, l) but a different domain must hit the same cached rows
    empty!(BINOM_QUOT_CACHE)
    coeffs = zeros(6)
    _univariate!(coeffs, 1, 5, 0.0, 1.0)
    @test haskey(BINOM_QUOT_CACHE, (1, 4))
    cached_rows = BINOM_QUOT_CACHE[(1, 4)]
    _univariate!(coeffs, 1, 5, 3.0, 7.0)
    @test BINOM_QUOT_CACHE[(1, 4)] === cached_rows # same object, not recomputed

    # accuracy against an exact `Rational`-computed reference on well-conditioned
    # (non-cancelling) domains, for (k, l) larger than the small cases tested
    # elsewhere in this file
    for (k, l) in ((3, 15), (5, 25), (10, 30))
        m = l - k
        for (low, high) in ((0.0, 1.0), (1.0, 2.0))
            coeffs = zeros(l + 1)
            _univariate!(coeffs, k, l, low, high)
            for i in 0:l
                jmin, jmax = max(0, i - m), min(k, i)
                exact = sum(j -> (binomial(big(m), i - j) * binomial(big(k), j)) //
                                  binomial(big(k + m), i) *
                                  big(low)^(k - j) * big(high)^j, jmin:jmax)
                @test coeffs[i + 1] ≈ Float64(exact) rtol = 1e-10
            end
        end
    end
end

@testset "Univariate monomial, rational" begin
    # exported function
    @test univariate(x^3, 3, interval(1 // 1, 2 // 1)) == [1 // 1, 2 // 1, 4 // 1, 8 // 1]
    @test univariate(x, 5, interval(0 // 1, 1 // 1)) ==
          [0 // 1, 1 // 5, 2 // 5, 3 // 5, 4 // 5, 1 // 1]

    # internals
    coeffs = zeros(MVector{4,Rational{Int}})
    @test _univariate!(coeffs, 3, 3, 1 // 1, 2 // 1) == [1 // 1, 2 // 1, 4 // 1, 8 // 1]
    coeffs = zeros(MVector{6,Rational{Int}})
    @test _univariate!(coeffs, 1, 5, 0 // 1, 1 // 1) ==
          [0 // 1, 1 // 5, 2 // 5, 3 // 5, 4 // 5, 1 // 1]
end

@testset "Multivariate monomial, rational" begin
    box = IntervalBox(interval(1 // 1, 2 // 1), interval(1 // 1, 2 // 1))

    # exported function
    @test multivariate(x^2 * y^3, [2, 3], box) == [[1 // 1, 2 // 1, 4 // 1],
                                                    [1 // 1, 2 // 1, 4 // 1, 8 // 1]]

    # linearity property: the coefficient is applied exactly once overall, not
    # once per variable
    @test multivariate(3 * x^2 * y^3, [2, 3], box) == [[3 // 1, 6 // 1, 12 // 1],
                                                        [1 // 1, 2 // 1, 4 // 1, 8 // 1]]
end

@testset "Multivariate monomial, floating point" begin
    box = IntervalBox(interval(0.0, 1.0), interval(0.0, 1.0))
    @test multivariate(x * y, [1, 1], box) == [[0.0, 1.0], [0.0, 1.0]]
end

# TODO: add more tests for multivariate (ref Smith's thesis)
#

include("quality_assurance.jl")
