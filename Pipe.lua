Pipe = Class{}

function Pipe:init()
    self.x = VIRTUAL_WIDTH
    self.y = math.random(VIRTUAL_WIDTH / 2, VIRTUAL_WIDTH - 10)
    self.filename = "assets/pipe.png"
    self.dx = 20
    self.toDelete = false
end

function Pipe:loadToMemory()
    self.drawable = love.graphics.newImage(self.filename)
    self.height = self.drawable:getHeight()
    self.width = self.drawable:getWidth()
end

function Pipe:update(dt)
    self.x = self.x - self.dx * dt
end

function Pipe:draw()
    love.graphics.draw(self.drawable, self.x, self.y)
end