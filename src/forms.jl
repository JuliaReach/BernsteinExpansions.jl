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

"""
    numvars(::AbstractBernsteinForm)

Return the number of variables of the given Bernstein form.

### Input

### Output
"""
function numvars(::AbstractBernsteinForm) end

"""
    polynomial(::AbstractBernsteinForm)

Return the polynomial represented by the given Bernstein form.

### Input

### Output

"""
function polynomial(::AbstractBernsteinForm) end

"""
    domain(::AbstractBernsteinForm)
"""
function domain(::AbstractBernsteinForm) end

"""
    enclose(::AbstractBernsteinForm, ::IntervalOrIntervalBox)

### Input

### Output
"""
function enclose(::AbstractBernsteinForm, ::IntervalOrIntervalBox) end

"""
    getcoeff(::AbstractBernsteinForm, ids::NTuple{D, Int}) where {D}

Return the coefficient of the Bernstein expansion corresponding to the tuple `ids`.

### Input

### Output
"""
function getcoeff(::AbstractBernsteinForm, ids::NTuple{D,Int}) where {D} end
