-- 2D Game Example in LÖVE (Love2D)
-- WINDOW --
    Win = {w = 800, h = 600 } 
-- GAME STATE --
    GameState = {
    current = "menu",
    menu = "menu",
    play = "play", 
    over = "over"
    }
-- PLAYER --
    Player = {}
    Player.x = 100
    Player.y = 200
    Player.height = 64
    Player.width = 64
    Player.speed = 200
    Player.color = {0, 1, 0}
    Player.maxSpeed = 300
-- COIN --
    Coins = {
    {x = 100, y = 200, radius = 25},
    {x = 400, y = 300, radius = 25},
    {x = 250, y = 100, radius = 25},
    }
-- SCORE --
    Score = {}
    Score.x = 0
    Score.y = 0
    Score.value = 0
    Score.font = love.graphics.newFont(32)
-- TIMER --
    Timer = {}
    Timer.x = Win.w - 150
    Timer.y = 0
    Timer.value = 60
    Timer.font = love.graphics.newFont(32)
    Timer.max = 120
-- LOAD --
function love.load ()
    if GameState.current == GameState.play then
        for i, Coin in ipairs(Coins) do
            Coin.x = math.random(Coin.radius, Win.w - Coin.radius)
            Coin.y = math.random(Coin.radius, Win.h - Coin.radius)
        end
    end
    love.window.setTitle("2D Game Example")
    love.window.setMode(Win.w, Win.h)
end
    
    -- UPDATE --
function love.update (dt)
    if GameState.current == GameState.play then
        for i, Coin in ipairs(Coins) do
            local ClosestX = math.max(Player.x, math.min(Coin.x, Player.x + Player.width))
            local ClosestY = math.max(Player.y, math.min(Coin.y, Player.y + Player.height))
            local dist = distance(Coin.x, Coin.y, ClosestX, ClosestY)
            if dist <= Coin.radius then
                Score.value = Score.value + 1 
                Timer.value = Timer.value + 0.5
                Player.speed = Player.speed + 5
                Coin.x = math.random(Coin.radius, Win.w - Coin.radius)
                Coin.y = math.random(Coin.radius, Win.h - Coin.radius)
            end
        end
        if love.keyboard.isDown("up") then 
            Player.y = Player.y - Player.speed * dt
        end
        if love.keyboard.isDown("down") then 
            Player.y = Player.y + Player.speed * dt
        end
        if love.keyboard.isDown("right") then 
            Player.x = Player.x + Player.speed * dt
        end
        if love.keyboard.isDown("left") then 
            Player.x = Player.x - Player.speed * dt
        end
        if Player.x < 0 then Player.x = 0 end
        if Player.y < 0 then Player.y = 0 end
        if Player.x + Player.width > Win.w then Player.x = Win.w - Player.width end
        if Player.y + Player.height > Win.h then Player.y = Win.h - Player.height end
        if Timer.value <= 0 then
            GameState.current = GameState.over
        end
        if Score.value >= 999 then
            Score.value = 999
        end
        if Timer.value >= Timer.max then
            Timer.value = Timer.max
        end
        if Player.speed >= Player.maxSpeed then
            Player.speed = Player.maxSpeed
        end
        Timer.value = Timer.value - dt
    end
end

-- KEY PRESSED --
function love.keypressed(key)
    if GameState.current == GameState.menu then
        if key == "return" then 
            GameState.current = GameState.play
        elseif key == "escape" then
            love.event.quit()
        end
    elseif GameState.current == GameState.play then
        if key == "escape" then
            GameState.current = GameState.over
        end
    elseif GameState.current == GameState.over then
        if key == "return" then
            GameState.current = GameState.play
        elseif key == "escape" then
            love.event.quit()
        end
    end
end

-- DISTANCE FUNC --
function distance (x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

-- DRAW --
function love.draw ()
    if GameState.current == GameState.menu then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(Score.font)
        love.graphics.print("Press Enter to Start \nPress ESC to Leave", 400/2, 500/2)
    elseif GameState.current == GameState.play then
        --RECTANGLE FOR PLAYER
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", Player.x, Player.y, Player.width, Player.height)
        --CIRCLE FOR COIN
        for i, Coin in ipairs(Coins) do
            love.graphics.setColor(1, 1, 0)
            love.graphics.circle("fill", Coin.x, Coin.y, Coin.radius)
        end
        --SCORE DISPLAY
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(Score.font)
        love.graphics.print("Score: " .. Score.value, Score.x, Score.y)
        --TIMER DISPLAY
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(Timer.font)
        love.graphics.print("Time: " .. math.floor(Timer.value), Timer.x, Timer.y)
    elseif GameState.current == GameState.over then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(Score.font)
        love.graphics.print("Game Over! \nFinal Score: " .. Score.value .. "\nPress Enter to Restart \nPress ESC to Leave", 300/2, 400/2)
    end
end