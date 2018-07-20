"""
    generate_tensor_form(implicitform::ImplicitForm{T})::Vector{T} where{T<:Number}

Compute the Bernstein expansion in tensorial form given its implicit form.

### Input

- `implicitform` -- Bernstein expansion in implicit form

### Algorithm

This implementation uses Julia's Kronecker product `kron` function.
"""
function generate_tensor_form(implicitform::ImplicitForm{T})::Vector{T} where{T<:Number}
    berncoeffs = implicitform.array[1]
    for i in 2:implicitform.dim
        berncoeffs = kron(berncoeffs, implicitform.array[i])
    end
    return berncoeffs
end


# function generate_tensor_form_improved(implicitform::ImplicitForm{T}, l::Vector{Int64})::Vector{T} where{T<:Number}
#
#     if implicitform.dim<= 0
#         println("Empty implicit form")
#         return implicitform.array[0]
#     end
#
#     if implicitform.dim == 1
#         return implicitform.array[1]
#     end
#
#     e::Int64 = (l[1]+1)*(l[2]+1) #current array size
#     pe::Int64 = e # previous array size
#     berncoeffs = Array{Float64,1}(implicitform.ncoeffs)
#     berncoeffs[1:e] = kron(implicitform.array[1], implicitform.array[2])
#
#     if implicitform.dim > 2
#         @inbounds for i in 3:implicitform.dim
#             e = e*(l[i]+1)
#             @views berncoeffs[1:e]  = kron(berncoeffs[1:pe], implicitform.array[i])
#             pe = e
#         end
#     end
#
#     return berncoeffs
# end

"""
    multivariate_tensor(k::Vector{Int64}, l::Vector{Int64},
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
function multivariate_tensor(k::Vector{Int64}, l::Vector{Int64},
                             low::Vector{T}, high::Vector{T})::Vector{T} where {T<:Number}

    n = length(low)
    berncoeffs  = univariate(k[1], l[1], low[1], high[1])

    @inbounds for i in 2:n
        berncoeffs = kron(berncoeffs, univariate(k[i], l[i], low[i], high[i]))
    end

    return berncoeffs
end
