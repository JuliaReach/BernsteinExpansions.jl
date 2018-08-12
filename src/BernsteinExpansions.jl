__precompile__(true)
module BernsteinExpansions

using Compat
import Compat.String

using RecursiveArrayTools

export ImplicitBernsteinForm,
       univariate,
       multivariate

include("implicit_form.jl")
include("tensorial_form.jl")

end # module
