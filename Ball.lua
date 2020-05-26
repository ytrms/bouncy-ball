Ball = Class{}

function Ball:init(x, y, filename)
    -- Remember to also call Ball:loadToMemory to actually load the drawable!
    self.x = x -- x position of ball
    self.y = y -- y position of ball
    self.dy = 40 -- delta Y for movement
    self.gravity = 150 -- gravity factor to apply to delta Y progressively
    self.spriteFile = filename -- name of the sprite file
end

function Ball:loadToMemory()
    self.drawable = love.graphics.newImage(self.spriteFile)
    self.height = self.drawable:getHeight()
    self.width = self.drawable:getWidth()

    self.centerX = self.x + self.width / 2
    self.centerY = self.y + self.height / 2
end

function Ball:draw()
    love.graphics.draw(self.drawable, self.x, self.y)
end

function Ball:update(dt)
    -- make the ball constantly fall at dy rate
    self.y = self.y + self.dy * dt

    -- apply gravity to dY
    self.dy = self.dy + self.gravity * dt

    -- if user pressed spacebar, invert gravity for a bit
    if love.keyboard.wasPressed("space") then
        self.dy = -50
    end
end

function Ball:collidedWith(pipe)
    if self.x < pipe.x + pipe.width and
    self.x + self.width > pipe.x and
    self.y < pipe.y + pipe.height and
    self.y + self.height > pipe.y then
        return true
    else
        return false
    end
end