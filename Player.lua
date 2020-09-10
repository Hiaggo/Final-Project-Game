Player = Class{}

require 'Animation'

local MOVE_SPEED = 160
local JUMP_VELOCITY = 350

function Player:init(map)
    self.width = 32
    self.height = 32

    self.map = map

    self.health = 10

    -- Sound effects
    self.sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
        ['clear'] = love.audio.newSource('music/Victory.wav', 'static'),
        ['death'] = love.audio.newSource('music/Game Over.wav', 'static'),
        ['block'] = love.audio.newSource('sounds/empty-block.wav', 'static')
    }

    self.sounds['jump']:setVolume(0.015)
    self.sounds['hit']:setVolume(0.05)
    self.sounds['block']:setVolume(0.05)

    self.texture = love.graphics.newImage('graphics/masked_character.png')
    self.frames = generateQuads(self.texture, self.width, self.height)

    self.state = 'idle'
    self.direction = 'right'

    self.dust = love.graphics.newParticleSystem(love.graphics.newImage('graphics/Dust Particle.png'))
    self.dust:setParticleLifetime(0.1, 0.1)
    self.dust:setSizes(0.1, 0.8)

    -- X and Y velocities
    self.dx = 0
    self.dy = 0

    -- Initializes all player animations
    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[13],
                self.frames[14],
                self.frames[15],
                self.frames[16],
                self.frames[17],
                self.frames[18],
                self.frames[19],
                self.frames[20],
                self.frames[21],
                self.frames[22],
                self.frames[23]
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
                self.frames[12]
            },
            interval = 0.05
        },
        ['hurt'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[25],
                self.frames[26],
                self.frames[27],
                self.frames[28],
                self.frames[29],
                self.frames[30],
                self.frames[31]
            },
            interval = 0.15
        },
        ['jumping'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[61]
            },
            inteval = 1
        },
        ['double'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[37],
                self.frames[38],
                self.frames[39],
                self.frames[40],
                self.frames[41],
                self.frames[42]
            },
            inteval = 0.015
        },
        ['descending'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[73]
            },
            inteval = 1
        }
    }

    self.animation = self.animations['idle']

    self.behaviors = {
        ['idle'] = function(dt)
            if gameState == 'play' then
                self.dust:stop()
                if love.keyboard.wasPressed('space') then
                    self.dy = -JUMP_VELOCITY
                    self.state = 'jumping'
                    self.animation = self.animations['jumping']
                    self.sounds['jump']:play()

                elseif love.keyboard.isDown('a') then
                    self.dx = -MOVE_SPEED
                    self.animation = self.animations['walking']
                    self.state = 'walking'
                    self.direction = 'left'
            
                elseif love.keyboard.isDown('d') then
                    self.dx = MOVE_SPEED
                    self.animation = self.animations['walking']
                    self.state = 'walking'
                    self.direction = 'right'

                --[[elseif self.map:climbs(self.map:tileAt(self.x, self.y)) or
                    self.map:climbs(self.map:tileAt(self.x + self.width - 1, self.y)) then
                        if love.keyboard.isDown('w') then
                            self.state = 'climbing'
                            self.animation = self.animations['climbing']
                            self.dy = -MOVE_SPEED / 3
                        end

                elseif self.map:climbs(self.map:tileAt(self.x, self.y + self.height + self.height / 3)) or
                    self.map:climbs(self.map:tileAt(self.x + self.width - 1, self.y + self.height + self.height / 3)) then
                        if love.keyboard.isDown('s') then
                            self.state = 'climbing'
                            self.animation = self.animations['climbing']
                            self.dy = MOVE_SPEED / 3
                        end
                ]]

                else
                    self.dx = 0
                end
            end
        end,
        ['walking'] = function(dt)
            if gameState == 'play' then
                if love.keyboard.wasPressed('space') then
                    self.dy = -JUMP_VELOCITY
                    self.state = 'jumping'
                    self.animation = self.animations['jumping']
                    self.sounds['jump']:play()

                elseif love.keyboard.isDown('a') then
                    self.dx = -MOVE_SPEED
                    self.animation = self.animations['walking']
                    self.state = 'walking'
                    self.direction = 'left'

                    self.dust:start()
                    self.dust:setEmissionRate(5)
                    self.dust:setPosition(self.x + self.width - 10, self.y + self.height - 1)                 
                    self.dust:setSpeed(80)
            
                elseif love.keyboard.isDown('d') then
                    self.dx = MOVE_SPEED
                    self.animation = self.animations['walking']
                    self.state = 'walking'
                    self.direction = 'right'

                    self.dust:start()
                    self.dust:setEmissionRate(5)
                    self.dust:setPosition(self.x + 10, self.y + self.height - 1)                   
                    self.dust:setSpeed(-80)

                --[[elseif self.map:climbs(self.map:tileAt(self.x, self.y)) or
                    self.map:climbs(self.map:tileAt(self.x + self.width - 1, self.y)) then
                        
                        self.dx = 0
                        self.animation = self.animations['idle']
                        self.state = 'idle'
                        if love.keyboard.isDown('w') then
                            self.state = 'climbing'
                            self.animation = self.animations['climbing']
                            self.dy = -MOVE_SPEED / 3
                        end

                elseif self.map:climbs(self.map:tileAt(self.x, self.y + self.height + self.height / 3)) or
                    self.map:climbs(self.map:tileAt(self.x + self.width - 1, self.y + self.height + self.height / 3)) then
                        if love.keyboard.isDown('s') then
                            self.state = 'climbing'
                            self.animation = self.animations['climbing']
                            self.dy = MOVE_SPEED / 3
                        end
                ]]

                else
                    self.animation = self.animations['idle']
                    self.state = 'idle'
                    self.dx = 0
                end

                self:checkRightCollision()
                self:checkLeftCollision()

                if not self.map:collides(self.map:tileAt(self.x, self.y + self.height)) and
                    not self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                        -- Actually falling
                        self.state = 'jumping'
                        self.animation = self.animations['jumping']
                end
            end
        end,
        --[[['attacking'] = function(dt)
            if love.keyboard.isDown('e') then
                dummy = self.map:whoIsNear()
                if dummy and self.x + self.width + self.width / 2 >= dummy.x and
                    self.x + self.width < dummy.x + dummy.width and
                        self.y < dummy.y + dummy.height / 2 and
                            self.y + self.height > dummy.y then
                                self.direction = 'right'
                                self.animation = self.animations['attacking']
                                self.sounds['hit']:play()
                                self.state = 'attacking'

                                dummy.dy = -JUMP_VELOCITY / 3
                                dummy.dx = MOVE_SPEED / 3
                                dummy.y = dummy.y - 2
                                dummy.state = 'jumping'
                                dummy.animation = dummy.animations['jumping']

                                dummy.health = math.floor(dummy.health - 1 * dt * 7)

                elseif dummy and self.x - self.width / 2 <= dummy.x + dummy.width and
                    self.x > dummy.x and self.y < dummy.y + dummy.height / 2 and
                        self.y + self.height > dummy.y then
                            self.direction = 'left'
                            self.animation = self.animations['attacking']
                            self.sounds['hit']:play()
                            self.state = 'attacking'
                            
                            dummy.dy = -JUMP_VELOCITY / 3
                            dummy.dx = -MOVE_SPEED / 3
                            dummy.y = dummy.y - 2
                            dummy.state = 'jumping'
                            dummy.animation = dummy.animations['jumping']

                            dummy.health = math.floor(dummy.health - 1 * dt * 7)
                else
                    self.state = 'idle'
                    self.animation = self.animations['idle']
                end
            end

            self.dy = self.dy + self.map.gravity

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
        ['climbing'] = function(dt)
            -- Checks if the tile below is a climbable object (ladder)
            if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then       
                    self.dy = 0
                    self.state = 'idle'
                    self.animation = self.animations[self.state]
                    self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) * self.map.tileHeight - self.height

            elseif self.map:climbs(self.map:tileAt(self.x, self.y)) or
                self.map:climbs(self.map:tileAt(self.x + self.width - 1, self.y)) then
                    if love.keyboard.isDown('w') then
                        self.state = 'climbing'
                        self.animation = self.animations['climbing']
                        self.dy = -MOVE_SPEED / 3
                        self.dx = 0
                    end

            elseif self.map:climbs(self.map:tileAt(self.x, self.y + self.height)) or
                self.map:climbs(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                    if love.keyboard.isDown('s') then
                        self.state = 'climbing'
                        self.animation = self.animations['climbing']
                        self.dy = MOVE_SPEED / 3
                    end
            else
                self.dy = 0
                self.state = 'idle'
                self.animation = self.animations[self.state]
            end
        end,]]
        ['jumping'] = function(dt)
            if gameState == 'play' then
                self.dust:stop()
                -- Breaks if we go below the surface
                if self.y > self.map.mapHeight * self.map.tileHeight then
                    gameState = 'lose'
                end

                if self.dy >= 0 then
                    self.animation = self.animations['descending']
                end

                if self.map.level ~= 'second' then
                    dummy = self.map:whoIsNear()
                end
                if dummy and self.animation == self.animations['descending'] and self.y + self.height >= dummy.y and self.y < dummy.y and
                    ((self.x >= dummy.x and self.x <= dummy.x + dummy.width) or 
                        (self.x + self.width >= dummy.x and self.x < dummy.x)) then
                            self.sounds['hit']:play()
                                
                            dummy.dy = -JUMP_VELOCITY / 3
                            dummy.dx = -MOVE_SPEED / 3
                            self.dy = -JUMP_VELOCITY / 3
                            dummy.y = dummy.y - 2
                            dummy.state = 'hurt'
                            dummy.animation = dummy.animations['hurt']

                            dummy.health = math.floor(dummy.health - 1 * dt * 20)            
                end

                if love.keyboard.wasPressed('space') then
                    self.dy = -JUMP_VELOCITY
                    self.state = 'double'
                    self.animation = self.animations['double']
                    self.sounds['jump']:play()
                elseif love.keyboard.isDown('a') then
                    self.direction = 'left'
                    self.dx = -MOVE_SPEED
                elseif love.keyboard.isDown('d') then
                    self.direction = 'right'
                    self.dx = MOVE_SPEED
                end

                self.dy = self.dy + self.map.gravity

                if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                    self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then       
                    
                    self.dy = 0
                    self.state = 'idle'
                    self.animation = self.animations[self.state]
                    self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) * self.map.tileHeight - self.height
                end

                self:checkRightCollision()
                self:checkLeftCollision()
                
                if self.health <= 0 then
                    gameState = 'lose'
                end
            end        
        end,
        ['double'] = function(dt)
            if gameState == 'play' then
                -- Breaks if we go below the surface
                if self.y > self.map.mapHeight * self.map.tileHeight then
                    gameState = 'lose'
                end

                if self.dy >= 0 then
                    self.animation = self.animations['descending']
                end

                if self.map.level ~= 'second' then
                    dummy = self.map:whoIsNear()
                end
                if dummy and self.animation == self.animations['descending'] and self.y + self.height >= dummy.y and self.y < dummy.y and
                    ((self.x >= dummy.x and self.x <= dummy.x + dummy.width) or 
                        (self.x + self.width >= dummy.x and self.x + self.width < dummy.x + dummy.width)) then
                            self.sounds['hit']:play()
                                
                            dummy.dy = -JUMP_VELOCITY / 3
                            dummy.dx = -MOVE_SPEED / 3
                            self.dy = -JUMP_VELOCITY / 3
                            dummy.y = dummy.y - 2
                            dummy.state = 'hurt'
                            dummy.animation = dummy.animations['hurt']

                            dummy.health = math.floor(dummy.health - 1 * dt * 20)    
                
                end

                if love.keyboard.isDown('a') then
                    self.direction = 'left'
                    self.dx = -MOVE_SPEED
                elseif love.keyboard.isDown('d') then
                    self.direction = 'right'
                    self.dx = MOVE_SPEED
                end

                self.dy = self.dy + self.map.gravity

                if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                    self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then       
                    
                    self.dy = 0
                    self.state = 'idle'
                    self.animation = self.animations[self.state]
                    self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) * self.map.tileHeight - self.height
                end

                self:checkRightCollision()
                self:checkLeftCollision()
                
                if self.health <= 0 then
                    gameState = 'lose'
                end
            end
        end,
        ['hurt'] = function(dt)
            if gameState == 'play' then
                -- Breaks if we go below the surface
                if self.y > self.map.mapHeight * self.map.tileHeight then
                    gameState = 'lose'
                end

                if love.keyboard.isDown('a') then
                    self.direction = 'left'
                    self.dx = -MOVE_SPEED
                elseif love.keyboard.isDown('d') then
                    self.direction = 'right'
                    self.dx = MOVE_SPEED
                end

                self.dy = self.dy + self.map.gravity

                if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                    self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then       
                    
                    self.dy = 0
                    self.state = 'idle'
                    self.animation = self.animations[self.state]
                    self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) * self.map.tileHeight - self.height
                end

                self:checkRightCollision()
                self:checkLeftCollision()
                
                if self.health <= 0 then
                    self.sounds['death']:play()
                    self.sounds['death']:setVolume(0.05)
                    gameState = 'lose'
                end
            end
        end
    }
