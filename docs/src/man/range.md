```@meta
DocTestSetup  = quote
    using BernsteinExpansions
end
```

# Range Enclosure

```@contents
Pages = ["range.md"]
Depth = 3
```

## Enclosure property

Let $p$ be a polynomial $n$ variables of degree $l = (l_1, \ldots, l_n)$,

```math
    p(x) = \sum_{i=0}^l a_i x^i,\qquad x = (x_1, \ldots, x_n),
```
and the axis-aligned hyperrectangular set $X$.

Range enclosure using Bernstein expansion is to compute a tight outer approximation
for $p(X)$, the range of $p$ over $X$. Such bounds can be determined by using
the coefficients of the expansion of the given polynomial into Bernstein polynomials.

TODO: add property

```math
    \min_{i} b_i ≤ p(x) ≤ \max b_i.
```

## Examples

```@example range_example
using BernsteinExpansions, DynamicPolynomials

@polyvar x y
```
