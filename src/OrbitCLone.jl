module OrbitCLone

using SimpleDirectMediaLayer

const SDL = SimpleDirectMediaLayer

function createWindow()
    win = SDL.CreateWindow("OrbitCLone", Int32(SDL.WINDOWPOS_CENTERED()), Int32(SDL.WINDOWPOS_CENTERED()), Int32(800), Int32(600), UInt32(SDL.WINDOW_SHOWN))
    renderer = SDL.CreateRenderer(win, Int32(-1), UInt32(SDL.RENDERER_ACCELERATED | SDL.RENDERER_PRESENTVSYNC))
    return win, renderer
end

function quit(win, renderer)
    SDL.DestroyRenderer(renderer)
    SDL.DestroyWindow(win)
    SDL.Quit()
end

struct SDLQuitException <: Exception end

doEventChan = Channel{Function}(Inf)

function _doEvent()
    e = SDL.event()
    isnothing(e) && return
    println(e)
    if e isa SDL.QuitEvent
        throw(SDLQuitException())
    end
end

put!(doEventChan, _doEvent)

function main()
    SDL.Init(SDL.INIT_VIDEO)

    @async begin
        doEvent = take!(doEventChan)
        win, ren = createWindow()
        try
            while true
                while isready(doEventChan)
                    doEvent = take!(doEventChan)
                end

                doEvent()
                sleep(0.01)
            end
        catch e
            if isa(e, SDLQuitException)
                quit(win, ren)
            else
                rethrow()
            end
        end
    end
end

@Base.ccallable function juliaMain(argv::Vector{String})::Cint
    main()
end

end # module
