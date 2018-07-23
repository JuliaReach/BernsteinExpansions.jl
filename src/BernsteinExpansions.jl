__precompile__(true)
module BernsteinExpansions

using RecursiveArrayTools

export ImplicitForm,
       univariate,
       multivariate

include("implicit_form.jl")
include("tensorial_form.jl")

end # module
