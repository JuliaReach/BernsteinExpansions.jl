"""
    AbstractBernsteinForm{T}

Abstract supertype for all Bernstein forms types.

### Notes

This type is parametric in the numeric type `T`.


```jldoctest
julia> subtypes(AbstractBernsteinForm)

```
"""
abstract type AbstractBernsteinForm{T} end

@doc """
    numvars(::AbstractBernsteinForm)

Return the number of variables of the given Bernstein form.

### Input

### Output
"""
numvars(::AbstractBernsteinForm)

@doc """
    polynomial(::AbstractBernsteinForm)

Return the polynomial represented by the given Bernstein form.

### Input

### Output

"""
polynomial(::AbstractBernsteinForm)

@doc """
    domain(::AbstractBernsteinForm)
"""
domain(::AbstractBernsteinForm)

@doc """
    enclose(::AbstractBernsteinForm, ::IntervalOrIntervalBox)

### Input

### Output
"""
enclose(::AbstractBernsteinForm, ::IntervalOrIntervalBox)

@doc """
    getcoeff(::AbstractBernsteinForm, ids::NTuple{D, Int}) where {D}

Return the coefficient of the Bernstein expansion corresponding to the tuple `ids`.

### Input

### Output
"""
getcoeff(::AbstractBernsteinForm, ids::NTuple{D,Int}) where {D}
