"""
    FullBernsteinForm{T, PT<:AbstractPolynomialLike{T},
                      D, N, MC} <: AbstractBernsteinForm{T}

Type defining a full (i.e. explicit) Bernstein form of a polynomial over a
hyperrectangular domain.

### Fields

- `pol`         -- polynomial in one or several variables
- `dom`         -- hyperrectangular set of type `IntervalBox` representing the
                   domain of the expansion
- `numvars`     -- number of variables in the polynomial
- `coeffs`      -- multi-dimensional array that holds the Bernstein coefficients
- `numcoeffs`   -- integer holding the number of Bernstein coefficients that are
                   implicitly defined
- `degs`        -- vector of degrees of the Bernstein polynomial for each variables

### Examples
"""
struct FullBernsteinForm{T,PT<:AbstractPolynomialLike{T},
                         D,N,MC,VD<:AbstractVector{Int}} <: AbstractBernsteinForm{T}
    pol::PT
    dom::IntervalBox{D,N}
    numvars::Int
    coeffs::MC
    numcoeffs::Int
    degs::VD

    function FullBernsteinForm(pol::PT, dom::IntervalBox{D,N}, numvars::Int,
                               coeffs::MC, numcoeffs::Int, degs::VD
                              ) where {PT<:AbstractPolynomialLike,D,N,MC,VD<:AbstractVector{Int}}
        T = coefficient_type(PT)
        return new{T,PT,D,N,MC,VD}(pol, dom, numvars, coeffs, numcoeffs, degs)
    end
end

# univariate case is not special cased
function FullBernsteinForm(pol::PT, dom::Interval, args...) where {PT<:AbstractPolynomialLike}
    return FullBernsteinForm(pol, IntervalBox(dom), args...)
end

#=
# constructor from
function FullBernsteinForm(pol::PT, dom::IntervalBox, args...) where {PT<:AbstractPolynomialLike}
    numvars = nvariables(pol)

end
=#
