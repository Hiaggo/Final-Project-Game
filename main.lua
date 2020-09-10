Class = require 'class'
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 864
VIRTUAL_HEIGHT = 486

gameState = 'play'

level = 'first'

require 'Map'
require 'Player'
require 'Animation'

map = Map()

math.randomseed(os.time())

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()

    winningMessage = love.graphics.newFont('fonts/04B_03__.TTF', 24)
    repeatMessage = love.graphics.newFont('fonts/04B_03__.TTF', 16)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    love.window.setTitle('Cherry Americana')

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
end



function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' and gameState ~= 'menu' then
        love.event.quit()  
    end
    love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

function love.update(dt)

    if gameState == 'play' then    
        map:update(dt)
    end

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
end

function love.draw()
    push:apply('start') -- Begins virtual resolution

    if gameState == 'play' then

        love.graphics.clear(63 / 255, 61 / 255, 48 / 255, 255 / 255)
        map:render() -- Renders map object onto the screen

    elseif gameState == 'end' and level == 'first' then     
        love.graphics.setFont(winningMessage)
        love.graphics.printf("You have beaten the first level!", 0, 50, VIRTUAL_WIDTH, 'center')    
        love.graphics.setFont(repeatMessage)
        love.graphics.printf("Press Enter to play the next level", 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(winningMessage)
        map.music:stop()
        map.player.sounds['jump']:stop()
        map.player.sounds['hit']:stop()
        if love.keyboard.isDown('return') then
            map.player.health = 10
            level = 'second'
            map.player.sounds['clear']:stop()
            map:init()
            gameState = 'play'
        end

    elseif gameState == 'end' and level == 'second' then     
        love.graphics.setFont(winningMessage)
        love.graphics.printf("You have beaten the game!", 0, 50, VIRTUAL_WIDTH, 'center')    
        love.graphics.setFont(repeatMessage)
        love.graphics.printf("Press Enter to play again", 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(winningMessage)
        map.music:stop()
        map.player.sounds['jump']:stop()
        map.player.sounds['hit']:stop()
        if love.keyboard.isDown('return') then
            map.player.health = 10
            level = 'first'
            map.player.sounds['clear']:stop()
            map:init()
            gameState = 'play'
        end
    
    elseif gameState == 'lose' then
        love.graphics.setFont(winningMessage)
        love.graphics.printf("YOU DIED!", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(repeatMessage)
        love.graphics.printf("Press Enter to play again", 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(winningMessage)
        map.music:stop()
        map.player.sounds['jump']:stop()
        map.player.sounds['hit']:stop()
        if love.keyboard.isDown('return') then
            map.player.health = 10
            map.player.sounds['death']:stop()
            map:init()
            gameState = 'play'
        end
    end
    
    push:apply('end') -- Ends virtual resolution
end