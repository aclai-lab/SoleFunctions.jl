module SoleFunctions

using Statistics
using Catch22

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

end
