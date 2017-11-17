__precompile__(true)
"""
`BersteinExpansions.jl` is a Julia package to compute Bernstein coefficients
of multivariate polynomials.
"""
module BernsteinExpansions

export univariate,
       multivariate,
       ImplicitForm

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
end

include("monomials.jl")

end # module
