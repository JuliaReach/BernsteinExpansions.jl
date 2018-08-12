export generate_tensor_form,
       multivariate_tensor

using Base.Cartesian

"""
    generate_tensor_form(B::ImplicitBernsteinForm{N}; algorithm::String="loop") where {N}

Compute the Bernstein expansion in tensorial form given its implicit form.

### Input

- `B`         -- Bernstein expansion in implicit form
- `algorithm` -- (optional, default: `"tensor_generated"`) the algorithm used
                 for this calculation, valid options are:

    * `"tensor_naive"`
    * `"tensor_generated"`
    * `"linear_kron"`
    * `"linear_kron_single"`

### Output

A multi-dimensional array for the "tensor_" algorithms, or a one-dimensional
array for the "linear_" algorithms, such that

```math
    A[i_1, …, i_n] = v[i_1] ⋯ v[i_n]
```
"""
function generate_tensor_form(B::ImplicitBernsteinForm{N}; algorithm::String="tensor") where {N}
    v = B.array
    if algorithm == "tensor_naive"
        A = ones(N, Tuple(length(vi) for vi in v))
        _tensor_naive!(A, B.ncoeffs, v)
    elseif algorithm == "tensor_generated"
        A = Array{N, length(v)}(undef, Tuple(length(vi) for vi in v))
        _tensor_generated!(A, v)
    elseif algorithm == "linear_kron"
        A = _linear_kron(v)
    elseif algorithm == "linear_kron_single"
        A = _linear_kron_single(v)
    else
        error("algorithm $algorithm is unknown")
    end
    return A
end

function _tensor_naive!(A::AbstractArray{T, N}, ncoeffs::Int, v::VectorOfArray) where {T, N}
    d = length(v)
    @inbounds for i in 1:ncoeffs
        mj = ind2sub(A,i)
        for j in 1:d
            @views A[i] = A[i] .* v[mj[j], j]
        end
    end
end

function _linear_kron(v::VectorOfArray)
    A = v[1]
    @inbounds for i in 2:length(v)
        A = kron(A, v[i])
    end
    return A
end

function _linear_kron_single(v::VectorOfArray)
    return kron(v...)
end

"""
```
    _tensor_generated!(A::AbstractArray{T, N}, v::VectorOfArray) where {T, N}
```

Compute the Bernstein expansion in tensorial form given its implicit form, using
a generated function in a nested loop.

### Input

- `A` --
- `v` --

### Output

A multi-dimensional array containing the coefficients.

### Algorithm

This implementation uses Julia's `Base.Cartesian` to generate a set of nested
loops to compute the element ``A[i_1, …, i_n]``.

### TODO

Correct output ordering in multi-array mode, incorrect 1D array mode.
"""
@generated function _tensor_generated!(A::AbstractArray{T, N}, v::VectorOfArray) where {T, N}
    quote
        @inbounds for $(Symbol(:i_, N)) in eachindex(v[$N])
                  @nloops $(N-1) i i -> eachindex(v[i]) d -> d == 1 ?
                            nothing :
                            d == $N-1 ?
                                    t_{d-1} = v[i_{d}, d] * v[i_{d+1}, d+1] :
                                    t_{d-1} = t_{d} * v[i_{d}, d] begin
                                        if $N==2
                                            (@nref $N A i) = v[i_1, 1] * v[i_2, 2]
                                        else
                                            (@nref $N A i) = t_1 * v[i_1, 1]
                                        end
                                end
               end
     end
end

"""
    multivariate_tensor(k::Vector{Int64}, l::Vector{Int64},
                        low::Vector{T}, high::Vector{T};
                        algorithm::String="tensor_generated")

Compute the Bernstein coefficients of a multivariate monomial in the tensor form.

### Input

- `k`         -- vector of degrees for each monomial
- `l`         -- vector of degrees of the Bernstein polynomial for each monomial
- `low`       -- the lower bounds of the interval where the Bernstein coefficients are computed
- `high`      -- the upper bounds of the interval the Bernstein coefficients are computed
- `algorithm` -- (optional, default: `"tensor_generated"`) the algorithm used for
                 this calculation, see valid options in `generate_tensor_form`
"""
function multivariate_tensor(k::Vector{Int64}, l::Vector{Int64},
                             low::Vector{T}, high::Vector{T};
                             algorithm::String="tensor") where {T}

    n = length(low)
    berncoeffs = VectorOfArray([univariate(k[i], l[i], low[i], high[i]) for i in 1:n])
    generate_tensor_form(berncoeffs, algorithm=algorithm)
end
