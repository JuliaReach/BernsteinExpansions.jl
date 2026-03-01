using BernsteinExpansions, Test
import Aqua, ExplicitImports

@testset "ExplicitImports tests" begin
    # related to reexporting IntervalArithmetic
    ignores_no_implicit_imports = (:IntervalArithmetic, :Interval, :inf, :sup)
    ExplicitImports.test_explicit_imports(BernsteinExpansions;
                                          no_implicit_imports=(ignore=ignores_no_implicit_imports,))
end

@testset "Aqua tests" begin
    Aqua.test_all(BernsteinExpansions)
end
