module SoleFunctions

using Statistics
using Catch22

# -------------------------------------------------------------
# exports
export apply_descriptors

# function dictionary
const 𝒮 = Dict{Symbol,Function}(
    :mean => mean,
    :min => minimum,
    :max => maximum,
    :median => median,
    :quantile_1 => (q_1 = x -> quantile(x, 0.25)),
    :quantile_3 =>(q_3 = x -> quantile(x, 0.75)),
    # catch22 descriptors
    (getnames(catch22) .=> catch22)...
)

# default functions by dimension
const 𝒟 = Dict{Integer,Vector{Symbol}}(
    1 => [:max, :mean, :min, :median, :quantile_1, :quantile_3, getnames(catch22)...],
    2 => [:max, :mean, :median, :min]
)

"""
    apply_descriptors(values, descriptors, functions)

Evaluate `descriptors` and `functions` with `values`.\n
Return a dictionary containing the associations descriptor/function -> value

## PARAMETERS
* `values` is a `Vector{<:Number}`.
* `descriptors` is a `Vector{Symbol}`.
* `functions` is a `Vector{Function}`.
## EXAMPLE
```julia-repl
julia> descriptions = apply_descriptors([1,2,3,4], [:min, :mean], [maximum])
Dict{Union{Function, Symbol}, Number}(:mean => 2.5, maximum => 4, :min => 1)\n\n
```

    apply_descriptors(values, descriptors)

## EXAMPLE
```julia-repl
julia> descriptions = apply_descriptors([1,2,3,4], [:min, :mean])
Dict{Union{Function, Symbol}, Number}(:mean => 2.5, :min => 1)\n\n
```

    apply_descriptors(values)
Evaluate default descriptors with values, based on values dimension.
"""
function apply_descriptors(values::Array{<:Number}, symbols::Array{Symbol})
    output = Dict{Union{Symbol, Function}, Number}()
    d = ndims(values)

    [@warn ":$s is not a valid symbol for dimension $d" for s in symbols if s ∉ 𝒟[d]]
    [push!(output, s => 𝒮[s](values)) for s in symbols if s in 𝒟[d]]

    return output
end

function apply_descriptors(
    values::Array{<:Number},
    symbols::Array{Symbol},
    functions::Array{<:Function}
)
    output = apply_descriptors(values, symbols)
    [push!(output, f => f(values)) for f in functions]
    return output
end

function apply_descriptors(
    values::Array{<:Number},
    functions::Array{<:Function},
    symbols::Array{Symbol}
)
    return apply_descriptors(values, symbols, functions)
end

function apply_descriptors(values::Array{<:Number})
    # default descriptors are chosen based on `values` dimension
    return apply_descriptors(values, 𝒟[ndims(values)])
end

end # module
