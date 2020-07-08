module OrbitCLone

using SimpleDirectMediaLayer

const SDL = SimpleDirectMediaLayer

SDL.Init(SDL.INIT_VIDEO)

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

function runGame(win, renderer)

    while true
        e = SDL.event()
        if e != nothing
            print(e)
            if e isa SDL.QuitEvent
                quit(win, renderer)
                break
            end
        end
    end
end

test = 2

end # module
