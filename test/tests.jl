using .PRNG, Test

const SEED = 312
const _pwd = pwd()

@testset "Mersenne Twister" begin

    m = PRNG.MT19937.MT()
    PRNG.MT19937.seed(m, SEED)

    @info "Comparing the previous values extracted with the seed " * string(SEED)

    cd("test")
    open("./MT.out") do f
        for value_found in eachline(f)
            @test value_found == string(PRNG.MT19937.extract(m))
        end
    end
    cd(_pwd)

end