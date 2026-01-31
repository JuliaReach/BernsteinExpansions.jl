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

univariate(x^3, 3, interval(1, 2))
```

```@example univariate
univariate(2x^3, 3, interval(1, 2))
```

## References

[Smith09, Smith12, TitiG17](@citet)
