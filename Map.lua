require 'Util'

require 'Player'

require 'Animation'

require 'Enemy'

require 'Fruits'

require 'Saw'

require 'Trampoline'

require 'SpikeHead'

Map = Class{}

TILE_GRASS_TOP_1 = 7
TILE_GRASS_TOP_2 = 8
TILE_GRASS_TOP_3 = 9
TILE_GRASS_MIDDLE_1 = 29
TILE_GRASS_MIDDLE_2 = 30
TILE_GRASS_MIDDLE_3 = 31

TILE_BRICK_1 = 128
TILE_BRICK_2 = 129
TILE_BRICK_3 = 130

TILE_BLOCK_STONE = 123

TILE_BLOCK_STONE_1 = 124
TILE_BLOCK_STONE_2 = 125
TILE_BLOCK_STONE_3 = 146
TILE_BLOCK_STONE_4 = 147

TILE_BLOCKH_STONE_1 = 101
TILE_BLOCKH_STONE_2 = 102
TILE_BLOCKH_STONE_3 = 103

TILE_EMPTY = 6


TILE_CORNER_STONE_1 = 4
TILE_CORNER_STONE_2 = 5
TILE_CORNER_STONE_3 = 26
TILE_CORNER_STONE_4 = 27

TILE_HORIZONTAL_STONE_1 = 46
TILE_HORIZONTAL_STONE_2 = 2

TILE_VERTICAL_STONE_1 = 25
TILE_VERTICAL_STONE_2 = 23


TILE_CORNER_WOOD_1 = 92
TILE_CORNER_WOOD_2 = 93
TILE_CORNER_WOOD_3 = 114
TILE_CORNER_WOOD_4 = 115

TILE_HORIZONTAL_WOOD_1 = 134
TILE_HORIZONTAL_WOOD_2 = 90

TILE_VERTICAL_WOOD_1 = 113
TILE_VERTICAL_WOOD_2 = 111


TILE_CORNER_CRYSTAL_1 = 180
TILE_CORNER_CRYSTAL_2 = 181
TILE_CORNER_CRYSTAL_3 = 202
TILE_CORNER_CRYSTAL_4 = 203

TILE_HORIZONTAL_CRYSTAL_1 = 222
TILE_HORIZONTAL_CRYSTAL_2 = 178

TILE_VERTICAL_CRYSTAL_1 = 201
TILE_VERTICAL_CRYSTAL_2 = 199


