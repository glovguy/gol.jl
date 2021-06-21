module App

using Printf
include("canvas.jl")
# Maybe there should be a drawable abstract type?
include("drawables/checkerboard.jl")
include("drawables/timetext.jl")
include("drawables/circles.jl")

function init_timer(canvas::Gtk.GtkCanvas, scene::Scene, interval)
    update_timer = Timer((timer) -> update(canvas, scene), 0.0, interval=interval)
    return update_timer
end
init_timer(canvas, scene) = init_timer(canvas, scene, 0.05)

function hold_thread(window)
    cond = Condition()
    signal_connect(window, :destroy) do widget
        notify(cond)
    end
    wait(cond)
end

#     signal_connect(win, "check-resize") do win
#         println("resized")
#     end

function start()
    canvas = new_canvas()
    show(canvas)

    boardx = 20
    boardy = 25
    board = Checkerboard(
        boardx,
        boardy,
        floor(min((400-5)/boardx,(400-15)/boardy)),
        rand(Bool, (boardx, boardy))
    )

    win = new_app_window(canvas)
    signal_connect(win, :destroy) do widget
        println("Window was closed")
    end

    contents = [TimeText(),Circles(10),board]
    scene = Scene(contents)
    init_timer(canvas, scene)
    draw(canvas -> draw_scene(canvas, scene), canvas)

    !isinteractive() && hold_thread(win)

    return (canvas,scene)
end

end # module

App.start()
