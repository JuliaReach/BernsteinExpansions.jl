# About

This page contains some general information about this project, and recommendations
about contributing.

```@contents
Pages = ["about.md"]
```

## Contributing

If you like this package, consider contributing! You can send bug reports (or fix them
and send your code), add examples to the documentation or propose new features.

Below some conventions that we follow when contributing
to this package are detailed. For specific guidelines on documentation, see the [Documentations Guidelines wiki](https://github.com/JuliaReach/LazySets.jl/wiki/Documentation-Guidelines).

### Branches

Each pull request (PR) should be pushed in a new branch with the name of the author
followed by a descriptive name, e.g. `t/mforets/my_feature`. If the branch is
associated to a previous discussion in one issue, we use the name of the issue for easier
lookup, e.g. `t/mforets/7`.

### Unit testing and continuous integration (CI)

This project is synchronized with GitHub Actions such that each PR gets tested
before merging (and the build is automatically triggered after each new commit).
For the maintainability of this project, it is important to make all unit tests
pass.

To run the unit tests locally, you can do:

```julia
julia> using Pkg

julia> Pkg.test("BernsteinExpansions")
```

We also advise adding new unit tests when adding new features to ensure
long-term support of your contributions.

### Contributing to the documentation

This documentation is written in Markdown, and it relies on
[Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) to produce the HTML
layout. To build the docs, run `make.jl`:

```bash
$ julia --color=yes docs/make.jl
```

## Running the benchmarks

This package contains a suite of benchmarks that is handled through
[PkgBenchmark](https://github.com/JuliaCI/PkgBenchmark.jl). To run the benchmarks,
execute the following commands in Julia's REPL:

```julia
julia> using BernsteinExpansions, PkgBenchmark
julia> benchmarkpkg("BernsteinExpansions")
```

To save the results to a custom directory, use:

```julia
julia> benchmarkpkg("BernsteinExpansions", resultsdir="/Users/forets/Projects")
```

For further options see the inline help of `benchmarkpkg`.

## Credits

These persons have contributed to `BernsteinExpansions.jl` (in alphabetic order):

- [Marcelo Forets](http://main.marcelo-forets.fr)
- [Alexandre Rocca](http://www-verimag.imag.fr/~rocca/)
