using Gtk
using Graphics
using Cairo

include("scene.jl")

function new_canvas()
    Gtk.@GtkCanvas(400,400)
end

function new_app_window(canvas::Gtk.GtkCanvas)
    Gtk.GtkWindow(canvas, "Game of Life")
end

function update(canvas::Gtk.GtkCanvas, scene::Scene)
    draw(canvas)
end

function draw_scene(canvas::Gtk.GtkCanvas, scene::Scene)
    show(canvas)
    evolve_tick(scene)
    for dble in scene.contents
        draw_item(dble, canvas, scene)
    end
end
