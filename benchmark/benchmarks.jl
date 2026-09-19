using BernsteinExpansions, BenchmarkTools, DynamicPolynomials

SUITE = BenchmarkGroup()

@polyvar x y

SUITE["Univariate"] = SUni = BenchmarkGroup()
SUni["floating point, degree 3"] = @benchmarkable univariate($(x^3), 3, $(interval(1.0, 2.0)))
SUni["floating point, degree 5"] = @benchmarkable univariate($x, 5, $(interval(0.0, 1.0)))
SUni["rational, degree 3"] = @benchmarkable univariate($(x^3), 3, $(interval(1 // 1, 2 // 1)))

SUITE["Multivariate"] = SMulti = BenchmarkGroup()
m = x^2 * y^3
l = [5, 5]
box_float = IntervalBox(interval(1.0, 2.0), interval(1.0, 2.0))
box_rational = IntervalBox(interval(1 // 1, 2 // 1), interval(1 // 1, 2 // 1))
SMulti["floating point"] = @benchmarkable multivariate($m, $l, $box_float)
SMulti["rational"] = @benchmarkable multivariate($m, $l, $box_rational)
