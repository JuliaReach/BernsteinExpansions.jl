module BernsteinExpansions

using Reexport: @reexport
using RecursiveArrayTools: VectorOfArray
using MultivariatePolynomials: AbstractMonomialLike, AbstractPolynomialLike, AbstractTermLike,
                               coefficient, coefficient_type, degree, exponents, monomial,
                               nvariables

@reexport using IntervalArithmetic
using IntervalBoxes: IntervalBox
const IntervalOrIntervalBox = Union{Interval,IntervalBox}

# Bernstein coefficients of univariate and multivariate monomials
include("fastpow.jl")
include("monomials.jl")

# Bernstein expansion of polynomials on hyperrectangular domains
include("forms.jl")
include("implicit.jl")
include("full.jl")

# Range enclosure methods
include("enclosures.jl")

export univariate,
       multivariate,
       ImplicitBernsteinForm,
       FullBernsteinForm
export IntervalBox

end # module
