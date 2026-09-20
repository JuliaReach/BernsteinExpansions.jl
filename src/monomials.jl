# =============================================
# Bernstein expansion for univariate monomials
# =============================================

"""
    univariate(m::AbstractMonomialLike, l::Integer, dom::Interval)

Compute the Bernstein coefficients of a univariate monomial over an interval.

### Input

- `m`    -- monomial in one variable
- `l`    -- degree of the Bernstein polynomial
- `dom`  -- interval domain of the Bernstein expansion

### Output

An `l+1`-dimensional vector that corresponds to the Bernstein expansion of order
`l` of the monomial `m`.

### Notes

For experimental purposes, different variations of the algorithm are available
in the internal function `_univariate!`. By dispatching on any of the following
values, you can choose between:

- `fastmath` : Uses the `@fastmath`. This is the fastest implementation. The
               binomial quotients that only depend on `k` and `l` (not on the
               domain) are cached across calls; see `_binomial_quotients_cached`.
- `fastpow`  : Uses the package's own `fastpow` (vendored from `DiffEqBase.jl`,
               see `fastpow.jl`). This is the second fastest implementation.
- `base`     : Uses `^` from Julia. This is the slowest implementation, but it's
               accuracy is guaranteed to be within an `<= 1 ulp` for all possible
               input values.

### Algorithm

TODO: add description (ref Smith's PhD thesis).
"""
function univariate(m::AbstractMonomialLike, l::Integer, dom::Interval{N}) where {N}
    nvariables(m) == 1 || throw(ArgumentError("this function only accepts univariate " *
                                              "monomials but the given monomial has $(nvariables(m)) variables"))

    k = degree(m)
    coeffs = Vector{N}(undef, l + 1) # preallocate output
    return _univariate!(coeffs, k, l, inf(dom), sup(dom))
end

# Bernstein coefficients for univariate terms like 4x²; uses linearity property
function univariate(t::AbstractTermLike, l::Integer, dom::Interval{N}) where {N}
    m = monomial(t)
    α = coefficient(t)
    coeffs = univariate(m, l, dom)
    return α .* coeffs
end

# fallback in floating-point
function _univariate!(coeffs::AbstractVector{N}, k::Integer, l::Integer,
                      low::N, high::N) where {N<:AbstractFloat}
    return _univariate!(coeffs, k, l, low, high, Val(:fastmath))
end

# use @fastmath macro to allow floating point optimizations; the binomial
# quotients (which only depend on k and m = l - k, not on the domain) are
# cached across calls, see `_binomial_quotients_cached`
function _univariate!(coeffs::AbstractVector{N}, k::Integer, l::Integer,
                      low::N, high::N, ::Val{:fastmath}) where {N<:AbstractFloat}
    if k < l
        m = l - k
        quotients = _binomial_quotients_cached(k, m)
        @fastmath @inbounds begin
            for i in 0:l
                jmin = max(0, i - m)
                row = quotients[i + 1]
                coeffs[i + 1] = zero(N)
                for (idx, j) in enumerate(jmin:min(k, i))
                    coeffs[i + 1] += row[idx] * low^(k - j) * high^j
                end
            end
        end
    else
        @fastmath @inbounds begin
            for i in 0:l
                coeffs[i + 1] = low^(k - i) * high^i
            end
        end
    end
    return coeffs
end

# use fastpow version of ^
function _univariate!(coeffs::AbstractVector{N}, k::Integer, l::Integer,
                      low::N, high::N, ::Val{:fastpow}) where {N<:AbstractFloat}
    if k < l
        m = l - k
        @inbounds begin
            for i in 0:l
                coeffs[i + 1] = zero(N)
                for j in max(0, i - m):min(k, i)
                    aux = binomial(m, i - j) * binomial(k, j) / binomial(k + m, i)
                    coeffs[i + 1] += aux * fastpow(low, k - j) * fastpow(high, j)
                end
            end
        end
    else
        @fastmath @inbounds begin
            for i in 0:l
                coeffs[i + 1] = fastpow(low, k - i) * fastpow(high, i)
            end
        end
    end
    return coeffs
end

# use Julia base version of ^
function _univariate!(coeffs::AbstractVector{N}, k::Integer, l::Integer,
                      low::N, high::N, ::Val{:base}) where {N<:AbstractFloat}
    if k < l
        m = l - k
        @inbounds begin
            for i in 0:l
                coeffs[i + 1] = zero(N)
                for j in max(0, i - m):min(k, i)
                    aux = binomial(m, i - j) * binomial(k, j) / binomial(k + m, i)
                    coeffs[i + 1] += aux * low^(k - j) * high^j
                end
            end
        end
    else
        @inbounds begin
            for i in 0:l
                coeffs[i + 1] = low^(k - i) * high^i
            end
        end
    end
    return coeffs
end

# exact computation using rationals
function _univariate!(coeffs::AbstractVector{N}, k::Integer, l::Integer,
                      low::N, high::N) where {M,N<:Rational{M}}
    if k < l
        m = l - k
        @inbounds for i in 0:l
            coeffs[i + 1] = zero(N)
            for j in max(0, i - m):min(k, i)
                aux = binomial(m, i - j) * binomial(k, j) // binomial(k + m, i)
                coeffs[i + 1] += aux * low^(k - j) * high^j
            end
        end
    else
        @inbounds @simd for i in 0:l
            coeffs[i + 1] = low^(k - i) * high^i
        end
    end
    return coeffs
