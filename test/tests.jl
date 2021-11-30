using .PRNG, .Visualization, Test

# For noise()
using Luxor

const SEED = 312
const GC = 100
const _pwd = pwd()

cd("./test/")
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

    @info "[Mersenne Twister] Generating $GC graphs for the seeds 1 -> $GC"

    ext = ".png"

    for i in 1:GC
        m = PRNG.MT19937.MT()
        PRNG.MT19937.seed(m, i)
        data = [PRNG.MT19937.extract(m) for _ in 1:300]
        draw_graph(800, 200, data, filename="img/MT19937_" * string(i) * ext)
    end

    @info "[Noise] Generating a graph with noise values"

    data = [noise(i) for i in range(1, 20, length=1000)]
    draw_graph(2000, 300, data, filename="img/noise" * ext)


    @info "[Noise 2] Generating a graph with noise values"

    data = [noise(i) for i in range(0, 6, length=300)]
    Drawing(800, 200, "img/noise2" * ext)
    background("black")
    sethue("white")
    graph(data, style=:inverse)
    finish()

end