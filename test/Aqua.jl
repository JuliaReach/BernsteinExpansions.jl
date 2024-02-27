using BernsteinExpansions, Test
import Aqua

@testset "Aqua tests" begin
    Aqua.test_all(BernsteinExpansions; ambiguities=false)

    # do not warn about ambiguities in dependencies
    Aqua.test_ambiguities(BernsteinExpansions)
end
