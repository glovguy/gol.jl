Pixels = Array{Bool};

mutable struct Checkerboard
    w::Int64
    h::Int64
    size::Int64
    pixels::Pixels
end

neighborindices = filter(x -> Tuple(x) != (0,0), CartesianIndex(-1,-1):CartesianIndex(1,1))

function valid_neighbor(x::CartesianIndex,w,h)
    return x[1] > 1 &&
        x[1] < w-1 &&
        x[2] > 1 &&
        x[2] < h-1
end

function num_neighbors(pixels::Pixels, i::CartesianIndex, w, h)
    total = 0
    allneighbors = [i] .+ copy(neighborindices)
    ni = filter(x -> valid_neighbor(x,w,h), allneighbors)
    for n in ni
        if pixels[n]
            total += 1
        end
    end
    return total
end

function evolve_tick(board::Checkerboard, scene::Scene)
    oldpixels = board.pixels
    newpixels = copy(oldpixels)
    for i in CartesianIndices(oldpixels)
        neigh = num_neighbors(oldpixels, i, board.w, board.h)
        if neigh == 3
            newpixels[i] = true
        end
        if neigh < 2 || neigh > 3
            newpixels[i] = false
        end
    end
    board.pixels = newpixels
end

function draw_item(board::Checkerboard, canvas::Gtk.GtkCanvas, scene::Scene)
    ctx = Gtk.getgc(canvas)

    for i in CartesianIndices(board.pixels)
        x = i[1]
        y = i[2]
        p = board.pixels[i]
        if p
            set_source_rgba(ctx,0,0,0,1)
        else
            set_source_rgba(ctx,1,1,1,0)
        end
        rectangle(ctx, 5+((x-1)*board.size), 15+((y-1)*board.size), board.size, board.size)
        fill(ctx)
    end
end
