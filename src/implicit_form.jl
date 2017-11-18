"""
    ImplicitForm{T<:Number}

Type defining an implicit Bernstein form.

### Fields

- `array` -- the vector of vectors holding the Bernstein coefficients
- `dim`   -- an integer representing the ambient dimension
"""
struct ImplicitForm{N<:Number}
    array::Vector{Vector{N}}
    dim::Int64
    ncoeffs::Int64
end

include("monomials.jl")
