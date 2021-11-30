using .PRNG, .Visualization, Test

const SEED = 312
const GC = 100
const _pwd = pwd()

cd("test")
@testset "Mersenne Twister" begin

    m = PRNG.MT19937.MT()
    PRNG.MT19937.seed(m, SEED)

    @info "Comparing the previous values extracted with the seed " * string(SEED)

    open("./MT.out") do f
        for value_found in eachline(f)
            @test value_found == string(PRNG.MT19937.extract(m))
        end
    end
    
end
cd(_pwd)

@testset "Data visualization" begin

    @info "Generating $GC graphs for the seeds 1 -> $GC"

    ext = ".png"

    for i in 1:GC
        m = PRNG.MT19937.MT()
        PRNG.MT19937.seed(m, i)
        store = [PRNG.MT19937.extract(m) for _ in 1:250]
        draw_graph(800, 200, "img/MT19937_" * string(i) * ext, store)
    end
end