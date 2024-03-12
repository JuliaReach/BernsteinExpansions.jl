module BernsteinExpansions

using Reexport
using RecursiveArrayTools: VectorOfArray
using MultivariatePolynomials: AbstractMonomialLike, AbstractTermLike, AbstractPolynomialLike,
                               nvariables, degree, monomial, coefficient

@reexport using IntervalArithmetic
const IntervalOrIntervalBox = Union{Interval,IntervalBox}

# Bernstein coefficients of univariate and multivariate monomials
include("fastpow.jl")
include("monomials.jl")

export univariate,
       multivariate

# Bernstein expansion of polynomials on hyperrectangular domains
include("forms.jl")
include("implicit.jl")
include("full.jl")

export ImplicitBernsteinForm,
       FullBernsteinForm

# Range enclosure methods
include("enclosures.jl")

end # module
