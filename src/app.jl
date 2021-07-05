module App

using Printf
include("canvas.jl")
include("checkerboard.jl")
include("timetext.jl")
include("circles.jl")

function init_timer(canvas::Gtk.GtkCanvas, scene::Scene, interval)
    update_timer = Timer((timer) -> update(canvas, scene), 0.0, interval=interval)
    return update_timer
end
secondsperframe = 0.03 # 30 fps
init_timer(canvas, scene) = init_timer(canvas, scene, secondsperframe)

function hold_thread(window)
    cond = Condition()
    signal_connect(window, :destroy) do widget
        notify(cond)
    end
    wait(cond)
    return nothing
end

#     signal_connect(win, "check-resize") do win
#         println("resized")
#     end

function start()
    dims = (2400,1100)

    canvas = new_canvas(dims...)
    win = new_app_window(canvas)
    show(canvas)

    board = Checkerboard(dims...)
    contents = [TimeText(),board]
    scene = Scene(contents)
    init_timer(canvas, scene)
    draw(canvas -> draw_scene(canvas, scene), canvas)

    !isinteractive() && hold_thread(win)

    return (canvas,scene)
end

end # module

App.start()
