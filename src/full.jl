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
struct FullBernsteinForm{T, PT<:AbstractPolynomialLike{T},
                         D, N, MC} <: AbstractBernsteinForm{T}
    pol::PT
    dom::IntervalBox{D, N}
    numvars::Int
    coeffs::MC
    numcoeffs::Int
    degs::VD
end

# univariate case is not special cased
function FullBernsteinForm(pol::PT, dom::Interval, args...) where {T, PT<:AbstractPolynomialLike}
    FullBernsteinForm(pol, IntervalBox(dom), args...)
end

# constructor from
function FullBernsteinForm(pol::PT,
                           dom::IntervalBox, args...) where {T, PT<:AbstractPolynomialLike}
    numvars = nvariables(pol)
  

end
