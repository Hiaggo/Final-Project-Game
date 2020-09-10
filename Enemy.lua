Enemy = Class{}

require 'Animation'

local MOVE_SPEED = 160
local JUMP_VELOCITY = 350

local actionQueue = false

function Enemy:init(map)
    self.width = 32
    self.height = 34

    self.map = map

    self.health = 1

    -- Sound effects
    self.sounds = {
        ['coin'] = love.audio.newSource('sounds/coin.wav', 'static'),
        ['hit'] = love.audio.newSource('sounds/hit.wav', 'static')
    }

    self.sounds['hit']:setVolume(0.005)

    self.texture = love.graphics.newImage('graphics/chicken.png')
    self.frames = generateQuads(self.texture, self.width, self.height)

    self.state = 'idle'
    self.direction = 'right'

    -- X and Y velocities
    self.dx = 0
    self.dy = 0

    -- Initializes all Enemy animations
    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[15],
                self.frames[16],
                self.frames[17],
                self.frames[18],
                self.frames[19],
                self.frames[20],
                self.frames[21],
                self.frames[22],
                self.frames[23],
                self.frames[24],
                self.frames[25],
                self.frames[26],
                self.frames[27]
            },
            interval = 0.05
        },
        ['walking'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[1],
                self.frames[2],
                self.frames[3],
                self.frames[4],
                self.frames[5],
                self.frames[6],
                self.frames[7],
                self.frames[8],
                self.frames[9],
                self.frames[10],
                self.frames[11],
                self.frames[12],
                self.frames[13],
                self.frames[14]
            },
            interval = 0.03
        },
        ['attacking'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[5]
            },
            interval = 1
        },
        ['hurt'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[29],
                self.frames[30],
                self.frames[31],
                self.frames[32],
                self.frames[33]
            },
            inteval = 0.05
        }
    }

    self.animation = self.animations['idle']

    self.behaviors = {
        ['idle'] = function(dt)
            -- if the player is within the 'sight' range
            if self.map.player.x + 12 * self.map.tileWidth > self.x 
                and self.map.player.x + self.map.player.width < self.x and
                    self.map:tileAt(self.x - 5, self.y + self.height + 5).id ~= TILE_EMPTY and
                        self.map.player.y + self.map.player.height <= self.y + self.height and 
                        self.map.player.y + self.map.player.height > self.y - self.height then
                            self.dx = -MOVE_SPEED
                            self.animation = self.animations['walking']
                            self.state = 'walking'
                            self.direction = 'left'
                           
            -- Moves till it's right next to the player
            elseif self.map.player.x < self.x + 12 * self.map.tileWidth
                and self.map.player.x > self.x + self.width and
                    self.map:tileAt(self.x + self.width + 5, self.y + self.height + 5).id ~= TILE_EMPTY and
                        self.map.player.y + self.map.player.height <= self.y + self.height and 
                        self.map.player.y + self.map.player.height > self.y - self.height then 
                            self.dx = MOVE_SPEED
                            self.animation = self.animations['walking']
                            self.state = 'walking'
                            self.direction = 'right'
            
            elseif self:isInRangeRight() then
                self.animation = self.animations['attacking']
                self.state = 'attacking'

            elseif self:isInRangeLeft() then
                self.animation = self.animations['attacking']
                self.state = 'attacking'
            
            else
                self.state = 'idle'
                self.animation = self.animations['idle']
                self.dx = 0
            end
        end,
        ['walking'] = function(dt)

            -- Follows the player when they are within the 'sight' range
            if self.map.player.x + 12 * self.map.tileWidth > self.x 
                and self.map.player.x + self.map.player.width < self.x and
                    self.map:tileAt(self.x - 1, self.y + self.height + 1).id ~= TILE_EMPTY and
                        self.map.player.y + self.map.player.height <= self.y + self.height and 
                            self.map.player.y + self.map.player.height > self.y - 2 * self.height then
                                self.dx = -MOVE_SPEED
                                self.animation = self.animations['walking']
                                self.state = 'walking'
                                self.direction = 'left'

            elseif self.map.player.x < self.x + 12 * self.map.tileWidth
                and self.map.player.x > self.x + self.width and
                    self.map:tileAt(self.x + self.width + 1, self.y + self.height + 1).id ~= TILE_EMPTY and
                        self.map.player.y + self.map.player.height <= self.y + self.height and 
                            self.map.player.y + self.map.player.height > self.y - 2 * self.height then
                                self.dx = MOVE_SPEED
                                self.animation = self.animations['walking']
                                self.state = 'walking'
                                self.direction = 'right'

            elseif self:isInRangeRight() then
                self.animation = self.animations['attacking']
                self.state = 'attacking'

            elseif self:isInRangeLeft() then
                self.animation = self.animations['attacking']
                self.state = 'attacking'
            else
                self.dx = 0
                self.animation = self.animations['idle']
                self.state = 'idle'
            end

            self:checkRightCollision()
            self:checkLeftCollision()

            if not self.map:collides(self.map:tileAt(self.x, self.y + self.height)) and
                not self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                    -- Actually falling
                    self.dy = self.dy + self.map.gravity
            end
        end,
        ['attacking'] = function(dt)
            if self:isInRangeRight() then
                self:hitTarget('right', dt)

            elseif self:isInRangeLeft() then
                self:hitTarget('left', dt)

            else
                self.state = 'idle'
                self.animation = self.animations['idle']
            end

            self.dy = self.dy + self.map.gravity

            -- Checks if there's 'ground' beneath
            if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then                 
                    self.dy = 0
                    self.state = 'idle'
                    self.animation = self.animations[self.state]
                    self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) * self.map.tileHeight - self.height
            end

            self:checkRightCollision()
            self:checkLeftCollision()
        end,
        ['hurt'] = function(dt)

            if self.y > 260 then -- 'Kills' the character if it is beyond 260 pixels on the y-axis
                self.map:destroy(self)
            end

            self.dy = self.dy + self.map.gravity -- Aplies the gravity effect

            -- Checks if there's 'solid ground' beneath
            if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then                 
                    self.dy = 0
                    self.state = 'idle'
                    self.animation = self.animations['idle']
                    self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) * self.map.tileHeight - self.height
            end

            self:checkRightCollision()
            self:checkLeftCollision()

            if self.health <= 0 and self.animation.currentFrame > 4 then -- if the character's health goes below zero, the character is removed from the session/game
                self.map:destroy(dummy)
            end
        end
    }
