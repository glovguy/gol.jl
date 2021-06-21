module App

using Printf
include("canvas.jl")
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
    canvas = new_canvas(1200,600)
    win = new_app_window(canvas)
    show(canvas)

    board = Checkerboard(1200,600)

    contents = [TimeText(),board]
    scene = Scene(contents)
    init_timer(canvas, scene)
    draw(canvas -> draw_scene(canvas, scene), canvas)

    !isinteractive() && hold_thread(win)

    return (canvas,scene)
end

end # module

App.start()
