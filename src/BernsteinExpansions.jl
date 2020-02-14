__precompile__(true)
module BernsteinExpansions

using Compat
import Compat.String

using RecursiveArrayTools

import MultivariatePolynomials
import MultivariatePolynomials: AbstractPolynomialLike

import IntervalArithmetic
import IntervalArithmetic: Interval, IntervalBox

# ===========================================================
# Methods to calculate the Bernstein expansion of univariate 
# and multivariate monomials
# ===========================================================
export univariate,
       multivariate

include("monomials.jl")

# =============================================================
# Types to represent the Bernstein expansion of polynomials on
#  hyperrectangular domains
# =============================================================
export BernsteinExpansion

include("expansion.jl")

# ==============================================================
# Enclosure methods for polynomials in hyperrectangular domains
# ==============================================================
include("enclosures.jl")

# ================================================
# Types to represent the implicit Bernstein form
# ================================================
export ImplicitBernsteinForm

include("implicit.jl")

# ================================================
# Types to represent the tensorial Bernstein form
# ================================================
include("tensorial.jl")

end # module
