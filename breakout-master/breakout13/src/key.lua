--[[
    GD50
    Breakout Remake

    -- key Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a key which will bounce back and forth between the sides
    of the world space, the player's paddle, and the bricks laid out above
    the paddle. The key can have a skin, which is chosen at random, just
    for visual variety.
]]

key = Class{}


paletteColors2 = {
    -- blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    }
}



function key:init(skin)
    -- simple positional and dimensional variables
    self.width = 8
    self.height = 8
    haskey = 0


    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)
    self.psystem:setParticleLifetime(0.5, 1)
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)
    self.psystem:setEmissionArea('normal', 10, 10)

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the key can move in two dimensions
    self.dy = 0
    self.dx = 0

    -- this will effectively be the color of our key, and we will indexyt8
    -- our table of Quads relating to the global block texture using this
    self.skin = skin
end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function key:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    Places the key in the middle of the screen, with no movement.
]]
function key:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
    haskey = 0
end

function key:hit()
    haskey = 1
    gSounds['powerup']:play()
    
    self.psystem:setColors(
        paletteColors2[1].r / 255,
        paletteColors2[1].g / 255,
        paletteColors2[1].b / 255,
        55 * (1) / 255,
        paletteColors2[1].r / 255,
        paletteColors2[1].g / 255,
        paletteColors2[1].b / 255,
        0
    )
    self.psystem:emit(64)
end


function key:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- allow key to bounce off walls
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.x >= VIRTUAL_WIDTH - 8 then
        self.x = VIRTUAL_WIDTH - 8
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        gSounds['wall-hit']:play()
    end
end

function key:render()
    -- gTexture is our global texture for all blocks
    -- gkeyFrames is a table of quads mapping to each individual key skin in the texture
    love.graphics.draw(gTextures['main'], gFrames['keys'][1],
        self.x, self.y)
end

function key:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end