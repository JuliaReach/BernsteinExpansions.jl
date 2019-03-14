"""
    BernsteinExpansion{T, PT<:AbstractPolynomialLike{T}} <: AbstractBernsteinExpansion{T}

Type defining the expansion of a polyomial over a box using the Bernstein form.

### Fields

- `array` -- the vector of vectors holding the Bernstein coefficients
- `dim`   -- an integer representing the ambient dimension
"""
struct BernsteinExpansion{T, PT<:AbstractPolynomialLike{T}}
    pol::PT
    box::IntervalBox{T}
    dim::Int
    ncoeffs::Int
end

#=
"""
    ImplicitBernsteinPolynomialEnclosure{T, N} <: AbstractBernsteinForm{N}

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
=#
