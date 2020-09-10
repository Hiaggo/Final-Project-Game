Saw = Class{}

require 'Animation'

local MOVE_SPEED = 200
local JUMP_VELOCITY = 350
local SAW_SPEED = 62

function Saw:init(distance_1, distance_2, map)
    self.width = 38
    self.height = 38
    
    self.map = map

    self.dy = -SAW_SPEED
    
    self.texture = love.graphics.newImage('graphics/Saw (38x38).png')
    self.frames = generateQuads(self.texture, self.width, self.height)
    
    self.animations = {
        ['off'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[1]
            },
            interval = 1
        },
        ['on'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[1],
                self.frames[2],
                self.frames[3],
                self.frames[4],
                self.frames[5],
                self.frames[6],
                self.frames[7],
                self.frames[8]
            },
            interval = 0.05
        }
    }

    self.state = 'on'
    self.animation = self.animations['on']

    self.behaviors = {
        ['on'] = function(dt)
            if self.y >= self.map.tileHeight * (distance_1) - 40 then
                self.dy = -SAW_SPEED
            elseif  self.y <= self.map.tileHeight * (distance_2) - self.height then
                self.dy = SAW_SPEED

            elseif self:isInRangeRight() then
                self:hitTarget('right', dt)
            elseif self:isInRangeLeft() then
                self:hitTarget('left', dt)
            end
        end
    }
end

-- Hitting target logic
function Saw:hitTarget(direction, dt)
    self.map.player.sounds['hit']:play()
    
    if direction == 'left' then -- Throws the player back
        self.map.player.dx = -MOVE_SPEED / 3
    else
        self.map.player.dx = MOVE_SPEED / 3
    end
    self.map.player.dy = -JUMP_VELOCITY / 3 -- Throws the player up, so there's the impression of impact
    self.map.player.y = self.map.player.y - 2 -- basically makes the characters fall by manually updating their position
    self.map.player.state = 'hurt'
    self.map.player.animation = self.map.player.animations['hurt']

    self.map.player.health = math.floor(self.map.player.health - 1 - dt)
end

-- Checks if the target is within the range on the right, returns true if it is
function Saw:isInRangeRight()
    if self.x + self.width >= self.map.player.x and
                self.x + self.width < self.map.player.x + self.map.player.width and
                    self.y + 10 < self.map.player.y + self.map.player.height and
                        self.y + self.height - 10 > self.map.player.y and gameState == 'play' then
                            return true
    else
        return false
    end
end

-- Checks if the target is within the range on the left, returns true if it is
function Saw:isInRangeLeft()
    if self.x <= self.map.player.x + self.map.player.width and
        self.x > self.map.player.x and self.y + 10 < self.map.player.y + self.map.player.height and
            self.y + self.height - 10 > self.map.player.y and gameState == 'play' then
                return true
    else
        return false
    end
end

function Saw:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)

    self.y = self.y + self.dy * dt
end

function Saw:render()
    love.graphics.draw(self.texture, self.animation:getCurrentFrame(), 
        math.floor(self.x + self.width / 2), math.floor(self.y + self.height / 2), 
            0, scaleX, 1, self.width / 2, self.height / 2)
end