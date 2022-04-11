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
    sym_one = [:max,:mean,:quantile_1]
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

    @testset "values, single symbol and/or single function" begin

        @test apply_descriptors(one_dim, maximum) == Dict{Union{Symbol,Function},Number}(
            maximum => maximum(one_dim)
        )

        @test apply_descriptors(one_dim, :max) == Dict{Union{Symbol,Function},Number}(
            :max => maximum(one_dim)
        )

        @test apply_descriptors(one_dim, :quantile_1) ==
        Dict{Union{Symbol,Function},Number}(
            :quantile_1 => quantile(one_dim, 0.25)
        )

        @test apply_descriptors(one_dim, :CO_HistogramAMI_even_2_5) ==
        Dict{Union{Symbol,Function},Number}(
            :CO_HistogramAMI_even_2_5 => CO_HistogramAMI_even_2_5(one_dim)
        )

        @test apply_descriptors(one_dim, :CO_HistogramAMI_even_2_5, mean) ==
        Dict{Union{Symbol,Function},Number}(
            :CO_HistogramAMI_even_2_5 => CO_HistogramAMI_even_2_5(one_dim),
            mean => mean(one_dim)
        )

    end

    @testset "values, symbols test" begin

        @test_logs (:warn,":noSymbol is not a valid symbol for dimension 1")
            apply_descriptors(one_dim,[:no_symbol])

        @test apply_descriptors(one_dim, [:max,:mean,:quantile_1]) ==
        Dict{Union{Symbol,Function},Number}(
            :max => maximum(one_dim),
            :mean => mean(one_dim),
            :quantile_1 => quantile(one_dim, 0.25)
        )

        @test apply_descriptors(two_dim, [:max]) == Dict{Union{Symbol,Function},Number}(
            :max => maximum(two_dim)
        )

    end

    @testset "values, symbol/s, function/s test" begin

        ans_t1d1 = Dict{Union{Symbol,Function},Number}(
            :max => maximum(one_dim),
            :mean => mean(one_dim),
            :quantile_1 => quantile(one_dim, 0.25),
            minimum => minimum(one_dim)
        )

        @test_throws UndefVarError apply_descriptors(
            one_dim,[:max, :mean],[nonexistent_function]
        )

        @test apply_descriptors(one_dim,[:max, :mean, :quantile_1], [minimum]) == ans_t1d1
        @test apply_descriptors(one_dim,[minimum],[:max, :mean, :quantile_1]) == ans_t1d1

        ans_t1d2 = Dict{Union{Symbol,Function},Number}(
            :max => maximum(two_dim),
            minimum => minimum(two_dim),
            mean => mean(two_dim)
        )

        @test apply_descriptors(two_dim, [:max], [minimum, mean]) == ans_t1d2
        @test apply_descriptors(two_dim, [minimum, mean], [:max]) == ans_t1d2

        # one symbol, multiple functions
        @test apply_descriptors(one_dim, :CO_HistogramAMI_even_2_5, [mean, median]) ==
        Dict{Union{Symbol,Function},Number}(
            :CO_HistogramAMI_even_2_5 => CO_HistogramAMI_even_2_5(one_dim),
            mean => mean(one_dim),
            median => median(one_dim)
        )

        # multiple symbols, one function
        @test apply_descriptors(one_dim, [:max :CO_HistogramAMI_even_2_5], mean) ==
        Dict{Union{Symbol,Function},Number}(
            :max => maximum(one_dim),
            :CO_HistogramAMI_even_2_5 => CO_HistogramAMI_even_2_5(one_dim),
            mean => mean(one_dim)
        )

        @test apply_descriptors(one_dim, [:max :max :max :max], [mean mean mean mean]) ==
        Dict{Union{Symbol,Function},Number}(
            :max => maximum(one_dim),
            mean => mean(one_dim)
        )

    end

end
