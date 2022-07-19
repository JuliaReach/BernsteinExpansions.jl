using Documenter, BernsteinExpansions

DocMeta.setdocmeta!(BernsteinExpansions, :DocTestSetup,
                   :(using BernsteinExpansions); recursive=true)

makedocs(
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        assets = ["assets/aligned.css"]),
    sitename = "BernsteinExpansions.jl",
    doctest = true,
    strict = true,
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
    push_preview = true
)
