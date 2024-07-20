local Player = require('player')
local Pipe = require('pipe')

local width = 1280
local height = 720

local timer = 0
local score = 0

local pipes = {}

function rectangle_collision(r1, r2)
    return not (
        r1[1] + r1[3] < r2[1] or
        r1[1] > r2[1] + r2[3] or
        r1[2] + r1[4] < r2[2] or
        r1[2] > r2[2] + r2[4]
    )
end

function setup_window()
     love.window.setMode(width, height, {
        resizable = false,  -- Window is not resizable
        vsync = true,       -- Enable vertical sync
        fullscreen = false  -- Do not start in fullscreen
    })
    
    love.graphics.setBackgroundColor(0.678, 0.847, 0.902)
    love.window.setTitle("Flappy Bird")
end

function love.load()
    -- Comments :D
    setup_window()

    -- Text stuff (disable antialiasing)
    local fontSize = 32
    font = love.graphics.newFont(fontSize, "mono")
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    -- Player
    player = Player:new((width * 0.5) - 24, (height * 0.5) - 24)
end

function love.update(dt)

    player:move(dt)

    -- Pipes timer
    timer = timer + dt
    if timer >= 3 then
        timer = 0
        local new_pipe = Pipe:new(1280)
        table.insert(pipes, new_pipe)
    end

    -- Update pipes iterating in reverse order so not to change indexes
    for i = #pipes, 1, -1 do
        pipes[i]:move(dt)

        local pipe = pipes[i]
        -- Top
        if rectangle_collision({player.x, player.y, 48, 48}, {pipe.x, pipe.top[1], pipe.width, pipe.top[2]}) then
            player.alive = false
        end

        -- Bottom
        if rectangle_collision({player.x, player.y, 48, 48}, {pipe.x, pipe.btm[1], pipe.width, pipe.btm[2]}) then
            player.alive = false
        end

        -- Score line
        if rectangle_collision({player.x + (48 * 0.5), player.y, 2, 48}, {pipe.x + (pipe.width * 0.5), pipe.top[2], 1, pipe.btm[1]-(pipe.top[1] + pipe.top[2])}) then
            score = score + 1
        end

        -- Delete pipe
        if pipe.x < -pipe.width then
            table.remove(pipes, 1)
        end
    end
end

function love.draw(dt)  
    player:render()

    -- Render pipes
    for i = 1, #pipes do
        pipes[i]:render()
        -- local pipe = pipes[i]
        -- love.graphics.rectangle("fill", pipe.x + (pipe.width * 0.5), pipe.top[2], 2, pipe.btm[1]-(pipe.top[1] + pipe.top[2]))
    end

    love.graphics.print("Score: " .. score, 16, 16)
end

function love.keypressed(key)
    -- Detect if the Escape key is pressed
    if key == "escape" then
        love.event.quit()  -- Close the window
    end
    if key == "space" then
        player.velocity = -player.jump_height
    end
end