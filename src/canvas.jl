using Gtk
using Graphics
using Cairo

include("scene.jl")

function new_canvas(sizex, sizey)
    return Gtk.@GtkCanvas(sizex, sizey)
end
new_canvas() = new_canvas(400,400)

function new_app_window(canvas::Gtk.GtkCanvas)
    win = Gtk.GtkWindow(canvas, "Game of Life")
    signal_connect(win, :destroy) do widget
        println("Window was closed")
    end
    return win
end

update(canvas::Gtk.GtkCanvas, ::Any) = draw(canvas)

function draw_scene(canvas::Gtk.GtkCanvas, scene::Scene)
    show(canvas)
    evolve_tick(scene)
    for dble in scene.contents
        draw_item(dble, canvas, scene)
    end
    return nothing
end
