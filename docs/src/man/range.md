# Range Enclosure

```@contents
Pages = ["range.md"]
Depth = 3
```

## Property

Let $p$ be a polynomial $n$ variables of degree $l = (l_1, \ldots, l_n)$,
```math
    p(x) = \sum_{i=0}^l a_i x^i,\qquad x = (x_1, \ldots, x_n),
```
and the axis-aligned hyperrectangular set
$$
X = [\bar{x}_1, \overline{x}_1]
$$
The goal of the range enclosure using Bernstein expansion is to compute a tight
outer approximation for $p(X)$, the range of $p$ over $X$. Such bounds can be
determined by utilising the coefficients of the expansion of the given polynomial
into Bernstein polynomials.

The property . . . .

```math
    \min_{i} b_i ≤ p(x) ≤ \max b_i.
```

## Example

```@example range_example
using DynamicPolynomials

@polyvar x y
p = x^2 * y
```

