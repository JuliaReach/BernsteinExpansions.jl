using BernsteinExpansions, Test
import Aqua, ExplicitImports, JET

@testset "ExplicitImports tests" begin
    # related to reexporting IntervalArithmetic
    ignores_no_implicit_imports = (:IntervalArithmetic, :Interval, :inf, :sup)
    ExplicitImports.test_explicit_imports(BernsteinExpansions;
                                          no_implicit_imports=(ignore=ignores_no_implicit_imports,))
end

@testset "JET tests" begin
    JET.test_package(BernsteinExpansions)
end

@testset "Aqua tests" begin
    # some libraries are only used in the test suite
    test_only_deps = [:Aqua, :DynamicPolynomials, :ExplicitImports, :JET, :StaticArrays]
    Aqua.test_all(BernsteinExpansions; stale_deps=(ignore=test_only_deps,))
end
