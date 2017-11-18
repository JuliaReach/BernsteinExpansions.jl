__precompile__(true)
"""
`BersteinExpansions.jl` is a Julia package to compute Bernstein coefficients
of multivariate polynomials.
"""
module BernsteinExpansions

#using RecursiveArrayTools, TensorOperations

export univariate,
       multivariate,
       ImplicitForm,
       generate_tensor_form,
       tensor_multivariate


include("implicit_form.jl")
include("tensorial_form.jl")

end # module
