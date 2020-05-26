Background = Class{}

function Background:init(x, y, filename)
    self.x = x
    self.y = y
    self.dx = 30
    self.filename = filename
end

function Background:loadToMemory()
    self.drawable = love.graphics.newImage(self.filename)
end

function Background:draw()
    love.graphics.draw(self.drawable, self.x, self.y)
end

function Background:update(dt)
    -- scrolling the BG at a set speed
    bg.x = bg.x - bg.dx * dt

    -- if bg has scrolled -WIDTH to the left, we blit it to 0 to repeat it inf.
    if bg.x <= -VIRTUAL_WIDTH then
        bg.x = 0
    end
end