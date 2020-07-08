module OrbitCLone

using SimpleDirectMediaLayer
const SDL = SimpleDirectMediaLayer

import SimpleDirectMediaLayer.IMG_LoadTexture


const SCREEN_WIDTH = 1920
const SCREEN_HEIGHT = 1080

print(dirname(@__FILE__))

function loadTexture(file, renderer)
   texture = SDL.IMG_LoadTexture(renderer, file)
   if texture == C_NULL
    error = SDL.GetError()
    error = unsafe_string(error)
    print(error)
   end
   return texture 
end

function init()
    code1 = SDL.Init(SDL.INIT_VIDEO)
    code2 = SimpleDirectMediaLayer.IMG_Init(Int32(SimpleDirectMediaLayer.IMG_INIT_PNG))
    return code1, code2
end

function createWindow()
    win = SDL.CreateWindow("OrbitCLone", Int32(SDL.WINDOWPOS_CENTERED()), Int32(SDL.WINDOWPOS_CENTERED()), Int32(SCREEN_WIDTH), Int32(SCREEN_HEIGHT), UInt32(SDL.WINDOW_SHOWN))
    renderer = SDL.CreateRenderer(win, Int32(-1), UInt32(SDL.RENDERER_ACCELERATED | SDL.RENDERER_PRESENTVSYNC))
    return win, renderer
end

function quit(win, renderer)
    SDL.DestroyRenderer(renderer)
    SDL.DestroyWindow(win)
    SDL.IMG_Quit()
    SDL.Quit()
end

function runGame(win, renderer)

    texture = loadTexture("assets/OCL_Player.png", renderer)
    while true
        e = SDL.event()
        if e != nothing
            if e isa SDL.QuitEvent
                quit(win, renderer)
                break
            end
        end
        SDL.RenderClear(renderer)
        SimpleDirectMediaLayer.SetRenderDrawColor(renderer, 34, 18, 57, 255)
        SDL.RenderCopy(renderer, texture, C_NULL, C_NULL)
        SDL.RenderPresent(renderer)
    end
end

init()
win, ren = createWindow()
runGame(win, ren)

end # module
