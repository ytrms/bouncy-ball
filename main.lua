-- importing the class module, this will allow us
-- to have classes in our code
Class = require('class') -- we make it available globally for other files to use

-- importing the push module, which allows us to define
-- a virtual resolution which will then be up- or downscaled
-- to löve's actual resolution. Important for the retro look
local push = require('push')

-- Importing classes
require "Ball"
require "Background"
require 'Pipe'

-- width and height of actual game window
local WINDOW_WIDTH = 480
local WINDOW_HEIGHT = 432

-- our "virtual" size
VIRTUAL_WIDTH = 160
VIRTUAL_HEIGHT = 144

-- love has three functions that get called: load, update, and draw, in this
-- order. We can override them to add our own functionality.

function love.load()
    -- setting love's filter to nearest neighbor for the pixel crispiness
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- sets the window's title
    love.window.setTitle("GBC Bouncy Ball Game")

    -- initializing the current state directly to "play" as there's no title 
    -- screen (as of yet)
    state = 'play'

    -- initializing table in which we will store, each frame, the keys pressed 
    -- by the user
    love.keyboard.keysPressed = {}

    -- sets up push
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
                     {fullscreen = false, resizable = true, pixelperfect = true})

    -- creating the ball by creating an object from the Ball class
    redBall = Ball(VIRTUAL_WIDTH / 2 - 8, VIRTUAL_HEIGHT / 2 - 8,
                   "assets/ball.png")
    redBall:loadToMemory()

    -- creating the pipes table, which will contain active (e.g. on screen)
    -- pipes
    pipes = {}

    -- initializing timer, which we will use to determine when to spawn a new
    -- pipe (or set of pipes) on screen
    timer = 0

    -- Lua's "random" function needs to be manually randomized with the current
    -- time, otherwise it will be "the same random every time"
    math.randomseed(os.time())

    -- creating BG image object
    bg = Background()

    -- loading font to display FPS
    smallFont = love.graphics.setNewFont("assets/font.ttf", 8)
end

function love.keypressed(key)
    -- this is the only function in LOVE in which you can listen for user input.

    -- each frame, we add the keys that have been pressed to this table.
    -- why? we can't detect one press, only the press state. By flushing this
    -- table at the end of each frame we have a table which effectively
    -- lists the keys that have been pressed during a specific frame

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key) return love.keyboard.keysPressed[key] end

function love.update(dt)
    -- quitting with escape (valid in any state)
    if love.keyboard.isDown("escape") then love.event.quit() end

    -- the following are updates which should only take place in the "play" state
    if state == "play" then

        -- updating ball movement
        redBall:update(dt)

        -- every 2 seconds, add a pipe to the pipes table
        timer = timer + dt
        if timer > 2 then
            local pipe = Pipe() -- add pipe to table
            table.insert(pipes, #pipes, pipe)
            timer = 0
        end

        -- updating active pipes (that is, pipes in the table)
        for k, pipe in pairs(pipes) do
            pipe:update(dt)
            if pipe.x + pipe.width < 0 then
                pipe.toDelete = true -- marking pipes if they reached end
            end
        end

        -- deleting pipes marked for deletion
        for k, pipe in pairs(pipes) do
            if pipe.toDelete then table.remove(pipes, k) end
        end

        -- if ball collides with bottom, switch to game over state (not implem.)
        if redBall.y + redBall.height > VIRTUAL_HEIGHT then
            state = "gameover"
        end

        -- if the ball collides with any of the active pipes, go to gameover
        for k, pipe in pairs(pipes) do
            if redBall:collidedWith(pipe) then state = "gameover" end
        end

        -- flushing out table of keys pressed 
        love.keyboard.keysPressed = {}

        bg:update(dt)
    end
end

function love.draw()
    -- push "takes over" love's native draw function
    push:start()

    -- drawing the bg
    bg:draw()

    -- drawing the ball 
    redBall:draw()

    -- drawing the pipes in the pipes table 
    for k, pipe in pairs(pipes) do pipe:draw() end

    -- drawing the current FPS in the top left corner
    drawFPS()

    push:finish()
end

-- push also takes over love's resizing function
function love.resize(w, h) push:resize(w, h) end

function drawFPS()
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 5,
                        VIRTUAL_HEIGHT - 10)
end
