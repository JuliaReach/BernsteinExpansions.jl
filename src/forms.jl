"""
    AbstractBernsteinForm{T}

Abstract supertype for all Bernstein forms types.

### Notes

This type is parametric in the numeric type `T`.

```jldoctest
julia> using BernsteinExpansions: AbstractBernsteinForm

julia> subtypes(AbstractBernsteinForm)
2-element Vector{Any}:
 FullBernsteinForm
 ImplicitBernsteinForm
```
"""
abstract type AbstractBernsteinForm{T} end

"""
    numvars(::AbstractBernsteinForm)

Return the number of variables of the given Bernstein form.

### Input

- `bf` -- Bernstein form

### Output

The number of variables of the polynomial represented by `bf`.
"""
numvars(bf::AbstractBernsteinForm) = bf.numvars

"""
    polynomial(::AbstractBernsteinForm)

Return the polynomial represented by the given Bernstein form.

### Input

- `bf` -- Bernstein form

### Output

The polynomial associated to `bf`.
"""
polynomial(bf::AbstractBernsteinForm) = bf.pol

"""
    domain(::AbstractBernsteinForm)

Return the domain over which the given Bernstein form was computed.

### Input

- `bf` -- Bernstein form

### Output

The hyperrectangular domain of `bf`, of type `IntervalOrIntervalBox`.
"""
domain(bf::AbstractBernsteinForm) = bf.dom

"""
    enclose(bf::AbstractBernsteinForm)

Compute a range enclosure of the polynomial represented by `bf` over its own
domain, `domain(bf)`.

### Input

- `bf` -- Bernstein form

### Output

An interval (or interval box) that is guaranteed to contain `polynomial(bf)(x)`
for every `x` in `domain(bf)` — the minimum and maximum Bernstein coefficients
of `bf` bound the range of the polynomial.
"""
enclose(bf::AbstractBernsteinForm) = enclose(bf, domain(bf))

"""
    enclose(::AbstractBernsteinForm, ::IntervalOrIntervalBox)

Compute a range enclosure of the polynomial represented by the given Bernstein form.

### Input

- `bf` -- Bernstein form
- `X`  -- hyperrectangular domain over which to compute the enclosure

### Output

An interval (or interval box) that contains the range of the polynomial over `X`.

### Notes

TODO: not implemented yet.
"""
function enclose(::AbstractBernsteinForm, ::IntervalOrIntervalBox) end

"""
    getcoeff(::AbstractBernsteinForm, ids::NTuple{D, Int}) where {D}

Return the coefficient of the Bernstein expansion corresponding to the tuple `ids`.

### Input

- `bf`  -- Bernstein form
- `ids` -- tuple of per-variable indices identifying the requested coefficient

### Output

The Bernstein coefficient of `bf` at multi-index `ids`.
"""
function getcoeff(::AbstractBernsteinForm, ids::NTuple{D,Int}) where {D} end
