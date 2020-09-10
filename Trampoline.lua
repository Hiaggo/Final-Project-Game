Trampoline = Class{}

require 'Animation'

local JUMP_VELOCITY = 350

function Trampoline:init(map)
    self.width = 28
    self.height = 28

    self.map = map

    self.texture = love.graphics.newImage('graphics/Trampoline.png')
    self.frames = generateQuads(self.texture, self.width, self.height)

    self.sound = love.audio.newSource('sounds/trampoline.wav', 'static')

    self.sound:setVolume(0.05)

    self.state = 'idle'

    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[9]
            },
            interval = 1
        },
        ['jump'] = Animation {
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
            },
            interval = 0.05
        }
    }

    self.animation = self.animations['idle']

    self.behaviors = {
        ['idle'] = function(dt)
            if self.map.player.x + self.map.player.width > self.x + self.width / 2 and 
                self.map.player.x < self.x + self.width / 2 and self.map.player.y >= self.y - self.height / 2 then
                    self.map.player.dx = 0
                    self.map.player.state = 'idle'
                    self.map.player.animation = self.map.player.animations['idle']
                    self.map.player.y = self.y - self.height / 2
                    if love.keyboard.wasPressed('space') then
                        self.map.player.dy = -JUMP_VELOCITY * 2
                        self.animation = self.animations['jump']
                        self.state = 'jump'
                        self.map.player.state = 'jumping'
                        self.map.player.animation = self.map.player.animations['jumping']
                        self.sound:play()
                    end
            end
            if (self.map.player.x >= self.x and self.map.player.x < self.x + self.width or 
                self.map.player.x + self.map.player.width >= self.x and self.map.player.x + self.map.player.width - 2 < self.x + self.width) and
                    self.map.player.y + self.map.player.height <= self.y and 
                        self.map.player.y + self.map.player.height > self.y - self.map.tileHeight / 3 then
                            self.map.player.dy = -JUMP_VELOCITY * 2
                            self.animation = self.animations['jump']
                            self.state = 'jump'
                            self.map.player.state = 'jumping'
                            self.map.player.animation = self.map.player.animations['jumping']
                            self.sound:play()
            end
        end,
        ['jump'] = function(dt)
            -- Makes sure that the animation plays till the 'end' and then, goes to idle
            if self.animation.currentFrame > 7 and 
                self.map.player.y + self.map.player.height <= self.y + self.map.tileHeight / 2 then
                    self.state = 'idle'
                    self.animation = self.animations['idle']
            end
        end
    }
end

function Trampoline:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
end

function Trampoline:render()
    love.graphics.draw(self.texture, self.animation:getCurrentFrame(), 
        math.floor(self.x + self.width / 2), math.floor(self.y + self.height / 2), 
            0, scaleX, 1, self.width / 2, self.height / 2)
end