__precompile__(true)
"""
`BersteinExpansions.jl` is a Julia package to compute Bernstein coefficients
of multivariate polynomials.
"""
module BernsteinExpansions

#using RecursiveArrayTools, TensorOperations

export generate_tensor_form,
       generate_tensor_form_improved,
       ImplicitForm,
       univariate,
       multivariate,
       multivariate_tensor

include("implicit_form.jl")
include("tensorial_form.jl")

end # module
