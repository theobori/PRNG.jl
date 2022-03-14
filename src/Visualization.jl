module Visualization

using Luxor

export graph, draw_graph

macro abs(n)
    return :($n > 0 ? $n : -$n)
end

function center(h, length, top, margin)
    bottom = (h - length) / 2
    (bottom + length + margin, bottom)
end

const styles = Dict(
    :default => (h, length, top, margin) -> (h, top),
    :center => center,
    :inverse => (h, length, top, margin) -> 
    ((top + margin > h) ? top : top + margin, margin)
)

function graph(data::Vector;
    w = 800,
    h = 200,
    margin = 0.1,
    offset = 3,
    style = :default
    )
    @assert margin >= 0 && margin < 0.35
    @assert w > 100 && h > 100
    @assert offset >= 0 && offset <= 10
    @assert any([style == s for (s, _) in styles])

    margin *= h
    line_lenght = h - margin

    # Apply the margin
    translate(margin, -margin)
    x = margin

    for value in data

        if (x > w - margin)
            return
        end

        # Compute the 2 points to draw the line
        top = h - (line_lenght * value)
        bottom, top = styles[style](h, line_lenght * value, top, margin)
        top = (top + margin > h) ? top : top + margin

        # Draw the line
        line(Point(0, bottom), Point(0, top), :stroke)

        # Moving the workspace to the right
        translate(offset, 0)
        x += offset
    end
end

function format_data(values::Vector)
    _max, _ = findmax(values)
    map(((x) -> (_max > 1) ? (x / _max) : x), values)
end

function draw_graph(w::Int, h::Int, data::Vector;
    filename = "img/tmp.png",
    gw = w,
    gh = h
    )
    @assert gw <= w && gh <= h

    Drawing(w, h, filename)
    background("white")
    sethue("gray20")
    graph(format_data(data), w=gw, h=gh, style=:center)
    finish()
end

end # module