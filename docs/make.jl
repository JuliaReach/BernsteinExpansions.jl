using Documenter, BernsteinExpansions, DocumenterCitations

DocMeta.setdocmeta!(BernsteinExpansions, :DocTestSetup,
                    :(using BernsteinExpansions); recursive=true)

bib = CitationBibliography(joinpath(@__DIR__, "src", "refs.bib"); style=:alpha)

makedocs(;
         sitename="BernsteinExpansions.jl",
         format=Documenter.HTML(; prettyurls=get(ENV, "CI", nothing) == "true",
                                assets=["assets/aligned.css", "assets/citations.css"]),
         pagesonly=true,
         plugins=[bib],
         pages=["Home" => "index.md",
                "Manual" => Any["Introduction" => "man/introduction.md",
                                "Range Enclosure" => "man/range.md",
                                "Benchmarks" => "man/benchmarks.md"],
                "Library" => Any["Types" => "lib/types.md",
                                 "Methods" => "lib/methods.md"],
                "Bibliography" => "bibliography.md",
                "About" => "about.md"])

deploydocs(; repo="github.com/JuliaReach/BernsteinExpansions.jl.git",
           push_preview=true)
