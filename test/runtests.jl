using SoleFunctions
using Statistics
using Test

@testset "SoleFunctions.jl" begin
    test1 = [5,3,7,9,10,921.231,1,32,1323,12.3,12.2,212]
    
    min = minimum(test1)
    max = maximum(test1)
    media = mean(test1)
    mediana = median(test1)
    q_1 = quantile(test1, 0.25)
    q_3 = quantile(test1, 0.75)

    desc1 = Dict{Symbol, Real}(:mean => media, :min => min, :max => max, :median => mediana, :quantile_1 => q_1, :quantile_3 => q_3)
    
    # general test (both Symbols and Functions)
    @test_throws MethodError apply_descriptors( ["minimum", minimum, :min], [1,2,3])

    # single Symbol test

    # single Function test
    @test 

    # default test
    @test apply_descriptors(test1) == desc1

    #@test apply_descriptors(test1) == desc1


end
