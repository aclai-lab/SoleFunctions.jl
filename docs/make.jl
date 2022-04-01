using SoleFunctions
using Documenter

DocMeta.setdocmeta!(SoleFunctions, :DocTestSetup, :(using SoleFunctions); recursive=true)

makedocs(;
    modules=[SoleFunctions],
    authors="Eduard I. STAN, Giovanni PAGLIARINI",
    repo="https://github.com/aclai-lab/SoleFunctions.jl/blob/{commit}{path}#{line}",
    sitename="SoleFunctions.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://aclai-lab.github.io/SoleFunctions.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/aclai-lab/SoleFunctions.jl",
)
