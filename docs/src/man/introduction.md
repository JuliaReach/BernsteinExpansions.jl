```@meta
DocTestSetup  = quote
    using BernsteinExpansions
end
```

# Introduction

```@contents
Pages = ["introduction.md"]
Depth = 3
```

## Bernstein Expansion

Consider a polynomial in ``n`` variables, ``x_1, \ldots, x_n`` expressed in its power form,

```math
    p(x) = \\sum_{i=0}^l a_i x^i,\qquad x = (x_1, \ldots, x_n),
```
where we use the multi-index notation. The degree of ``p`` is ``l = (l_1, \ldots, l_n)``,
``0 ≤ l_i < \infty`` for all ``i = 1, \ldots, n``.

Box
```math
X = [\bar{x}_1, \overline{x}_1]
```

## Example

```@example univariate
using BernsteinExpansions, DynamicPolynomials

@polyvar x

univariate(x^3, 3, 1..2)
```

```@example univariate
univariate(2x^3, 3, 1..2)
```


## References

[1] Smith, A. P. *Fast construction of constant bound functions for sparse
    polynomials.* [Journal of Global Optimization 43.2 (2009): 445-458](https://link.springer.com/article/10.1007/s10898-007-9195-4).

[2] Smith, A. P. *Enclosure methods for systems of polynomial equations and
    inequalities*. [Doctoral dissertation, Universität Konstanz (2012)](https://d-nb.info/1028327854/34).

[3] Titi, J., & Garloff, J. (2017). *Fast determination of the tensorial and
    simplicial Bernstein forms of multivariate polynomials and rational functions.*
    [Konstanzer Schriften in Mathematik; 361](http://kops.uni-konstanz.de/handle/123456789/39178).
