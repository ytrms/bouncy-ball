-- importing the class module, this will allow us
-- to have classes in our code
Class = require('class') -- we make it available globally for other files to use

-- importing the push module, which allows us to define
-- a virtual resolution which will then be up- or downscaled
-- to löve's actual resolution. Important for the retro look
local push = require('push')

-- Classes I've created on another file in the same folder
require "Ball"
require "Background"
require 'Pipe'

-- width and height of actual game window
local WINDOW_WIDTH = 480
local WINDOW_HEIGHT = 432

-- our "virtual," upscaled height
VIRTUAL_WIDTH = 160
VIRTUAL_HEIGHT = 144

-- love has three functions that get called: load, update, and draw, in this
-- order. We can override them to add our own functionality.

function love.load()
    -- setting love's filter to nearest neighbor for the pixel crispiness
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- sets the window's title
    love.window.setTitle("GBC Bouncy Ball Game")

    state = 'play'

    love.keyboard.keysPressed = {}

    -- sets up push
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
                     {fullscreen = false, resizable = true, pixelperfect = true})

    -- creating the ball
    redBall = Ball(VIRTUAL_WIDTH / 2 - 8, VIRTUAL_HEIGHT / 2 - 8,
                   "assets/ball.png")
    redBall:loadToMemory()

    -- creating the pipes table
    pipes = {}

    timer = 0

    math.randomseed(os.time())

    -- creating BG image object
    bg = Background(0, 0, "assets/tiled-bg.png")
    bg:loadToMemory()

    -- loading font to display FPS
    smallFont = love.graphics.setNewFont("assets/font.ttf", 8)

    -- a table with the keys pressed, which gets reset after each frame. Why?
    -- Because love doesn't allow us to know whether a key has been pressed
    -- "once", only if it's pressed down or not. Yet, what we want is to have
    -- an action applied to only one frame when the user presses it
    buttonsPressed = {}
end

function love.keypressed(key)
    -- each frame, we add the keys that have been pressed to this table.
    -- why? we can't detect one press, only the press state. By flushing this
    -- table at the end of each frame we have a table which effectively
    -- lists the keys that have been pressed on a specific frame

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key) return love.keyboard.keysPressed[key] end

function love.update(dt)
    -- quitting with escape
    if love.keyboard.isDown("escape") then love.event.quit() end

    if state == "play" then
        -- updating ball movement
        redBall:update(dt)

        -- every 2 seconds, add a pipe to the table
        timer = timer + dt
        if timer > 2 then
            local pipe = Pipe()
            pipe:loadToMemory()
            table.insert(pipes, #pipes, pipe)
            timer = 0
        end

        -- updating active pipes (that is, pipes in the table)
        for k, pipe in pairs(pipes) do
            pipe:update(dt)
            if pipe.x + pipe.width < 0 then
                pipe.toDelete = true -- marking pipes to delete if they reached end
            end
        end

        -- deleting pipes marked for deletion
        for k, pipe in pairs(pipes) do
            if pipe.toDelete then table.remove(pipes, k) end
        end

        -- cube collision with bottom
        if redBall.y + redBall.height > VIRTUAL_HEIGHT then
            state = "gameover"
        end

        -- ball collision with pipe
        for k, pipe in pairs(pipes) do
            if redBall:collidedWith(pipe) then state = "gameover" end
        end

        -- flushing out table of keys wasPressed
        love.keyboard.keysPressed = {}

        bg:update(dt)
    end
end

function love.draw()
    -- push "takes over" love's native draw function
    push:start()

    -- drawing the bg
    bg:draw()

    -- drawing the pink box
    redBall:draw()

    for k, pipe in pairs(pipes) do pipe:draw() end

    -- drawing the current FPS in the top left corner
    renderFPS()

    push:finish()
end

function love.resize(w, h) push:resize(w, h) end

function renderFPS()
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 5,
                        VIRTUAL_HEIGHT - 10)
end
