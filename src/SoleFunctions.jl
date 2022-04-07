module SoleFunctions

using Statistics
using Catch22

# -------------------------------------------------------------
# exports
export apply_descriptors

# function dictionary
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

# default functions by dimension
const dim_desc = Dict{Integer,Vector{Symbol}}(
    # TODO add default functions for other dimensions
    0 => [:mean, :min, :max],
    1 => [:mean, :min, :max, :quantile_1, :median, :quantile_3],
    2 => [:mean, :min, :max, :median]
)

""" 
    apply_descriptors(descriptors, values)

Evaluate `descriptors` with `values`.\n
Return a dictionary containing the associations descriptor -> value

## PARAMETERS
* `descriptors` is a `Vector` containing both Symbols and Functions.
* `values` is a `Vector` of Numbers on which the description functions are applied.

## EXAMPLE
```julia-repl 
julia> desc_syms = [:mean, :min, maximum]
julia> values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
julia> values_description = descriptors(desc_syms, values)
Dict{Symbol, Real}(:max => 10, :mean => 5.5, :min => 1)\n
```

    apply_descriptors(values)
Depending on `values` dimension, apply default functions.

# TODO - show to the user which functions are applied

## PARAMETERS
* `values` is a `Vector` of Numbers on which the description functions are applied.
\n
"""
function apply_descriptors(descriptors::Vector{Any},  values::Array{<:Number})
    # descriptors must contain only Function and Symbol types
    try
        convert(Vector{Union{Function, Symbol}}, descriptors)
    catch e
        @error "Argument descriptors must contain only Function and Symbol types"
    end

    # returned dictionary
    answer = Dict{Union{Symbol, Function}, Real}()

    # all description functions are applied, results are stored in a new "answer" entry
    for desc in descriptors
        if isa(desc, Symbol)
            push!(answer, desc => desc_dict[desc](values))
        else
            push!(answer, desc => desc(values))
        end
    end

    return answer
end

function apply_descriptors(descriptors::Vector{Symbol}, values::Array{<:Number})
    answer = Dict{Symbol, Real}()
    [push!(answer, desc => desc_dict[desc](values)) for desc in descriptors]
    return answer
end

function apply_descriptors(descriptor::Symbol, values::Array{<:Number})
    return apply_descriptors([descriptor], values)
end

function apply_descriptors(values::Number)
    return apply_descriptors(dim_desc[0], [values])
end

function apply_descriptors(values::Array{<:Number})
    dims = ndims(values)
    return apply_descriptors(dim_desc[dims], values)
end

end # module

#da scrivere nella pull request:
#bisogna stare attenti ai tipi in apply descriptors