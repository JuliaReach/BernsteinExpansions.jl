module BernsteinExpansions

using Reexport: @reexport
using RecursiveArrayTools: VectorOfArray
using MultivariatePolynomials: AbstractMonomialLike, AbstractTermLike, AbstractPolynomialLike,
                               nvariables, degree, monomial, coefficient, exponents

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

export univariate,
       multivariate,
       ImplicitBernsteinForm,
       FullBernsteinForm
export IntervalBox

end # module
