SpikeHead = Class{}

require 'Animation'

local MOVE_SPEED = 200
local JUMP_VELOCITY = 350
local SpikeHead_SPEED = 150

function SpikeHead:init(orientation, distance_1, distance_2, map)
    self.width = 54
    self.height = 52
    
    self.map = map

    self.dx = SpikeHead_SPEED

    self.dy = SpikeHead_SPEED
    
    self.texture = love.graphics.newImage('graphics/spike_head.png')
    self.frames = generateQuads(self.texture, self.width, self.height)
    
    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[1],
                self.frames[2],
                self.frames[3],
                self.frames[4]
            },
            interval = 0.2
        },
        ['right_hit'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[9],
                self.frames[10],
                self.frames[11],
                self.frames[12]
            },
            interval = 0.05
        },
        ['left_hit'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[5],
                self.frames[6],
                self.frames[7],
                self.frames[8]
            },
            interval = 0.05
        }
    }

    self.state = 'idle'
    self.animation = self.animations['idle']

    self.behaviors = {
        ['idle'] = function(dt)
            if orientation == 'horizontal' then
                self.dy = 0
                if self.x + self.width >= self.map.tileWidth * (distance_1) then
                    self.dx = -SpikeHead_SPEED
                    self.animation = self.animations['right_hit']
                elseif self.x <= self.map.tileWidth * (distance_2) then
                    self.animation = self.animations['left_hit']
                    self.dx = SpikeHead_SPEED
                end
            elseif orientation == 'vertical' then
                self.dx = 0
                if self.y + self.height >= self.map.tileHeight * (distance_1) then
                    self.dy = -SpikeHead_SPEED
                    self.animation = self.animations['right_hit']
                elseif self.y <= self.map.tileHeight * (distance_2) then
                    self.animation = self.animations['left_hit']
                    self.dy = SpikeHead_SPEED
                end
            end

            if self.animation.currentFrame >= 3 then
                self.animation = self.animations['idle']

            elseif self:isInRangeRight() then
                self:hitTarget('right', dt)
            elseif self:isInRangeLeft() then
                self:hitTarget('left', dt)
            end
        end
    }
end

-- Hitting target logic
function SpikeHead:hitTarget(direction, dt)
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
function SpikeHead:isInRangeRight()
    if self.x + self.width >= self.map.player.x and
                self.x + self.width < self.map.player.x + self.map.player.width and
                    self.y + 5 < self.map.player.y + self.map.player.height and
                        self.y + self.height - 10 > self.map.player.y and gameState == 'play' then
                            return true
    else
        return false
    end
end

-- Checks if the target is within the range on the left, returns true if it is
function SpikeHead:isInRangeLeft()
    if self.x <= self.map.player.x + self.map.player.width and
        self.x > self.map.player.x and self.y + 5 < self.map.player.y + self.map.player.height and
            self.y + self.height - 10 > self.map.player.y and gameState == 'play' then
                return true
    else
        return false
    end
end

function SpikeHead:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)

    self.x = self.x + self.dx * dt

    self.y = self.y + self.dy * dt
end

function SpikeHead:render()
    love.graphics.draw(self.texture, self.animation:getCurrentFrame(), 
        math.floor(self.x + self.width / 2), math.floor(self.y + self.height / 2), 
            0, scaleX, 1, self.width / 2, self.height / 2)
end