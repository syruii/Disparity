-- Current coordinate system for images, imgx imgy are center of image

-- Player, mode either black and white, affects absorption and bullet fired
player = {x = 100, y= 100, speed = 100, img = nil, mode = "white"};

-- Timers
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

-- Image Storage
bulletImg = nil

-- Player Bullets
playerBullets = {}

function love.load()
	player_white = love.graphics.newImage("red_arrow_w.png")
	player_black = love.graphics.newImage("red_arrow_b.png")
	player_bullet_black = love.graphics.newImage("bullet_b.png")
	player_bullet_white = love.graphics.newImage("bullet_w.png")
	player.img = player_white
	love.graphics.setBackgroundColor(177,192,196)
end

function love.draw(dt)
	love.graphics.draw(player.img, player.x, player.y)
	for i, bullet in ipairs(playerBullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y)
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

		if bullet.y < - bullet.img:getHeight()/2 then -- remove bullets when they pass off the screen
			table.remove(playerBullets, i)
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