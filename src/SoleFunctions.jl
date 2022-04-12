module SoleFunctions

# TODO: add tests for the newly defined (dispatched) functions
# Eduard 11 Apr 2022

using Statistics
using Catch22

# -------------------------------------------------------------
# exports
export apply_descriptors

# function dictionary
const 𝒮 = Dict{Symbol,Function}(
    :mean       => mean,
    :minimum    => minimum,
    :maximum    => maximum,
    :median     => median,
    :quantile_1 => (x -> quantile(x, 0.25)),
    :quantile_3 => (x -> quantile(x, 0.75)),
    # catch22 descriptors
    (getnames(catch22) .=> catch22)...
)

# default functions by dimension
const 𝒟 = Dict{Integer,Vector{Symbol}}(
    1 => [:maximum, :mean, :minimum, :median, :quantile_1, :quantile_3, getnames(catch22)...],
    2 => [:maximum, :mean, :median, :minimum]
)

"""
    apply_descriptors(values, symbols)

Return a dictionary obtained by the evaluation of `symbols` corresponding functions
on `values`.

Tthe possible `symbols` are choosen from a dictionary defined as follows:

    :mean           =>  mean
    :minimum        =>  minimum
    :maximum        =>  maximum
    :median         =>  median
    :quantile_1     =>  quantile(x, 0.25)
    :quantile_3     =>  quantile(x, 0.75)
    ...

Catch22 functions are also implemented, see the documentation here:
"https://github.com/chlubba/catch22/wiki/Feature-Descriptions"

## PARAMETERS
- `values` is a `Vector{<:Number}`.
- `symbols` is a `Vector{Symbol}`.

## EXAMPLE
```julia-repl
julia> descriptions = apply_descriptors([1,2,3,4], [:minimum, :mean])
Dict{Union{Function, Symbol}, Number}(:mean => 2.5, :minimum => 1)\n
```
"""
# TODO: A single documentation for all these functions
# Eduard 12 Apr 2022
function apply_descriptors end

function apply_descriptors(values::Array{<:Number}, symbols::Array{Symbol})
    output = Dict{Union{Symbol, Function}, Number}()
    d = ndims(values)

    [@warn ":$s is not a valid symbol for dimension $d" for s in symbols if s ∉ 𝒟[d]]
    [push!(output, s => 𝒮[s](values)) for s in symbols if s in 𝒟[d]]

    return output
end

"""
    apply_descriptors(values,symbol)

evaluates `symbol` corresponding function on `values`

## PARAMETERS
- `values` is a `Vector{<:Number}`.
- `symbols` is a `Symbol`.

## EXAMPLE
```julia-repl
julia> descriptions = apply_descriptors([1,2,3,4], [:minimum])
Dict{Union{Function, Symbol}, Number}(:minimum => 1)
```
"""
function apply_descriptors(values::Array{<:Number}, symbol::Symbol)
    return apply_descriptors(values, [symbol])
end

"""
    apply_descriptors(values,functions)

evaluates `functions` on `values`

## PARAMETERS
- `values` is a `Vector{<:Number}`.
- `functions` is a `Array{<:Function}`.

## EXAMPLE
```julia-repl
julia> descriptions = apply_descriptors([1,2,3,4], [minimum,maximum])
Dict{Union{Function, Symbol}, Number}(minimum => 1,maximum => 4)
```
"""
function apply_descriptors(values::Array{<:Number}, functions::Array{<:Function})
    output = Dict{Union{Symbol, Function}, Number}()

    [push!(output, f => f(values)) for f in functions]
    return output
end

"""
    apply_descriptors(values,function)

evaluates `function` on `values`

## PARAMETERS
- `values` is a `Vector{<:Number}`.
- `functions` is a `Function`.

## EXAMPLE
```julia-repl
julia> descriptions = apply_descriptors([1,2,3,4], [maximum])
Dict{Union{Function, Symbol}, Number}(maximum => 4)
```
"""
function apply_descriptors(values::Array{<:Number}, f::Function)
    return apply_descriptors(values, [f])
end

