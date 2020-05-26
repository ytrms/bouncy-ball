Pipe = Class{}

-- loading the pipe image as drawable only once since it's always the same
-- (saves on memory)
PIPE_DRAWABLE = love.graphics.newImage("assets/pipe.png")

function Pipe:init()
    self.x = VIRTUAL_WIDTH
    self.y = math.random(VIRTUAL_WIDTH / 2, VIRTUAL_WIDTH - VIRTUAL_HEIGHT / 3)
    self.dx = 20
    self.toDelete = false
    self.height = PIPE_DRAWABLE:getHeight()
    self.width = PIPE_DRAWABLE:getWidth()
end

function Pipe:update(dt)
    self.x = self.x - self.dx * dt
end

function Pipe:draw()
    love.graphics.draw(PIPE_DRAWABLE, self.x, self.y)
end