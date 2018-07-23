__precompile__(true)
module BernsteinExpansions

using RecursiveArrayTools

export generate_tensor_form,
       ImplicitForm,
       univariate,
       multivariate,
       multivariate_tensor

include("implicit_form.jl")
include("tensorial_form.jl")

end # module
