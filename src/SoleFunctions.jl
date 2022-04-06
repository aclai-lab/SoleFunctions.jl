module SoleFunctions

using Statistics
using Catch22

# -------------------------------------------------------------
# exports
export get_desc

# taken from https://github.com/aclai-lab/SoleBase.jl/blob/dev/src/data/dataset/describe.jl
const desc_dict = Dict{Symbol,Function}(
    :mean => mean,
    :min => minimum,
    :max => maximum,
    :median => median,
    :quantile_1 => (q_1 = x -> quantile(x, 0.25)),
    :quantile_3 =>(q_3 = x -> quantile(x, 0.75)),
    # allow catch22 desc
    (getnames(catch22) .=> catch22)...
)

const auto_desc_by_dim = Dict{Integer,Vector{Symbol}}(
    1 => [:mean, :min, :max, :quantile_1, :median, :quantile_3]
)

""" 
    get_desc(descfun, values)

Apply functions represented by `descfun` to `values`.\n
Return a dictionary containing the associations :symbol -> value (e.g :mean -> 3.5)

## PARAMETERS
* `descfun` is a `Vector` of Symbols which are mapped to specific functions.
* `values` is a `Vector` of Numbers on which the description functions are applied.

## EXAMPLE
```julia-repl 
julia> desc_syms = [:mean, :min, :max]
julia> values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
julia> values_description = get_desc(desc_syms, values)
Dict{Symbol, Real}(:max => 10, :mean => 5.5, :min => 1)
```
"""
function get_desc(descfun::Vector{Symbol}, values::Vector{<:Number})
    # a symbol is valid only if it is defined in desc_dict
    for df in descfun
        @assert df in keys(desc_dict) "`$(df)` is not a valid descriptor"
    end

    ans_dict = Dict{Symbol, Real}()
    apply(f, x) = f(x)
    [push!(ans_dict, df => apply(desc_dict[df], values)) for df in descfun]

    return ans_dict
end

end # module