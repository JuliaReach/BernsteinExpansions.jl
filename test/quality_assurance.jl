using BernsteinExpansions, Test
import Aqua

import Pkg
@static if VERSION >= v"1.6"  # TODO make explicit test requirement
    Pkg.add("ExplicitImports")
    import ExplicitImports

    @testset "ExplicitImports tests" begin
        @test isnothing(ExplicitImports.check_all_explicit_imports_are_public(BernsteinExpansions))
        @test isnothing(ExplicitImports.check_all_explicit_imports_via_owners(BernsteinExpansions))
        @test isnothing(ExplicitImports.check_all_qualified_accesses_are_public(BernsteinExpansions))
        @test isnothing(ExplicitImports.check_all_qualified_accesses_via_owners(BernsteinExpansions))
        @test_broken isnothing(ExplicitImports.check_no_implicit_imports(BernsteinExpansions))  # related to IntervalArithmetic
        @test isnothing(ExplicitImports.check_no_self_qualified_accesses(BernsteinExpansions))
        @test isnothing(ExplicitImports.check_no_stale_explicit_imports(BernsteinExpansions))
    end
end

@testset "Aqua tests" begin
    Aqua.test_all(BernsteinExpansions)
end