end

function Player:checkLeftCollision()
    if self.dx < 0 then
        -- Checks if there's a tile beneath us
        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) or
            self.map:collides(self.map:tileAt(self.x - 1, self.y + self.height - 1)) then
                self.dx = 0
                self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth
        end
    end
end

function Player:checkRightCollision()
    if self.dx > 0 then
        -- Checks if there's a tile beneath us
        if self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height - 1)) then
                self.dx = 0
                self.x = (self.map:tileAt(self.x + self.width, self.y).x - 1) * self.map.tileWidth - self.width
        end
    end
end

-- Jumping and block hitting logic
function Player:calculateJumps()
    
    -- if we have negative y velocity (jumping), check if we collide
    -- with any blocks above us
    if self.dy < 0 then
        if self.map:collides(self.map:tileAt(self.x, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y)) then
            -- Sets y speed to 0
            self.dy = 0

            if self.map:tileAt(self.x, self.y).id ~= TILE_EMPTY or 
                self.map:tileAt(self.x + self.width - 1, self.y).id ~= TILE_EMPTY  then
                    playHit = true
            end

            if playHit then
                self.sounds['block']:play()
            end
        end
    end
end

function Player:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    
    self.x = self.x + self.dx * dt
    
    self:calculateJumps()

    self.dust:update(dt)

    self.y = self.y + self.dy * dt
end

function Player:render()

    local scaleX
    if self.direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end

    love.graphics.draw(self.texture, self.animation:getCurrentFrame(), 
        math.floor(self.x + self.width / 2), math.floor(self.y + self.height / 2),
            0, scaleX, 1, self.width / 2 - 2, self.height / 2 - 2)

    love.graphics.draw(self.dust, 0, 0)
end