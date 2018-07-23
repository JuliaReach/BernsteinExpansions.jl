using Documenter, BernsteinExpansions

makedocs(
    doctest = true,  # use this flag to skip doctests (saves time!)
    modules = [BernsteinExpansions],
    format = :html,
    assets = ["assets/juliareach.css"],
    sitename = "BernsteinExpansions.jl",
    pages = [
        "Home" => "index.md",
        "Manual" => Any[
        "Bernstein expansion" => "man/bernstein_expansion.md",
        "Benchmarks" => "man/benchmarks.md"],
        "Library" => Any[
        "Implicit Bernstein form" => "lib/implicit_bernstein_form.md",
        "Tensorial Bernstein form" => "lib/tensorial_bernstein_form.md"],
        "About" => "about.md"
    ]
)

deploydocs(
    repo = "github.com/JuliaReach/BernsteinExpansions.jl.git",
    target = "build",
    osname = "linux",
    julia  = "0.6",
    deps = nothing,
    make = nothing
)
