# Methods

This section includes the methods implemented in `BernsteinExpansions.jl`.

```@contents
Pages = ["methods.md"]
Depth = 3
```

```@meta
CurrentModule = BernsteinExpansions
DocTestSetup = quote
    using BernsteinExpansions
end
```

## Implicit Form

Functions to compute the implicit Bernstein form of univariate and multivariate
monomials.

```@docs
univariate
multivariate
```

## Tensorial Form

Functions to compute the tensorial Bernstein form of univariate and multivariate
monomials.

```@docs
generate_tensor_form
multivariate_tensor
_tensor_generated!
```
