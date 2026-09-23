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

Let ``p`` be a polynomial ``n`` variables of degree ``l = (l_1, \ldots, l_n)``,

```math
    p(x) = \sum_{i=0}^l a_i x^i,\qquad x = (x_1, \ldots, x_n),
```
and the axis-aligned hyperrectangular set ``X``.

Range enclosure using Bernstein expansion is to compute a tight outer approximation
for ``p(X)``, the range of ``p`` over ``X``. Such bounds can be determined by using
the coefficients ``b_i`` of the expansion of the given polynomial into Bernstein
polynomials, since

```math
    \min_{i} b_i ≤ p(x) ≤ \max_i b_i \qquad \text{for all } x \in X.
```

## Examples

TODO: add a worked example once `enclose` is implemented (see
[forms.jl](https://github.com/JuliaReach/BernsteinExpansions.jl/blob/master/src/forms.jl)).