"""
    apply_descriptors(values, symbols, functions)

Evaluate `symbols` and `functions` on `values`.\n
Return a dictionary containing the associations symbols/function -> value

## PARAMETERS
- `values` is a `Vector{<:Number}`
- `symbols` is a `Vector{Symbol}`.
- `functions` is a `Vector{Function}`.

## EXAMPLE
```julia-repl
julia> descriptions = apply_descriptors([1,2,3,4],[maximum],[:minimum, :mean])
Dict{Union{Function, Symbol}, Number}(maximum => 4,:mean => 2.5, :minimum => 1)
```
"""
function apply_descriptors(
    values::Array{<:Number},
    symbols::Array{Symbol},
    functions::Array{<:Function}
)
    output = apply_descriptors(values, symbols)
    [push!(output, f => f(values)) for f in functions]
    return output
end

"""
    apply_descriptors(values, functions, symbols)
Evaluate `symbols` and `functions` on `values`.\n
Return a dictionary containing the associations symbols/function -> value

## PARAMETERS
- `values` is a `Vector{<:Number}`.
- `symbols` is a `Vector{Symbol}`.
- `functions` is a `Vector{Function}`.

## EXAMPLE
```julia-repl
julia> descriptions = apply_descriptors([1,2,3,4], [:minimum, :mean], [maximum])
Dict{Union{Function, Symbol}, Number}(maximum => 4, :mean => 2.5, :minimum => 1)
```
"""
function apply_descriptors(
    values::Array{<:Number},
    functions::Array{<:Function},
    symbols::Array{Symbol}
)
    return apply_descriptors(values, symbols, functions)
end

"""
    apply_descriptors(values)

Return a dictionary containing the evaluation of default functions on `values`

default functions are choosen according to the dimensions of the data as
follows:

    1 => [:maximum, :mean, :minimum, :median, :quantile_1, :quantile_3, getnames(catch22)...]
    2 => [:maximum, :mean, :median, :minimum]
    ...
## PARAMETERS
- `values` is a `Vector{<:Number}`.

## EXAMPLE
```julia-repl
julia> descriptions = apply_descriptors([1,2,3,4])
Dict{Union{Function, Symbol}, Number}(:maximum => 4, :mean => 2.5, :minimum => 1,
:median => 2.5, :quantile_1 => 1.75, :quantile_3 => 3.25, ...)\n
```
"""
function apply_descriptors(values::Array{<:Number})
    # default descriptors are chosen based on `values` dimension
    return apply_descriptors(values, 𝒟[ndims(values)])
end

"""
    apply_descriptors(values, symbols, function)

Evaluate `symbol` and `function` on `values`.\n
Return a dictionary containing the associations symbol/function -> value

## PARAMETERS
    * `values` is a `Vector{<:Number}`.
    * `symbols` is a `Symbols`.
    * `functions` is a `Function`. #TODO

## EXAMPLE
```julia-repl
julia> descriptions = apply_descriptors([1,2,3,4],[:minimum,:mean],[maximum])
Dict{Union{Function, Symbol}, Number}(maximum => 4,:mean => 2.5, :minimum => 1)
```
"""
function apply_descriptors(
    values::Array{<:Number},
    symbols::Array{Symbol},
    fun::Function
)
    return apply_descriptors(values, symbols, [fun])
end

"""
    apply_descriptors(values, symbol, functions)

Evaluate `symbol` and `functions` on `values`.\n
Return a dictionary containing the associations symbol/function -> value

## PARAMETERS
- `values` is a `Vector{<:Number}`.
- `symbols` is a `Symbol`.
- `functions` is a `Vector{<:Function}`.

## EXAMPLE
```julia-repl
julia> descriptions = apply_descriptors([1,2,3,4],[maximum],[:minimum])
Dict{Union{Function, Symbol}, Number}(maximum => 4, :minimum => 1)
```
"""
function apply_descriptors(
    values::Array{<:Number},
    symbol::Symbol,
    functions::Array{<:Function}
)
    return apply_descriptors(values, [symbol], functions)
end

"""
    apply_descriptors(values, symbol, function)

Evaluate `symbol` and `function` on `values`.\n
Return a dictionary containing the associations symbol/function -> value

## PARAMETERS
- `values` is a `Vector{<:Number}`.
- `symbols` is a `Symbol`.
- `functions` is a `Function`.

## EXAMPLE
```julia-repl
julia> descriptions = apply_descriptors([1,2,3,4],[:minimum],[maximum])
Dict{Union{Function, Symbol}, Number}(maximum => 4, :minimum => 1)
```
"""
function apply_descriptors(
    values::Array{<:Number},
    symbol::Symbol,
    fun::Function
)
    return apply_descriptors(values, [symbol], [fun])
end

end # module
