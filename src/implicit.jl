"""
    ImplicitBernsteinForm{T, PT<:AbstractPolynomialLike{T},
                          D, N, TC, NC, SC} <: AbstractBernsteinForm{T}

Type defining an implicit Bernstein form of a polynomial over a hyperrectangular
domain.

### Fields

- `pol`         -- polynomial in one or several variables
- `dom`         -- hyperrectangular set of type `IntervalBox` representing the
                   domain of the expansion
- `numvars`     -- number of variables in the polynomial
- `coeffs`      -- vector of arrays that holds the Bernstein coefficients implicitly
- `numcoeffs`   -- integer holding the number of Bernstein coefficients that are
                   implicitly defined
- `degs`        -- vector of degrees of the Bernstein polynomial for each variable

### Examples
"""
struct ImplicitBernsteinForm{T, PT<:AbstractPolynomialLike{T},
                             D, N, TC, NC, SC, VD<:AbstractVector{Int}} <: AbstractBernsteinForm{T}
    pol::PT
    dom::IntervalBox{D, N}
    numvars::Int
    coeffs::VectorOfArray{TC, NC, SC}
    numcoeffs::Int
    degs::VD
end

# univariate case is not special cased
function ImplicitBernsteinForm(pol::PT, dom::Interval, args...) where {T, PT<:AbstractPolynomialLike}
    ImplicitBernsteinForm(pol, IntervalBox(dom), args...)
end

#=
# constructor from
function ImplicitBernsteinForm(pol::PT, dom::IntervalBox, args...) where {T, PT<:AbstractPolynomialLike}
    numvars = nvariables(pol)


end
=#

function getcoeff(bf::ImplicitBernsteinForm, ids::NTuple{D, Int}) where {D}
    return prod(bf.coeffs[k, i] for (i, k) in enumerate(ids))
end

function assemble(array::Vector{VN}) where {N, VN<:AbstractVector{N}}
    n = length(array)
    if n == 1
        return hcat(first(array))
    elseif n == 2
        return array[1] * array[2]'
    else
        error("not implemented yet")
    end
    # preallocate grid ...
end

#=
# mutating versions
function _assemble!(..)
    ...
end
=#
