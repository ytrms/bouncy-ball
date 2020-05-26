Background = Class{}

BG_DRAWABLE = love.graphics.newImage("assets/tiled-bg.png")

function Background:init()
    self.x = 0
    self.y = 0
    self.dx = 30
end

function Background:draw()
    love.graphics.draw(BG_DRAWABLE, self.x, self.y)
end

function Background:update(dt)
    -- scrolling the BG at a set speed
    bg.x = bg.x - bg.dx * dt

    -- if bg has scrolled -WIDTH to the left, we blit it to 0 to repeat it inf.
    if bg.x <= -VIRTUAL_WIDTH then
        bg.x = 0
    end
end