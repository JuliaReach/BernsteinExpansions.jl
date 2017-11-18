function generate_tensor_form(implicitform::ImplicitForm{T})::Vector{T} where{T<:Number}
    berncoeffs = implicitform.array[1]
    for i in 2:implicitform.dimension
        berncoeffs = kron(berncoeffs, implicitform.array[2])
    end
    return berncoeffs
end

"""
    tensor_multivariate(k::Vector{Int64}, l::Vector{Int64},
                          low::Vector{T}, high::Vector{T})::Vector{T} where {T<:Number}

Compute the Bernstein coefficients of a multivariate monomial in the tensor form.

### Input

- `k`    -- vector of degrees for each monomial
- `l`    -- vector of degrees of the Bernstein polynomial for each monomial
- `low`  -- the lower bounds of the interval where the Bernstein coefficients are computed
- `high` -- the upper bounds of the interval the Bernstein coefficients are computed

### Algorithm

This implementation uses Julia's Kronecker product `kron` function.
"""
function tensor_multivariate(k::Vector{Int64}, l::Vector{Int64},
                            low::Vector{T}, high::Vector{T})::Vector{T} where {T<:Number}

    n = length(low)
    berncoeffs  = univariate(k[1], l[1], low[1], high[1])

    @inbounds for i in 2:n
        berncoeffs = kron(berncoeffs, univariate(k[i], l[i], low[i], high[i]))
    end

    return berncoeffs
end
