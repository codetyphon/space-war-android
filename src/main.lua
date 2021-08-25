local checkCollision = require "checkCollision"
local player = {}
local enemys = {}
local foods = {}
local projectiles = {}
local time = 0
local score = 0
local gameover = false
width = 500
height = 800
local can_make_projectile = 0

function init()
    player.width = player_img:getWidth()
    player.height = player_img:getHeight()
    player.x = width / 2 - player.width / 2
    player.y = height - player.height
    player.vx = 0
    player.vy = 0
    player.speed = 300
    enemys = {}
    foods = {}
    projectiles = {}
    time = 0
    score = 0
    gameover = false
    bgaudio = love.audio.newSource("assets/bg.mp3", "static")
    love.audio.play(bgaudio)
    scoreText:set(score)
end

function make_a_enemy()
    local enemy = {}
    enemy.width = enemy_img:getWidth()
    enemy.height = enemy_img:getHeight()
    enemy.x = math.random(0, width - enemy.width)
    enemy.y = -200
    enemy.speed = 300
    table.insert(enemys, enemy)
end

function make_a_food()
    local food = {}
    food.x = math.random(100, 500)
    food.y = 0
    food.width = 50
    food.height = 50
    table.insert(foods, food)
end

function make_a_projectile()
    local projectile = {}
    projectile.width = projectile_img:getWidth()
    projectile.height = projectile_img:getHeight()
    projectile.x = player.x + player.width / 2 - projectile.width / 2
    projectile.y = player.y
    projectile.speed = 800
    table.insert(projectiles, projectile)
    audio = love.audio.newSource("assets/short.wav", "static")
    love.audio.play(audio)
end

function love.load()
    love.window.setMode(width, height, {fullscreen = false})
    -- width, height, flags = love.window.getMode()
    love.window.setTitle('Space War')
    local font = love.graphics.newFont(50, "mono", 10)
    gameoverText = love.graphics.newText(font, "Game Over")
    font2 = love.graphics.newFont(30, "mono", 10)
    restartText = love.graphics.newText(font2, "Touch to restart")
    local fontScore = love.graphics.newFont(20, "mono", 10)
    scoreText = love.graphics.newText(fontScore, score)
    player_img = love.graphics.newImage("assets/player.png")
    enemy_img = love.graphics.newImage("assets/enemy.png")
    projectile_img = love.graphics.newImage("assets/projectile.png")
    init()
end

function love.update(dt)
    if gameover == false then
        player.x = player.x + player.speed * player.vx * dt
        player.y = player.y + player.speed * player.vy * dt
        player.vx = 0
        player.vy = 0

        time = time + 1

        if time % 60 == 0 then make_a_enemy() end

        for i, v in ipairs(enemys) do
            v.y = v.y + v.speed * dt
            if checkCollision(player, v, 20, 30, 10, 10) then
                gameover = true
            end
        end

        for i, v in ipairs(foods) do v.y = v.y + 100 * dt end

        for i, v in ipairs(projectiles) do
            v.y = v.y - v.speed * dt
            for ii, vv in ipairs(enemys) do
                if checkCollision(v, vv, 5, 20, 0, 0) then
                    table.remove(projectiles, i)
                    table.remove(enemys, ii)
                    audio = love.audio.newSource("assets/pixel.wav", "static")
                    love.audio.play(audio)
                    score = score + 1
                    scoreText:set(score)
                end
            end
        end
    end
end

function love.draw()
    love.graphics.draw(player_img, player.x, player.y)
    for i, v in ipairs(enemys) do love.graphics.draw(enemy_img, v.x, v.y) end
    for i, v in ipairs(projectiles) do
        love.graphics.draw(projectile_img, v.x, v.y)
    end
    love.graphics.draw(scoreText, 20, 20)
    if gameover == true then
        love.graphics.draw(gameoverText,
                           width / 2 - gameoverText:getWidth() / 2,
                           height / 2 - gameoverText:getHeight() / 2)
        love.graphics.draw(restartText, width / 2 - restartText:getWidth() / 2,
                           height / 2 - gameoverText:getHeight() / 2 +
                               restartText:getHeight() * 2)
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        if gameover then
            init()
        else
            make_a_projectile()
        end
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if dx > 0 then player.vx = 1 end
    if dx < 0 then player.vx = -1 end
    if dy > 0 then player.vy = 1 end
    if dy < 0 then player.vy = -1 end
end

function love.resize(w, h)
    width = w
    height = h
    love.window.updateMode(width, height, {fullscreen = true})
    init()
end