function Map:init()

    self.music = love.audio.newSource('music/Soundtrack.wav', 'static')
    self.spritesheet = love.graphics.newImage('graphics/Terrain (16x16).png')
    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 54
    self.mapHeight = 30
    self.tiles = { }

    self.gravity = 15

    self.player = Player(self)
    
    self.trampoline = Trampoline(self)

    
    if level == 'first' then

        self.spikehead_1 = SpikeHead('horizontal', 35, 17, self)

        self.fruits = {
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self)
        }

        self.player.x = self.tileWidth 
        self.player.y = self.tileHeight * (24) - self.player.height

        self.enemy = {
            Enemy(self),
            Enemy(self)
        }

        self.saw = {
            Saw(24, 21, self),
            Saw(18, 15, self),
            Saw(11, 5, self)
        }
        
        self.saw[1].x = self.tileWidth * 4
        self.saw[1].y = self.tileHeight * (24) - self.saw[1].height

        self.saw[2].x = self.tileWidth * 4
        self.saw[2].y = self.tileHeight * (17) - self.saw[2].height

        self.saw[3].x = self.tileWidth * 6
        self.saw[3].y = self.tileHeight * (5) - self.saw[3].height


        self.trampoline.x = self.tileWidth * 14
        self.trampoline.y = self.tileHeight * (24) - self.trampoline.height


        self.spikehead_1.x = self.tileWidth * 20
        self.spikehead_1.y = self.tileHeight * 26 - self.spikehead_1.height / 2


        self.fruits[1].x = self.tileWidth * 17
        self.fruits[1].y = self.tileHeight * 26

        self.fruits[2].x = self.tileWidth * 20
        self.fruits[2].y = self.tileHeight * 26

        self.fruits[3].x = self.tileWidth * 23
        self.fruits[3].y = self.tileHeight * 26

        self.fruits[4].x = self.tileWidth * 26
        self.fruits[4].y = self.tileHeight * 26

        self.fruits[5].x = self.tileWidth * 29
        self.fruits[5].y = self.tileHeight * 26

        self.fruits[6].x = self.tileWidth * 32
        self.fruits[6].y = self.tileHeight * 26

        self.fruits[7].x = self.tileWidth * 20
        self.fruits[7].y = self.tileHeight * 5

        self.fruits[8].x = self.tileWidth * 26
        self.fruits[8].y = self.tileHeight * 5

        self.fruits[9].x = self.tileWidth * 4
        self.fruits[9].y = self.tileHeight * 3

        self.fruits[10].x = self.tileWidth * 2
        self.fruits[10].y = self.tileHeight * 9

        self.fruits[11].x = self.tileWidth * 40
        self.fruits[11].y = self.tileHeight * 17

        self.fruits[12].x = self.tileWidth * 33
        self.fruits[12].y = self.tileHeight * 12

        self.fruits[13].x = self.tileWidth * 45
        self.fruits[13].y = self.tileHeight * 17


        self.enemy[1].x = self.tileWidth * 48
        self.enemy[1].y = self.tileHeight * (self.mapHeight - 11) - 34
        self.enemy[2].x = self.tileWidth * 26
        self.enemy[2].y = self.tileHeight * (self.mapHeight - 17) - 34

    end

    if level == 'second' then

        self.spikehead_2 = SpikeHead('horizontal', 52, 1, self)
        
        self.spikehead_2.x = self.tileWidth * 20
        self.spikehead_2.y = self.tileHeight * 24 - self.spikehead_2.height / 2

        self.spikehead_3 = {
            SpikeHead('vertical', 13, 1, self),
            SpikeHead('vertical', 13, 1, self),
            SpikeHead('vertical', 13, 1, self),
            SpikeHead('vertical', 13, 1, self),
            SpikeHead('vertical', 13, 1, self)
        }

        self.spikehead_3[1].x = self.tileWidth * 3 + self.spikehead_3[1].width / 4
        self.spikehead_3[1].y = self.tileHeight * 5 - self.spikehead_3[1].height / 2

        self.spikehead_3[2].x = self.tileWidth * 12 + self.spikehead_3[1].width / 4
        self.spikehead_3[2].y = self.tileHeight * 5 - self.spikehead_3[1].height / 2

        self.spikehead_3[3].x = self.tileWidth * 21 + self.spikehead_3[1].width / 4
        self.spikehead_3[3].y = self.tileHeight * 5 - self.spikehead_3[1].height / 2

        self.spikehead_3[4].x = self.tileWidth * 30 + self.spikehead_3[1].width / 4
        self.spikehead_3[4].y = self.tileHeight * 5 - self.spikehead_3[1].height / 2

        self.spikehead_3[5].x = self.tileWidth * 39 + self.spikehead_3[1].width / 4
        self.spikehead_3[5].y = self.tileHeight * 5 - self.spikehead_3[1].height / 2
        
        self.fruits = {
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self),
            Fruits(self)
        }

        self.fruits[11].x = self.tileWidth * (5) - self.fruits[1].width / 5
        self.fruits[11].y = self.tileHeight * (3)

        self.fruits[12].x = self.tileWidth * (14) - self.fruits[1].width / 5
        self.fruits[12].y = self.tileHeight * (3)

        self.fruits[13].x = self.tileWidth * (23) - self.fruits[1].width / 5
        self.fruits[13].y = self.tileHeight * (3)

        self.fruits[14].x = self.tileWidth * (32) - self.fruits[1].width / 5
        self.fruits[14].y = self.tileHeight * (3)

        self.fruits[15].x = self.tileWidth * (41) - self.fruits[1].width / 5 
        self.fruits[15].y = self.tileHeight * (3)

        self.player.x = self.tileWidth * (52) - self.player.width
        self.player.y = self.tileHeight * (9) - self.player.height
        self.player.direction = 'left'

        self.saw = {
            Saw(26, 15, self),
            Saw(26, 15, self),
            Saw(26, 15, self),
            Saw(26, 15, self),
            Saw(26, 15, self),
            Saw(26, 15, self),
            Saw(26, 15, self),
            Saw(26, 15, self),
            Saw(26, 15, self),
            Saw(26, 15, self)
        }
        
        self.saw[10].x = self.tileWidth * (4) + 7
        self.saw[10].y = self.tileHeight * (24) - self.saw[1].height

        self.saw[9].x = self.tileWidth * (9) + 7
        self.saw[9].y = self.tileHeight * (23) - self.saw[2].height

        self.saw[8].x = self.tileWidth * (14) + 7
        self.saw[8].y = self.tileHeight * (22) - self.saw[3].height

        self.saw[7].x = self.tileWidth * (19) + 7
        self.saw[7].y = self.tileHeight * (21) - self.saw[3].height

        self.saw[6].x = self.tileWidth * (24) + 7
        self.saw[6].y = self.tileHeight * (20) - self.saw[3].height

        self.saw[5].x = self.tileWidth * (29) + 7
        self.saw[5].y = self.tileHeight * (19) - self.saw[3].height

        self.saw[4].x = self.tileWidth * (34) + 7
        self.saw[4].y = self.tileHeight * (18) - self.saw[3].height

        self.saw[3].x = self.tileWidth * (39) + 7
        self.saw[3].y = self.tileHeight * (17) - self.saw[3].height

        self.saw[2].x = self.tileWidth * (44) + 7
        self.saw[2].y = self.tileHeight * (16) - self.saw[3].height

        self.saw[1].x = self.tileWidth * (49) + 7
        self.saw[1].y = self.tileHeight * (15) - self.saw[3].height

    end

    -- Generate a quad (individual frame/sprite) for each tile
    self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)
    
    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight

    -- Draws all the tiles of the environment, possibly in the least smart way
    i = 1
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if level == 'first' then
                if y == 1 then
                    if x == 1 then
                        self:setTile(x, y, TILE_CORNER_STONE_1)
                    elseif x == self.mapWidth then
                        self:setTile(x, y, TILE_CORNER_STONE_2)
                    else
                        self:setTile(x, y, TILE_HORIZONTAL_STONE_1)
                    end

                elseif y == self.mapHeight then
                    if x == 1 then
                        self:setTile(x, y, TILE_CORNER_CRYSTAL_3)
                    elseif x == self.mapWidth then
                        self:setTile(x, y, TILE_CORNER_CRYSTAL_4)
                    else
                        self:setTile(x, y, TILE_HORIZONTAL_CRYSTAL_2)
                    end

                elseif y~= 1 and y ~= self.mapHeight and x == 1 then
                    self:setTile(x, y, TILE_VERTICAL_STONE_1)

                elseif y~= 1 and y ~= self.mapHeight and x == self.mapWidth then
                    self:setTile(x, y, TILE_VERTICAL_CRYSTAL_2)  
                    
                elseif y < self.mapHeight and y > self.mapHeight - self.mapHeight / 4 + 2 and 
                    x > 1 and x < self.mapWidth / 3 then
                        if y >= self.mapHeight - self.mapHeight / 4 + 3 then
                            if x == 2 then
                                self:setTile(x, y, TILE_GRASS_MIDDLE_1)
                            elseif x == self.mapWidth / 3 - 1 and y ~= self.mapHeight - 1 then
                                self:setTile(x, y, TILE_GRASS_MIDDLE_3)
                            elseif x == self.mapWidth / 3 - 1 and y == self.mapHeight - 1 then
                                self:setTile(x, y, TILE_GRASS_TOP_1)
                            else
                                self:setTile(x, y, TILE_GRASS_MIDDLE_2)
                            end
                        else
                            if x == 2 then
                                self:setTile(x, y, TILE_GRASS_TOP_1)
                            elseif x == self.mapWidth / 3 - 1 then
                                self:setTile(x, y, TILE_GRASS_TOP_3)
                            else
                                self:setTile(x, y, TILE_GRASS_TOP_2)
                            end
                        end

                elseif y == 6 and x < 9 and x > 3 then
                    if x == 4 then
                        self:setTile(x, y, TILE_BLOCKH_STONE_1)
                    elseif x == 8 then
                        self:setTile(x, y, TILE_BLOCKH_STONE_3)
                    else
                        self:setTile(x, y, TILE_BLOCKH_STONE_2)
                    end

                elseif y == 12 and x < 8 and x > 1 then
                    if x == 2 then
                        self:setTile(x, y, TILE_BLOCKH_STONE_1)
                    elseif x == 7 then
                        self:setTile(x, y, TILE_BLOCKH_STONE_3)
                    else
                        self:setTile(x, y, TILE_BLOCKH_STONE_2)
                    end

                elseif y > self.mapHeight / 2 + 4 and y < self.mapHeight
                    and x > self.mapWidth - self.mapWidth / 3 and x < self.mapWidth then
                        if x == self.mapWidth - self.mapWidth / 3 + 1 then
                            self:setTile(x, y, TILE_BRICK_1)
                        elseif x == self.mapWidth - 1 then
                            self:setTile(x, y, TILE_BRICK_3)
                        else
                            self:setTile(x, y, TILE_BRICK_2)
                        end

                elseif y == self.mapHeight - 2 and x == self.mapWidth - self.mapWidth / 3 then
                    self:setTile(x - 1, y, TILE_BLOCKH_STONE_1)
                    self:setTile(x, y, TILE_BLOCKH_STONE_3)

                elseif y == self.mapHeight - 1 and x == self.mapWidth - self.mapWidth / 3 then
                    self:setTile(x, y, TILE_BLOCK_STONE)

                elseif y == self.mapHeight - 1 and x < self.mapWidth - self.mapWidth / 3 
                    and x >= self.mapWidth / 3 then
                        self:setTile(x, y, TILE_GRASS_TOP_2)

                elseif y == 24 and x < 7 and x > 4 then
                    if x == 5 then
                        self:setTile(x, y, TILE_BLOCK_STONE_3)
                        self:setTile(x, y - 1, TILE_BLOCK_STONE_1)
                    else
                        self:setTile(x, y, TILE_BLOCK_STONE_4)
                        self:setTile(x, y - 1, TILE_BLOCK_STONE_2)
                        self:setTile(x, y - 2, TILE_BLOCK_STONE)
                    end

                elseif y == 14 and x <= self.mapWidth / 3 + 10 and x > self.mapWidth / 3 + 1 then
                    if x == self.mapWidth / 3 + 2 then
                        self:setTile(x, y, TILE_BLOCKH_STONE_1)
                    elseif x == self.mapWidth / 3 + 10 then
                        self:setTile(x, y, TILE_BLOCKH_STONE_3)
                    else
                        self:setTile(x, y, TILE_BLOCKH_STONE_2)
                    end
                
                else
                    self:setTile(x, y, TILE_EMPTY)
                end
            end

            if level == 'second' then
                if y == 1 then
                    if x == 1 then
                        self:setTile(x, y, TILE_CORNER_WOOD_1)
                    elseif x == self.mapWidth then
                        self:setTile(x, y, TILE_CORNER_WOOD_2)
                    else
                        self:setTile(x, y, TILE_HORIZONTAL_STONE_1)
                    end

                elseif y == self.mapHeight then
                    if x == 1 then
                        self:setTile(x, y, TILE_CORNER_WOOD_3)
                    elseif x == self.mapWidth then
                        self:setTile(x, y, TILE_CORNER_WOOD_4)
                    else
                        self:setTile(x, y, TILE_HORIZONTAL_STONE_2)
                    end

                elseif y~= 1 and y ~= self.mapHeight and x == 1 then
                    self:setTile(x, y, TILE_VERTICAL_WOOD_1)

                elseif y~= 1 and y ~= self.mapHeight and x == self.mapWidth then
                    self:setTile(x, y, TILE_VERTICAL_WOOD_2)  
                    
                elseif y == self.mapHeight - 3 and x < self.mapWidth
                    and x > 3 and x % 5 == 1 then
                        self:setTile(x, y, TILE_GRASS_TOP_2)
                        if i <= 10 then
                            self.fruits[i].x = (x - 1) * self.tileWidth - 8
                            self.fruits[i].y = y * self.tileHeight - self.fruits[i].height - 10
                            i = i + 1
                        end
                
                elseif y == self.mapHeight - 2 and x < self.mapWidth
                    and x > 3 and x % 5 == 1 then
                        self:setTile(x, y, TILE_GRASS_MIDDLE_2)

                elseif y == self.mapHeight - 1 and x < self.mapWidth
                    and x > 1 and x % 5 ~= 1 then
                        self:setTile(x, y, TILE_GRASS_TOP_2)

                elseif y == self.mapHeight - 1 and x < self.mapWidth
                    and x > 1 and x % 5 == 1 then
                        self:setTile(x, y, TILE_GRASS_MIDDLE_2)
                
                elseif y == 10 then
                    if x == 8 or x == 17 or x == 26 or x == 35 or x == 44 then
                        self:setTile(x, y, TILE_BLOCKH_STONE_1)
                    elseif x == self.mapWidth - 1 or x == 40 or x == 31 or x == 22 or x == 13 then
                        self:setTile(x, y, TILE_BLOCKH_STONE_3)
                    elseif x > 5 and x ~= 5 and x ~= 6 and x ~= 7 and x ~= 14 and x ~= 15 and x ~= 16 and
                        x ~= 23 and x ~= 24 and x ~= 25 and x ~= 32 and x ~= 33 and x ~= 34 and
                            x ~= 41 and x ~= 42 and x ~= 43 then
                                self:setTile(x, y, TILE_BLOCKH_STONE_2)
                    else
                        self:setTile(x, y, TILE_EMPTY)
                    end

                else
                    self:setTile(x, y, TILE_EMPTY)
                end
            end
        end
    end

    -- start the background music
    self.music:setLooping(true)
    self.music:setVolume(0.05)
    self.music:play()
