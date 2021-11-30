module Visualization

using Luxor

export draw_graph

function graph(data::Vector, w::Int, h::Int)
    margin = 0.1 * h
    @assert w > margin && h > margin

    line_lenght = h - margin
    x = margin
    offset = 3

    translate(margin, -margin)
    for value in data

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
    values = map(((x) -> (_max > 1) ? (x / _max) : x), values)
    values
end

function draw_graph(w::Int, h::Int, filename, data::Vector)
    Drawing(w, h, filename)
    background("white")
    sethue("gray20")
    data = generate_data(data)
    graph(data, w, h)
    finish()
end

end # module