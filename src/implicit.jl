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

- `array` -- the vector of vectors holding the Bernstein coefficients
- `dim`   -- an integer representing the ambient dimension
"""
struct ImplicitBernsteinForm{T, N} <: AbstractBernsteinForm{N}
    array::VectorOfArray{T, N}
    dim::Int
    ncoeffs::Int
end

# constructor from vector of vectors
ImplicitBernsteinForm(array::Vector{Vector{N}}, dim::Int, ncoeffs::Int) where {N} =
    ImplicitBernsteinForm(VectorOfArray(array), dim, ncoeffs)


