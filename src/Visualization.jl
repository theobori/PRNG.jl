module Visualization

using Luxor

export draw_graph

function graph(data::Dict, w::Int, h::Int, margin::Int=20)
    @assert w > margin && h > margin

    line_lenght = h - margin
    x = margin
    offset = 5

    translate(margin, -margin)
    for (key, value) in data

        if (x > w - margin)
            break
        end
        
        top = h - (line_lenght * value)
        line(Point(0, h), Point(0, (top + margin > h) ? top : top + margin), :stroke)
        translate(offset, 0)
        x += offset
    end
end

function generate_data(values::Vector, key=[])
    ret = Dict()

    key = (length(key) == 0) ? [i for i in 0:length(values)] : key
    _max, _ = findmax(values)
    for (k, v) in collect(zip(key, values))
        ret[k] = v / _max
    end
    ret
end

function draw_graph(w::Int, h::Int, filename, data::Vector)
    Drawing(w, h, filename)
    background("white")
    sethue("gray20")
    graph(generate_data(data), w, h)
    finish()
end

end # module