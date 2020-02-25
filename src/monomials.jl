# =============================================
# Bernstein expansion for univariate monomials
# =============================================

"""
    univariate(m::AbstractMonomialLike, l::Integer, dom::Interval)

Compute the Bernstein coefficients of a univariate monomial over an interval.

### Input

- `m`    -- monomial
- `l`    -- degree of the Bernstein polynomial
- `dom`  -- domain of the Bernstein expansion

### Output

An `l+1`-dimensional vector that corresponds to the Bernstein expansion of order
`l` of the monomial `m`.

### Algorithm

TODO: add

### Notes

For experimental purposes, different variations of the algorithm are availble
in the internal function `_univariate!`. By dispatching on any of the following
values, you can choose between:

- `fastmath` : Uses the `@fastmath`. This is the fastest implementation.
- `fastpow`  : Uses `fastpow` from `DiffEqBase.jl`. This is the second fastest
               implementation.
- `base`     : Uses `^` from Julia. This is the slowest implementation, but it's
               accuracy is guaranteed to be within an `<= 1 ulp` for all possible
               input values.
"""
function univariate(m::AbstractMonomialLike, l::Integer, dom::Interval{N}) where {N}
    nvariables(m) == 1 || throw(ArgumentError("this function only acccepts univariate " *
        "monomials but the given monomial has $(nvariables(m)) variables"))

    k = degree(m)
    coeffs = Vector{N}(undef, l+1) # preallocate output
    _univariate!(coeffs, k, l, inf(dom), sup(dom))
end

# fallback
function _univariate!(coeffs::AbstractVector{N}, k::Integer, l::Integer,
                      low::N, high::N) where {N<:AbstractFloat}
    _univariate!(coeffs, k, l, low, high, Val(:fastmath))
end

# use @fastmath macro to allow floating point optimizations
function _univariate!(coeffs::AbstractVector{N}, k::Integer, l::Integer,
                      low::N, high::N, ::Val{:fastmath}) where {N<:AbstractFloat}
    if k < l
        m = l-k
        @fastmath @inbounds begin
             for i in 0:l
                 coeffs[i+1] = zero(N)
                 for j in max(0, i-m):min(k, i)
                     aux = binomial(m, i-j) * binomial(k, j) / binomial(k+m, i)
                     coeffs[i+1] += aux * low^(k-j) * high^j
                 end
            end
        end
    else
        @fastmath @inbounds begin
            for i in 0:l
                coeffs[i+1] = low^(k-i) * high^i
            end
        end
    end
    return coeffs
end

# use fastpow version of ^
function _univariate!(coeffs::AbstractVector{N}, k::Integer, l::Integer,
                      low::N, high::N, ::Val{:fastpow}) where {N<:AbstractFloat}
    if k < l
        m = l-k
        @inbounds begin
             for i in 0:l
                 coeffs[i+1] = zero(N)
                 for j in max(0, i-m):min(k, i)
                     aux = binomial(m, i-j) * binomial(k, j) / binomial(k+m, i)
                     coeffs[i+1] += aux * fastpow(low, k-j) * fastpow(high, j)
                 end
            end
        end
    else
        @fastmath @inbounds begin
            for i in 0:l
                coeffs[i+1] = fastpow(low, k-i) * fastpow(high, i)
            end
        end
    end
    return coeffs
end

# use Julia base version of ^
function _univariate!(coeffs::AbstractVector{N}, k::Integer, l::Integer,
                      low::N, high::N, ::Val{:base}) where {N<:AbstractFloat}
    if k < l
        m = l-k
        @inbounds begin
             for i in 0:l
                 coeffs[i+1] = zero(N)
                 for j in max(0, i-m):min(k, i)
                     aux = binomial(m, i-j) * binomial(k, j) / binomial(k+m, i)
                     coeffs[i+1] += aux * low^(k-j) * high^j
                 end
            end
        end
    else
        @inbounds begin
            for i in 0:l
                coeffs[i+1] = low^(k-i) * high^i
            end
        end
    end
    return coeffs
end

# exact computation using rationals
function _univariate!(coeffs::AbstractVector{N}, k::Integer, l::Integer,
                      low::N, high::N) where {M, N<:Rational{M}}
    if k < l
        m = l-k
        @inbounds for i in 0:l
            coeffs[i+1] = zero(N)
            for j in max(0, i-m):min(k, i)
                aux = binomial(m, i-j) * binomial(k, j) // binomial(k+m, i)
                coeffs[i+1] += aux * low^(k-j) * high^j
            end
        end
    else
        @inbounds @simd for i in 0:l
            coeffs[i+1] = low^(k-i) * high^i
        end
    end
    return coeffs
end

# ===============================================
# Bernstein expansion for multivariate monomials
# ===============================================

"""
    multivariate(k::Vector{Int64}, l::Vector{Int64},
                 low::Vector{N}, high::Vector{N})::ImplicitBernsteinForm{N} where {N<:Number}

Compute the Bernstein coefficients of a multivariate monomial.

### Input

- `k`    -- vector of degrees for each monomial
- `l`    -- vector of degrees of the Bernstein polynomial for each monomial
- `low`  -- the lower bounds of the interval where the Bernstein coefficients are computed
- `high` -- the upper bounds of the interval the Bernstein coefficients are computed

### Output

A Bernstein implicit form holding the Bernstein coefficients.

### Examples

```julia
julia> m = multivariate([3,2],[3,2],[1.0,2],[2,4.0]);
julia> m.array
2-element Array{Array{Float64,1},1}:
 [1.0, 2.0, 4.0, 8.0]
 [4.0, 8.0, 16.0]
```
"""
function multivariate(k::VM, l::VM, X::IntervalBox{N}) where {N, VM<:AbstractVector{Int}}
    l = [vi.lo for vi in b.v]
    h = [vi.lo for vi in b.v] # TODO : merge in one loop
    return _multivariate(k, l, l, h)
end

function _multivariate(k::VM, l::VM, low::VN, high::VN) where {VM<:AbstractVector{Int}, N, VN<:AbstractVector{N}}
    n = length(low)
    ncoeffs = 1
    B = Vector{Vector{N}}(undef, n) # make the same type as the others
    @inbounds for i in 1:n
        @views B[i] = univariate(k[i], l[i], low[i], high[i])
        ncoeffs = ncoeffs * length(B[i])
    end
    return ImplicitBernsteinForm(B, n, ncoeffs)
end
