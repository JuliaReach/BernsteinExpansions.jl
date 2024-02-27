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

- `fastmath` : Uses the `@fastmath`. This is the fastest implementation.
- `fastpow`  : Uses `fastpow` from `DiffEqBase.jl`. This is the second fastest
               implementation.
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
    return _univariate!(coeffs, k, l, low, high, Val(:fastmath)) # :optimized
end

# use @fastmath macro to allow floating point optimizations
function _univariate!(coeffs::AbstractVector{N}, k::Integer, l::Integer,
                      low::N, high::N, ::Val{:fastmath}) where {N<:AbstractFloat}
    if k < l
        m = l - k
        @fastmath @inbounds begin
            for i in 0:l
                coeffs[i + 1] = zero(N)
                for j in max(0, i - m):min(k, i)
                    aux = binomial(m, i - j) * binomial(k, j) / binomial(k + m, i)
                    coeffs[i + 1] += aux * low^(k - j) * high^j
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

# use @fastmath macro to allow floating point optimizations
function _univariate!(coeffs::AbstractVector{N}, k::Integer, l::Integer,
                      low::N, high::N, ::Val{:optimized}) where {N<:AbstractFloat}
    if k < l
        m = l - k
        @fastmath @inbounds begin
            for i in 0:l
                coeffs[i + 1] = zero(N)
                for j in max(0, i - m):min(k, i)
                    aux = BINOM_QUOT_TABLE[m, i, j, k]
                    coeffs[i + 1] += aux * low^(k - j) * high^j
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

# TODO: handle zeros in i, j, k, m (?)
function _binomial_quotients(; N=Float64, m_max=10, i_max=10, j_max=10, k_max=10)
    M = Array{N,4}(undef, m_max, i_max, j_max, k_max)
    for k in 1:k_max
        for j in 1:j_max
            for i in 1:i_max
                for m in 1:m_max
                    @inbounds M[m, i, j, k] = binomial(m, i - j) * binomial(k, j) /
                                              binomial(k + m, i)
                end
            end
        end
    end
    return M
end

# lookup table for the binomial quotients in the univariate case with k < l
const BINOM_QUOT_TABLE = _binomial_quotients()

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
```
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
function multivariate(t::AbstractTermLike, l::AbstractVector{Int},
                      dom::IntervalBox{D,N}) where {D,N}
    m = monomial(t)
    α = coefficient(t)
    coeffs = multivariate(m, l, dom)
    return α .* coeffs
end