end

function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1, math.floor(y / self.tileHeight) + 1)
    }
end

function Map:setTile(x, y, tile)
    self.tiles[(y - 1) * self.mapWidth + x] = tile
end

function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

function Map:destroy(dummy)
    for i = 1, #self.enemy do
        if self.enemy[i] == dummy then
            table.remove(self.enemy, i)
        end
    end
end

function Map:collect(fruit)
    for i = 1, #self.fruits do
        if self.fruits[i] == fruit then
            table.remove(self.fruits, i)
        end
    end
    if #self.fruits < 1 then
        self.player.sounds['clear']:play()
        self.player.sounds['clear']:setVolume(0.05)
        gameState = 'end'
    end
end

function Map:whoIsNear()
    local distance = self.mapWidth
    local dummy
    local temp
    for _, v in ipairs(self.enemy) do
        temp = v.x - self.player.x
        if temp < 0 then
            temp = temp * -1
        end
        if distance > temp then
            dummy = v
            distance = temp
        end
    end
    return dummy
end 

function Map:climbs(tile)
    local climbable = {
        
    }

    for _, v in ipairs(climbable) do
        if tile.id == v then
            return true
        end
    end

    return false
end

function Map:collides(tile)
    -- Definition of collidable tiles
    local collidables = {
        TILE_HORIZONTAL_STONE_2, TILE_VERTICAL_STONE_1,
        TILE_VERTICAL_STONE_2, TILE_HORIZONTAL_STONE_1,
        TILE_HORIZONTAL_WOOD_1, TILE_HORIZONTAL_WOOD_2, 
        TILE_VERTICAL_WOOD_1, TILE_VERTICAL_WOOD_2,
        TILE_HORIZONTAL_CRYSTAL_1, TILE_HORIZONTAL_CRYSTAL_2,
        TILE_VERTICAL_CRYSTAL_1, TILE_VERTICAL_CRYSTAL_2,
        TILE_GRASS_MIDDLE_1, TILE_GRASS_MIDDLE_2, TILE_GRASS_MIDDLE_3, TILE_GRASS_TOP_1,
        TILE_GRASS_TOP_2, TILE_GRASS_TOP_3, TILE_BRICK_1, TILE_BRICK_2,
        TILE_BRICK_3, TILE_BLOCKH_STONE_1, TILE_BLOCKH_STONE_2,
        TILE_BLOCKH_STONE_1, TILE_BLOCK_STONE_1, TILE_BLOCK_STONE_2,
        TILE_BLOCK_STONE_3, TILE_BLOCK_STONE_4
    }

    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end

function Map:update(dt)
    self.player:update(dt)
    if level == 'first' then
        self.trampoline:update(dt)
        self.spikehead_1:update(dt)      
        for _, s in ipairs(self.enemy) do
            s:update(dt)
        end
    else
        self.spikehead_2:update(dt)
        for _, s in ipairs(self.spikehead_3) do
            s:update(dt)
        end
    end
    for _, f in ipairs(self.fruits) do
        f:update(dt)
    end
    for _, v in ipairs(self.saw) do
        v:update(dt)
    end
end

function Map:render()
    for _, s in ipairs(self.saw) do
        s:render()
    end

    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            local tile = self:getTile(x, y)
            if tile ~= TILE_EMPTY and self:getTile(x, y) ~= nil then
                love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)],
                    (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
            end
        end
    end
    if gameState == 'play' then
        self.player:render()
        if level == 'first' then
            self.trampoline:render()
            self.spikehead_1:render()
            for _, v in ipairs(self.enemy) do
                v:render()
            end
        else
            self.spikehead_2:render(dt)
            for _, s in ipairs(self.spikehead_3) do
                s:render()
            end
        end
        for _, f in ipairs(self.fruits) do
            f:render()
        end
    end
end