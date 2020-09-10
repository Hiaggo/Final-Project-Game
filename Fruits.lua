Fruits = Class{}

require 'Animation'

function Fruits:init(map)

    self.width = 32
    self.height = 32
    
    self.map = map
    
    self.texture = love.graphics.newImage('graphics/fruits.png')
    self.frames = generateQuads(self.texture, self.width, self.height)

    self.sound = love.audio.newSource('sounds/coin.wav', 'static')
 
    self.sound:setVolume(0.005)
    
    self.animations = {
        ['collected'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[18],
                self.frames[19],
                self.frames[20],
                self.frames[21],
                self.frames[22],
                self.frames[23]
            },
            interval = 0.05
        },
        ['idle'] = Animation {
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
                self.frames[14],
                self.frames[15],
                self.frames[16],
                self.frames[17]
            },
            interval = 0.05
        }
    }

    self.state = 'idle'
    self.animation = self.animations['idle']

    self.behaviors = {
        ['idle'] = function(dt)
            if self.map.player.x + self.map.player.width > self.x and self.map.player.x < self.x + self.width and ((self.map.player.y >= self.y and
                self.map.player.y < self.y + self.width) or (self.map.player.y + self.map.player.width >= self.y and self.map.player.y < self.y))  then
                    self.state = 'collected'
                    self.sound:play()
            end
        end,
        ['collected'] = function(dt)
            self.animation = self.animations['collected']
            if self.animation.currentFrame > 5 then    
                self.map:collect(self)
            end
        end
    }

end

function Fruits:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
end

function Fruits:render()
    love.graphics.draw(self.texture, self.animation:getCurrentFrame(), 
        math.floor(self.x + self.width / 2), math.floor(self.y + self.height / 2), 
            0, scaleX, 1, self.width / 2, self.height / 2)
end