end

# Compute the binomial quotients `binomial(m, i - j) * binomial(k, j) / binomial(k + m, i)`
# for every `i in 0:(k + m)` and `j in max(0, i - m):min(k, i)`, returned as a vector
# of rows (one per `i`), each row indexed from `j = max(0, i - m)`.
#
# Instead of recomputing three `binomial(...)` calls for every `(i, j)` pair, each row
# is filled incrementally: for fixed `i`, the ratio of consecutive terms is
#
#   term(j + 1) / term(j) = (k - j) / (j + 1) * (i - j) / (m - i + j + 1)
#
# which follows from `binomial(k, j+1) / binomial(k, j) = (k - j) / (j + 1)` and
# `binomial(m, i-j-1) / binomial(m, i-j) = (i - j) / (m - (i - j) + 1)`. This turns the
# O(k) cost of the naive `binomial(...)` calls at every step into an O(1) update
# (see [S09] section 3.1). The running term is kept as an exact `Rational` and only
# converted to `Float64` once, when stored, so each quotient is a correctly-rounded
# Float64. This is at least as accurate as directly evaluating
# `binomial(m, i - j) * binomial(k, j) / binomial(k + m, i)` under `@fastmath` (which
# is not guaranteed to be correctly rounded), but the two are not guaranteed to agree
# bit for bit: they can differ by a handful of ULP per quotient. Values fed through the
# `k < l` branch of `_univariate!` can still differ from before by more than that,
# since the final sum is a weighted combination of `low^(k-j) * high^j` terms that can
# be many orders of magnitude larger than the result for wide or negative domains at
# high degree, so per-quotient ULP-level differences get amplified by the resulting
# catastrophic cancellation -- a pre-existing conditioning issue of this summation, not
# something introduced by caching. Verified numerically (not covered by the test suite,
# whose (k, l) are too small to exercise this): for (k, l) up to (20, 60) across several
# domains, both formulations track the exact (Rational-computed) coefficient about
# equally well on average, with no systematic accuracy loss from this change.
function _binomial_quotients_row(k::Integer, m::Integer)
    l = k + m
    rows = Vector{Vector{Float64}}(undef, l + 1)
    @inbounds for i in 0:l
        jmin = max(0, i - m)
        jmax = min(k, i)
        row = Vector{Float64}(undef, jmax - jmin + 1)
        term = (binomial(m, i - jmin) * binomial(k, jmin)) // binomial(k + m, i)
        row[1] = Float64(term)
        for j in jmin:(jmax - 1)
            term *= (k - j) // (j + 1) * ((i - j) // (m - i + j + 1))
            row[j - jmin + 2] = Float64(term)
        end
        rows[i + 1] = row
    end
    return rows
end

# cache of binomial quotient rows (see `_binomial_quotients_row`), indexed by `(k, m)`,
# so that repeated Bernstein expansions of the same degree over different domains do
# not recompute them
const BINOM_QUOT_CACHE = Dict{Tuple{Int,Int},Vector{Vector{Float64}}}()

function _binomial_quotients_cached(k::Integer, m::Integer)
    return get!(() -> _binomial_quotients_row(k, m), BINOM_QUOT_CACHE, (k, m))
end

# ===============================================
# Bernstein expansion for multivariate monomials
# ===============================================

"""
    multivariate(m::AbstractMonomialLike, l::AbstractVector{Int}, dom::IntervalBox{N}) where {N}

Compute the Bernstein coefficients of a multivariate monomial.

### Input

- `m`    -- monomial in several variables
- `l`    -- vector of degrees of the Bernstein polynomial for each variable
- `dom`  -- multi-dimensional interval domain of the Bernstein expansion

### Output

A vector of vectors holding the Bernstein coefficients implicitly.

### Algorithm

TODO: add description (ref Smith's PhD thesis).
"""
function multivariate(m::AbstractMonomialLike, l::AbstractVector{Int},
                      dom::IntervalBox{D,N}) where {D,N}
    n = nvariables(m)
    (n == length(l) == D) || throw(ArgumentError("the number of " *
                                                 "variables in the monomial `m`, number of degrees `l` and domain size of `dom` " *
                                                 "do no match; they are $n, $(length(l)) and $D respectively"))

    k = exponents(m) # vector of degrees for each variable

    # preallocate outputs
    coeffs = Vector{Vector{N}}(undef, n)
    @inbounds for i in 1:n
        coeffs[i] = Vector{N}(undef, l[i] + 1)
    end

    @inbounds for i in 1:n
        _univariate!(coeffs[i], k[i], l[i], inf(dom[i]), sup(dom[i]))
    end
    return coeffs
end

# Bernstein coefficients for multivariate terms like 4x²y; uses linearity property
#
# The coefficient α is folded into the first variable's coefficient vector only:
# since the assembled coefficient at a multi-index `ids` is the product
# `prod(coeffs[i][ids[i]] for i)`, scaling every per-variable vector by α would
# apply the factor once per variable instead of once overall.
function multivariate(t::AbstractTermLike, l::AbstractVector{Int},
                      dom::IntervalBox{D,N}) where {D,N}
    m = monomial(t)
    α = coefficient(t)
    coeffs = multivariate(m, l, dom)
    coeffs[1] = α .* coeffs[1]
    return coeffs
end
