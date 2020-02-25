module BernsteinExpansions

using Reexport,
      RecursiveArrayTools,
      MultivariatePolynomials

@reexport using IntervalArithmetic

# ===============================================================
# Bernstein forms
# ===============================================================
include("implicit.jl")
include("tensorial.jl")

export ImplicitBernsteinForm

# ===============================================================
# Bernstein expansion of univariate and multivariate monomials
# ===============================================================
include("fastpow.jl")
include("monomials.jl")

export univariate,
       multivariate

# ===============================================================
# Bernstein expansion of polynomials on hyperrectangular domains
# ===============================================================
include("expansion.jl")

export BernsteinExpansion

# ===============================================================
# Enclosure methods
# ===============================================================
#include("enclosures.jl")

end # module
