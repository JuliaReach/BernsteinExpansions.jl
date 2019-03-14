using Documenter, BernsteinExpansions

makedocs(
    doctest = true,  # use this flag to skip doctests (saves time!)
    modules = [BernsteinExpansions],
    format = Documenter.HTML(),
    assets = ["assets/juliareach.css"],
    sitename = "BernsteinExpansions.jl",
    pages = [
        "Home" => "index.md",
        "Manual" => Any[
        "Introduction" => "man/introduction.md",
        "Range Enclosure" => "man/range.md",
        "Benchmarks" => "man/benchmarks.md"],
        "Library" => Any[
        "Types" => "lib/types.md",
        "Methods" => "lib/methods.md"],
        "About" => "about.md"
    ]
)

deploydocs(
    repo = "github.com/JuliaReach/BernsteinExpansions.jl.git",
    target = "build",
    deps = nothing,
    make = nothing
)
