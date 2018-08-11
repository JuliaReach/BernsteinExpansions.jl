export generate_tensor_form,
       multivariate_tensor

using Base.Cartesian

"""
    generate_tensor_form(B::ImplicitForm{N}; algorithm::String="loop") where {N}

Compute the Bernstein expansion in tensorial form given its implicit form.

### Input

- `B`         -- Bernstein expansion in implicit form
- `algorithm` -- (optional, default: `"loop"`) the implementation used for this
                 calculation, valid options are:

    * `"loop"`
    * `"kron"`
"""
function generate_tensor_form(B::ImplicitForm{N}; algorithm::String="loop") where {N}
    # unpack fields
    v = VectorOfArray(B.array) # FIXME : move to type?
    if algorithm == "naive"
        A = ones(typeof(v[1,1]),Tuple(length(vi) for vi in v))
        _naive!(A,B.ncoeffs,v)
    else
        A = generate_tensor_form(v, algorithm=algorithm)
    end
    return A
end

function generate_tensor_form(v::VectorOfArray{N, D, T}; algorithm::String="loop") where {N, D, T}
    if algorithm == "loop"
        # preallocate output array
        A = Array{N, length(v)}(undef, Tuple(length(vi) for vi in v))
        _loop_tensor!(A, v)
    elseif algorithm == "kron"
        # preallocate output array
        A = _kron_tensor(v)
    elseif algorithm == "single_kron"
        A = _skron_tensor(v)
    else
        error("the tensorial expansion algorithm $algorithm is unknown")
    end
    return A
end

"""
```
    _kron_tensor!(B::ImplicitForm{N}) where {N}
```
TODO: Docs outdated
Compute the Bernstein expansion in tensorial form given its implicit form, using
the Kronecker power.

### Input

- `B` -- Bernstein expansion in implicit form

### Output

A one-dimensional array of the same numeric type as the given implicit form.

### Algorithm

This implementation uses Julia's Kronecker product `kron` function in a loop.
"""
function _skron_tensor(v)
    return kron(v...)
end

"""
```
    _kron_tensor!(B::ImplicitForm{N}) where {N}
```
TODO: Docs outdated
Compute the Bernstein expansion in tensorial form given its implicit form, using
the Kronecker power.

### Input

- `B` -- Bernstein expansion in implicit form

### Output

A one-dimensional array of the same numeric type as the given implicit form.

### Algorithm

This implementation uses Julia's Kronecker product `kron` function in a loop.
"""
function _kron_tensor(v::VectorOfArray)
    A = v[1] # FIXME: this is not using the given A
    @inbounds for i in 2:length(v)
        A = kron(A, v[i])
    end
    return A
end

"""
```
    _loop_tensor!(A::AbstractArray{T, N}, v::VectorOfArray) where {T, N}
```

Compute the Bernstein expansion in tensorial form given its implicit form, using
a nested loop.

### Input

- `B` -- Bernstein expansion in implicit form

### Output

A multi-dimensional array containing the coefficients.

### Algorithm

This implementation uses Julia's `Base.Cartesian` to generate a set of nested
loops to compute the element ``A[i_1, …, i_n]``.
"""
#FIXME: Correct output ordering in multi-array mode, incorrect 1D array mode.
@generated function _loop_tensor!(A::AbstractArray{T, N}, v::VectorOfArray) where {T, N}
    quote
        @inbounds for $(Symbol(:i_, N)) in eachindex(v[$N])
                  @nloops $(N-1) i i -> eachindex(v[i]) d -> d == 1 ?
                            nothing :
                            d == $N-1 ?
                                    t_{d-1} = v[i_{d}, d] * v[i_{d+1}, d+1]:
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

function _naive!(A::AbstractArray{T, N}, ncoeffs::Int64, v::VectorOfArray) where {T, N}

    d = length(v)

    @inbounds for i in 1:ncoeffs
        mj = ind2sub(A,i)
            @inbounds for j in 1:d
                @views A[i] = A[i].*v[j][mj[j]]
            end
    end
end
"""
    multivariate_tensor(k::Vector{Int64}, l::Vector{Int64},
                          low::Vector{T}, high::Vector{T};
                          algorithm::String="loop")

Compute the Bernstein coefficients of a multivariate monomial in the tensor form.

### Input

- `k`    -- vector of degrees for each monomial
- `l`    -- vector of degrees of the Bernstein polynomial for each monomial
- `low`  -- the lower bounds of the interval where the Bernstein coefficients are computed
- `high` -- the upper bounds of the interval the Bernstein coefficients are computed
- `algorithm` -- (optional, default: `"loop"`) the implementation used for this
                 calculation, valid options are:

    * `"loop"`
    * `"kron"`
"""
function multivariate_tensor(k::Vector{Int64}, l::Vector{Int64},
                             low::Vector{T}, high::Vector{T};
                             algorithm::String="loop") where {T}

    n = length(low)
    berncoeffs = VectorOfArray([univariate(k[i], l[i], low[i], high[i]) for i in 1:n])
    generate_tensor_form(berncoeffs, algorithm=algorithm)
end
