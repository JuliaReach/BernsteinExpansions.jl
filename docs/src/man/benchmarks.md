# Benchmarks

```@contents
Pages = ["benchmarks.md"]
Depth = 3
```

## Running the benchmarks

The `benchmark/benchmarks.jl` file defines a benchmark suite that can be evaluated
with the tools provided by `PkgBenchmark` and `BenchmarkTools`.

To run the benchmarks, execute:

```
julia> using PkgBenchmark
julia> results = benchmarkpkg("LazySets")
```

To compare current version to another tagged version, commit or branch:

```
julia> results = judge("LazySets", <tagged-version-or-branch>)
```

To export the benchmark results to a Markdown file:

```
julia> export_markdown("results.md", results)
```

To export the benchmark results to a JSON file:

```
julia> writeresults("results.json", results)
```
