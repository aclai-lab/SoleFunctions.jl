using SoleFunctions
using Statistics
using Random
using Test

rng = MersenneTwister(123)

@testset "SoleFunctions.jl" begin

    # adimensional test input and expected output
    t0 = 42
    desc0 = Dict{Symbol, Real}(:mean => t0, :min => t0, :max => t0)

    # one dimensional test input and expected output
    t1 = randn(rng, 100)
    desc1 = Dict{Symbol, Real}(:min => minimum(t1), :max => maximum(t1), :mean => mean(t1), :median => median(t1), :quantile_1 => quantile(t1, 0.25), :quantile_3 => quantile(t1, 0.75))

    # two dimensional test input and expected output
    t2 = randn(rng, 100, 2)
    desc2 = Dict{Symbol, Real}(:min => minimum(t2), :max => maximum(t2), :mean => mean(t2), :median => median(t2))

    # general test (both Symbols and Functions)
    @test_throws MethodError apply_descriptors( ["minimum", minimum, :min], [1,2,3])

    @test apply_descriptors([:mean, minimum, maximum, :quantile_1], t1) == Dict{Union{Function, Symbol}, Real}(:mean => mean(t1), minimum => minimum(t1), maximum => maximum(t1), :quantile_1 => quantile(t1, 0.25))
    @test apply_descriptors([:mean], t2) == Dict{Symbol, Real}(:mean => mean(t2))
    # single Symbol test

    # single Function test

    # default test
    @test apply_descriptors(t0) == desc0
    @test apply_descriptors(t1) == desc1
    @test apply_descriptors(t2) == desc2


end
