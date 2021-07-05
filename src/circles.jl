struct Circles
    n::Int64
end
Circles() = Circles(10)

function draw_item(circles::Circles, canvas::Gtk.GtkCanvas, scene::Scene)
    ctx = Gtk.getgc(canvas)
    h = height(canvas)
    w = width(canvas)

    ti = scene.tNow
    for k=1:circles.n
        x = (cos(ti*3) * ((w/2.0)-30.0)) + (w/2.0) +5.0
        y = (sin(ti*4) * ((h/2.0)-40.0)) + (h/2.0) +15.0

        new_path(ctx)
        set_line_width(ctx, 10.0);
        set_source_rgb(ctx, 0.5, mod(ti,1.0), 0.7)
        arc(ctx, x, y, 20.0, 0.0, 6.28);
        stroke(ctx);
        ti = ti + 0.05
    end
    return nothing
end
