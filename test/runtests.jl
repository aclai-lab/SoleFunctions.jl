using SoleFunctions
using Statistics
using random
using Catch22
using Test

rng = MersenneTwister(123)

@testset "SoleFunctions.jl" begin

    one_dim = rand(10,1)
    sym_one = [:max,:mean]
    func_one = [minimum]

    two_dim = rand(10,2)
    sym_two = [:max,:quantile_1]
    func_two = [minimum,mean]

    @testset "values symbol & function test" begin

        ans_t1d1 = Dict{Union{Symbol,Function},Number}(:max => maximum(one_dim), 
                                                        :mean => mean(one_dim), 
                                                        minimum => minimum(one_dim))

        @test apply_descriptors(one_dim,sym_one,func_one) == ans_t1d1
        @test apply_descriptors(one_dim,func_one,sym_one) == ans_t1d1


        ans_t1d2 = Dict{Union{Symbol,Function},Number}(:max => maximum(two_dim), 
                                                    :quantile_1 => quantile(one_dim,0.25), 
                                                    minimum => minimum(one_dim),
                                                    mean => mean(two_dim))

        @test apply_descriptors(two_dim,sym_two,funct_two) == ans_t1d2
        @test apply_descriptors(two_dim,func_two,sym_two) == ans_t1d2

    @testset "values only test" begin
        
        ans_t2d1 = Dict{Union{Symbol,Function},Number}(:max => maximum(one_dim), 
                                                        :mean => mean(one_dim), 
                                                        :min => minimum(one_dim),
                                                        :quantile_1 => quantile(one_dim,0.25),
                                                        :median => median(one_dim),
                                                        :quantile_3 => quantile(one_dim,0.75))

        ans_t2d2 = Dict{Union{Symbol,Function},Number}(:max => maximum(two_dim), 
                                                        :mean => mean(two_dim), 
                                                        :min => minimum(two_dim),
                                                        :median => median(two_dim))

        @test apply_descriptors(one_dim) == and_t2d1
        @test apply_descriptors(two_dim) ==ans_t2d2

    end

    @testset "values and symbols test" begin

        ans_t3d1 = Dict{Union{Symbol,Function},Number}(:max => maximum(two_dim), 
                                                        :mean => mean(two_dim),)

        ans_t3d2 = Dict{Union{Symbol,Function},Number}(:max => maximum(two_dim), 
                                                        :quantile_1 => quantile(two_dim,0.25),)
        
        @test apply_descriptors(one_dim,sym_one) == ans_t3d1
        @test apply_descriptors(two_dim,sym_two) == and_t3d2

    end

end