module BernsteinExpansions

using Reexport,
      RecursiveArrayTools,
      MultivariatePolynomials

@reexport using IntervalArithmetic
const IntervalOrIntervalBox = Union{Interval, IntervalBox}

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
       ExplicitBernsteinForm,
       FullBernsteinForm

# Range enclosure methods
include("enclosures.jl")

end # module
