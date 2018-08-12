using BernsteinExpansions, Compat, BenchmarkTools

SUITE = BenchmarkGroup()  # parent BenchmarkGroup to contain our suite

SUITE["Univariate"] = SUni = BenchmarkGroup()
SUni["Univariate monomial, floating point input, degree 3"] = @benchmarkable univariate(3, 3, 1.0, 2.0)
SUni["Univariate monomial, floating point input, degree 5"] = @benchmarkable univariate(1, 5, 0.0, 1.0)

SUITE["Multivariate"] = SMulti = BenchmarkGroup()
k = [1,2,3,4,5,2,3,4]
l = [5,5,5,5,5,5,5,5]

low = [1//1,1//1,1//1,1//1,1//1,1//1,1//1,1//1]
high = [2//1,2//1,2//1,2//1,2//1,2//1,2//1,2//1]
m = multivariate(k, l, low, high)
SMulti["Rational multivariate implicit expansion"] = @benchmarkable multivariate($k, $l, $low, $high)
SMulti["Rational multivariate full expansion (tensor algorithm)"] = @benchmarkable generate_tensor_form($m, algorithm="tensor_generated")
SMulti["Rational multivariate full expansion (kron algorithm)"] = @benchmarkable generate_tensor_form($m, algorithm="linear_kron")

low = convert(Vector{Float64}, low)
high = convert(Vector{Float64}, high)
m = multivariate(k, l, low, high)
SMulti["Float64 multivariate implicit expansion"] = @benchmarkable multivariate($k, $l, $low, $high)
SMulti["Float64 multivariate full expansion (tensor algorithm)"] = @benchmarkable generate_tensor_form($m, algorithm="tensor_generated")
SMulti["Float64 multivariate full expansion (kron algorithm)"] = @benchmarkable generate_tensor_form($m, algorithm="linear_kron")
