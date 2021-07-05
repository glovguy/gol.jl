using Printf

mutable struct TimeText; end

function draw_item(timetext::TimeText, canvas::Gtk.GtkCanvas, scene::Scene)
    ctx = Gtk.getgc(canvas)
    h = height(canvas)
    w = width(canvas)

    set_source_rgb(ctx, 1, 1, 1)
    rectangle(ctx, 0, 0, w, h)
    fill(ctx)

    set_source_rgb(ctx, 0.5, 0.0, 0.7)
    timesincelastframe = time()-scene.lastTimeCalled
    txt = @sprintf("%07.3fs since last frame", timesincelastframe)
    text(ctx,0,18,txt)
    scene.lastTimeCalled = time()
    return nothing
end
