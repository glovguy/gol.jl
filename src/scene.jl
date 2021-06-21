mutable struct Scene
    tNow::Float64
    dt::Float64
    lastTimeCalled::Float64
    paused::Bool
    contents::Array
end
Scene(dt, contents::Array) = Scene(0,dt,time(),false,contents)
Scene(contents::Array) = Scene(0.05, contents)

function evolve_tick(scene::Scene)
    scene.tNow += scene.dt
    for c in scene.contents
        evolve_tick(c, scene)
    end
end

function evolve_tick(Any, scene::Scene); end; # no op
