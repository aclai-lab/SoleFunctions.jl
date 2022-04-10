using SoleFunctions
using Random
using Test

rng = MersenneTwister(123)

@testset "SoleFunctions.jl" begin

    using Statistics
    using Catch22

    # input in one-dimensional case
    one_dim = rand(Float64,100)
    # symbol and function arrays used in the test
    sym_one = [:max,:mean]
    func_one = [minimum]

    two_dim = rand(Float64,100,2)
    sym_two = [:max]
    func_two = [minimum,mean]

    # all functions are tested for a certain dimension
    @testset "values only test" begin

        ans_t2d1 = Dict{Union{Symbol,Function},Number}(
            :max => maximum(one_dim),
            :mean => mean(one_dim),
            :min => minimum(one_dim),
            :quantile_1 => quantile(one_dim,0.25),
            :median => median(one_dim),
            :quantile_3 => quantile(one_dim,0.75),
            (getnames(catch22) .=> catch22(one_dim))...
        )

        ans_t2d2 = Dict{Union{Symbol,Function},Number}(
            :max => maximum(two_dim),
            :mean => mean(two_dim),
            :min => minimum(two_dim),
            :median => median(two_dim)
        )

        @test apply_descriptors(one_dim) == ans_t2d1
        @test apply_descriptors(two_dim) == ans_t2d2

    end

    @testset "values, symbols, functions test" begin

        ans_t1d1 = Dict{Union{Symbol,Function},Number}(
            :max => maximum(one_dim),
            :mean => mean(one_dim),
            minimum => minimum(one_dim)
        )

        @test_throws UndefVarError apply_descriptors(one_dim,sym_one,[nonexistent_function])
        @test apply_descriptors(one_dim,sym_one,func_one) == ans_t1d1
        @test apply_descriptors(one_dim,func_one,sym_one) == ans_t1d1

        ans_t1d2 = Dict{Union{Symbol,Function},Number}(
            :max => maximum(two_dim),
            minimum => minimum(two_dim),
            mean => mean(two_dim)
        )

        @test apply_descriptors(two_dim,sym_two,func_two) == ans_t1d2
        @test apply_descriptors(two_dim,func_two,sym_two) == ans_t1d2

    end

    @testset "values, symbols test" begin

        ans_t3d1 = Dict{Union{Symbol,Function},Number}(
            :max => maximum(one_dim),
            :mean => mean(one_dim)
        )

        ans_t3d2 = Dict{Union{Symbol,Function},Number}(
            :max => maximum(two_dim)
        )

        @test_logs (:warn,":noSymbol is not a valid symbol for dimension 1")
            apply_descriptors(one_dim,[:noSymbol])

        @test apply_descriptors(one_dim,sym_one) == ans_t3d1
        @test apply_descriptors(two_dim,sym_two) == ans_t3d2

    end

end
