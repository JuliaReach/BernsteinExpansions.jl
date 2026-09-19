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
function numvars(::AbstractBernsteinForm) end

"""
    polynomial(::AbstractBernsteinForm)

Return the polynomial represented by the given Bernstein form.

### Input

- `bf` -- Bernstein form

### Output

The polynomial associated to `bf`.
"""
function polynomial(::AbstractBernsteinForm) end

"""
    domain(::AbstractBernsteinForm)

Return the domain over which the given Bernstein form was computed.

### Input

- `bf` -- Bernstein form

### Output

The hyperrectangular domain of `bf`, of type `IntervalOrIntervalBox`.
"""
function domain(::AbstractBernsteinForm) end

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
