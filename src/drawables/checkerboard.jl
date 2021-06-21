Pixels = Array{Bool};
mutable struct Checkerboard
    w::Int64
    h::Int64
    pixelsize::Int64
    nowisalpha::Bool
    pixelsalpha::Pixels
    pixelsbeta::Pixels
end
Checkerboard(width, height) = begin
    offsetx = 5
    offsety = 15
    pixelsize = 10
    boardx = (width-offsetx) ÷ pixelsize
    boardy = (height-offsety) ÷ pixelsize
    pxl = rand(Bool, (boardx, boardy))
    Checkerboard(
        boardx,
        boardy,
        pixelsize,
        true,
        pxl,
        copy(pxl)
    )
end

pixels(board::Checkerboard) = board.nowisalpha ? board.pixelsalpha : board.pixelsbeta
oldpixels(board::Checkerboard) = board.nowisalpha ? board.pixelsbeta : board.pixelsalpha

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
    board.nowisalpha = !board.nowisalpha
    newpixels = pixels(board)
    oldp = oldpixels(board)
    for i in CartesianIndices(oldp)
        neigh = num_neighbors(oldp, i, board.w, board.h)
        if neigh == 3
            newpixels[i] = true
        elseif neigh < 2 || neigh > 3
            newpixels[i] = false
        else
            newpixels[i] = oldp[i]
        end
    end
end

function draw_item(board::Checkerboard, canvas::Gtk.GtkCanvas, scene::Scene)
    ctx = Gtk.getgc(canvas)
    pixs = pixels(board)
    for i in CartesianIndices(pixs)
        x = i[1]
        y = i[2]
        p = pixs[i]
        if p
            set_source_rgba(ctx,0,0,0,1)
        else
            set_source_rgba(ctx,1,1,1,0)
        end
        pixelsize = board.pixelsize
        rectangle(ctx, 5+((x-1)*pixelsize), 15+((y-1)*pixelsize), pixelsize, pixelsize)
        fill(ctx)
    end
end
