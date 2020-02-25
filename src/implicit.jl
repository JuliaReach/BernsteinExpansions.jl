"""
    AbstractBernsteinForm{N}

Abstract supertype for all Bernstein forms types.
It is parametric in the numeric type `N`.
"""
abstract type AbstractBernsteinForm{N} end

"""
    ImplicitBernsteinForm{T, N} <: AbstractBernsteinForm{N}

Type defining an implicit Bernstein form.

### Fields

- `array`      -- vector of vectors holding the Bernstein coefficients implicitly
- `dim`        -- an integer representing the ambient dimension
- `numcoeffs`  -- number of coefficients
"""
struct ImplicitBernsteinForm{T, N} <: AbstractBernsteinForm{N}
    array::VectorOfArray{T, N}
    dim::Int
    numcoeffs::Int
end

# constructor from vector of vectors
function ImplicitBernsteinForm(array::Vector{<:AbstractVector}, n::Int, numcoeffs::Int)
    array = VectorOfArray(array)
    return ImplicitBernsteinForm(array, dim, ncoeffs)
end
