module MT19937

"Constants for 32 bit Mersenne Twister"
const W = 32
const N = 624
const M = 397
const R = 31
const A = 0x9908b0df
const U = 11
const D = 0xffffffff
const S = 7
const B = 0x9d2c5680
const T = 15
const C = 0xefc60000
const L = 18
const F = 1812433253

"Bit masks"
const UPPER_MASK = 0x80000000
const LOWER_MASK = 0x7fffffff
const LOWEST_W_BITS = 0xffffffff

mutable struct MT
    arr::Vector{UInt32}
    index::UInt32

    function MT()
        new(zeros(UInt32, N), 1)
    end
end

"Set up an MT object with a seed of type UInt32"
function seed(obj::MT, seed::Int)
    @assert seed >= 0
    obj.index = N
    obj.arr[1] = UInt32(seed)

    for i in 2:N-1
        obj.arr[i] = (F * (obj.arr[i - 1] ⊻ (obj.arr[i - 1] >> (W - 2))) + i) & LOWEST_W_BITS
    end
end

"Generate the next N values"
function twist(obj::MT)
    for i in 1:N
        x::UInt32 = (obj.arr[i] & UPPER_MASK) + (obj.arr[(i + 1) % (N - 1) + 1] & LOWER_MASK)
        xa::UInt32 = x >> 1

        if (x % 2 != 0)
            xa ⊻= A
        end

        obj.arr[i] = obj.arr[(i + M) % (N - 1) + 1] ⊻ xa
    end
    obj.index = 1
end

"Extract a value based on the index"
function extract(obj::MT)
    if (obj.index > N)
        -1
    end

    if (obj.index == N)
        twist(obj)
    end

    y::UInt32 = obj.arr[obj.index]
    y ⊻= (y >> U) & D
    y ⊻= (y >> S) & B
    y ⊻= (y >> T) & C
    y ⊻= (y >> L)
    y &= LOWEST_W_BITS
    
    obj.index += 1

    y
end

export MT, seed, extract

end # MT19937