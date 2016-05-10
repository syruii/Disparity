debug = true
local bump = require 'bump'

-- Player, mode either black and white, affects absorption and bullet fired
player = {x = 100, y= 100, speed = 100, img = nil, mode = "white"};
isAlive = true
score = 0

-- Timers
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax
createEnemyTimerMax = 1.5
createEnemyTimer = createEnemyTimerMax

-- Image Storage
player_white = nil
player_black = nil
player_bullet_black = nil
player_bullet_white = nil
enemy_b_b = nil
enemy_b_w = nil

-- Entity Storage
playerBullets = {}
enemies = {}
numEnemies = 0

local world = bump.newWorld(128)
local f

-- Main Love functions
function love.load()
	player_white = love.graphics.newImage("assets/red_arrow_w.png")
	player_black = love.graphics.newImage("assets/red_arrow_b.png")
	player_bullet_black = love.graphics.newImage("assets/bullet_b.png")
	player_bullet_white = love.graphics.newImage("assets/bullet_w.png")

	enemy_b_b = love.graphics.newImage("assets/blue_enemy_b.png")
	enemy_w_w = love.graphics.newImage("assets/blue_enemy_w.png")

	player.img = player_white
	love.graphics.setBackgroundColor(177,192,196)
end

function love.draw(dt)
	love.graphics.draw(player.img, player.x, player.y)
	for i, bullet in ipairs(playerBullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end
	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y)
	end
end

function love.update(dt)
	if love.keyboard.isDown("up") then
		player.y = player.y - 100 * dt
	elseif love.keyboard.isDown("down") then
		player.y = player.y + 100 * dt
	end
	if love.keyboard.isDown("left") then
		player.x = player.x - 100 * dt
	elseif love.keyboard.isDown("right") then
		player.x = player.x + 100 * dt
	end

	-- Time out how far apart our shots can be.
	canShootTimer = canShootTimer - (1 * dt)
	if canShootTimer < 0 then
		canShoot = true
	end

	if love.keyboard.isDown('z') and canShoot then
		-- Create some bullets
		if (player.mode == "white") then
			newBullet = { x = player.x , y = player.y, img = player_bullet_white }
		else
			newBullet = { x = player.x , y = player.y, img = player_bullet_black }
		end
		table.insert(playerBullets, newBullet)
		canShoot = false
		canShootTimer = canShootTimerMax
	end

	-- update the positions of bullets
	for i, bullet in ipairs(playerBullets) do
		bullet.y = bullet.y - (250 * dt)

		if bullet.y < - bullet.img:getHeight() then -- remove bullets when they pass off the screen
			table.remove(playerBullets, i)
		end
	end

	-- Time out enemy creation
	createEnemyTimer = createEnemyTimer - (1 * dt)
	if (createEnemyTimer < 0 and numEnemies < 3) then
		createEnemyTimer = createEnemyTimerMax

		-- create enemy
		randomNumber = math.random(enemy_b_b:getWidth() ,love.graphics.getWidth() - enemy_b_b:getWidth())
		-- getHeight function of texture class
		local enemyType = enemy_b_b
		if (math.random(0,1) == 0) then
			enemyType = enemy_b_w
		end
		newEnemy = {x = randomNumber, y = - enemy_b_b:getHeight(), img = enemyType}
		table.insert(enemies,newEnemy)
		numEnemies = numEnemies + 1
	end

	-- update enemy positions
	for i, enemy in ipairs(enemies) do
		enemy.y = enemy.y + (100 * dt)
		print(enemy.img)
		if enemy.y > love.graphics.getHeight() + (enemy.img:getHeight()/2) then
			table.remove(enemy, i)
			numEnemies = numEnemies - 1
		end
	end
end

function love.keypressed(key)
	if key == 'lshift' then
		if (player.mode == "white") then
			player.img = player_black
			player.mode = "black"
		else
			player.img = player_white
			player.mode = "white"
		end
	end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