end

-- Hitting target logic
function Enemy:hitTarget(direction, dt)
    self.direction = direction
    self.animation = self.animations['attacking']
    self.sounds['hit']:play()
    self.state = 'attacking'
    
    if direction == 'left' then -- Throws the player back
        self.map.player.dx = -MOVE_SPEED / 3
    else
        self.map.player.dx = MOVE_SPEED / 3
    end
    self.map.player.dy = -JUMP_VELOCITY / 3 -- Throws the player up, so there's the impression of impact
    self.map.player.y = self.map.player.y - 2 -- basically makes the characters fall by manually updating their position
    self.map.player.state = 'hurt'
    self.map.player.animation = self.map.player.animations['hurt']

    self.map.player.health = math.floor(self.map.player.health - 1 * dt * 7)
end

-- Checks if the target is within the range on the right, returns true if it is
function Enemy:isInRangeRight()
    if self.state ~= 'hurt' and self.x + self.width + self.width / 5 >= self.map.player.x and
                self.x + self.width < self.map.player.x + self.map.player.width and
                    self.y < self.map.player.y + self.map.player.height / 2 and
                        self.y + self.height > self.map.player.y and gameState == 'play' then
                            return true
    else
        return false
    end
end

-- Checks if the target is within the range on the left, returns false if it is
function Enemy:isInRangeLeft()
    if self.state ~= 'hurt' and self.x - self.width / 5 <= self.map.player.x + self.map.player.width and
        self.x > self.map.player.x and self.y < self.map.player.y + self.map.player.height / 2 and
            self.y + self.height > self.map.player.y and gameState == 'play' then
                return true
    else
        return false
    end
end

function Enemy:checkLeftCollision()
    if self.dx < 0 then
        -- Checks if there's a tile beneath us
        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) or
            self.map:collides(self.map:tileAt(self.x - 1, self.y + self.height - 1)) then

                self.dx = 0
                self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth
        end
    end
end

function Enemy:checkRightCollision()
    if self.dx > 0 then
        -- Checks if there's a tile beneath us
        if self.map:collides(self.map:tileAt(self.x + self.width, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width, self.y + self.height - 1)) then

                self.dx = 0
                self.x = (self.map:tileAt(self.x + self.width, self.y).x - 1) * self.map.tileWidth - self.width
        end
    end
end

function Enemy:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.x = self.x + self.dx * dt

    self.y = self.y + self.dy * dt
end

function Enemy:render()

    local scaleX -- variable to flip the sprite when the orientation changes
    if self.direction == 'right' then
        scaleX = -1
    else
        scaleX = 1
    end

    love.graphics.draw(self.texture, self.animation:getCurrentFrame(), 
        math.floor(self.x + self.width / 2), math.floor(self.y + self.height / 2),
        0, scaleX, 1, self.width / 2, self.height / 2)
end