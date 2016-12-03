function love.load()
	--[[
	CHANGES:
	-Changed meter/pixel into a more realistic number (15/1)
	]]--
	world = love.physics.newWorld(0, 0, true)
	love.physics.setMeter(15)

	player = {
		body = love.physics.newBody(world, 0, 0, "dynamic"),
		shape = love.physics.newCircleShape(15),
	}

	objects = {
		wall = {
			body = love.physics.newBody(world, 100, 100, "dynamic"),
			shape = love.physics.newRectangleShape(100, 100, 50, 200),
		}
	}

	player.fixture = love.physics.newFixture(player.body, player.shape, 1)
	objects.wall.fixture = love.physics.newFixture(objects.wall.body, objects.wall.shape, 1)

	posx, posy = 0, 0
	love.window.setMode(1000, 1000, {resizable = true, msaa = 4, vsync = false})
	wX, wY = love.window.getMode()
	wXh, wYh = wX / 2, wY / 2
	mapTileResolution = 500
	mapTileHalf = mapTileResolution / 2
	mapTileRenderDistX = wXh
	mapTileRenderDistY = wYh
	physicsRate = 1 / 60
	love.graphics.setNewFont(72)
	love.keyboard.setKeyRepeat(true)
	Dtt = 0
	movex, movey = false, false

	function subtractPos(Tbl)
		local argtype = "x"
		local returntbl = {}
		for k, v in ipairs(Tbl) do
			if argtype == "x" then
				returntbl[#returntbl + 1] = v - posx
				argtype = "y"
			else
				returntbl[#returntbl + 1] = v - posy
				argtype = "x"
			end
		end
		return unpack(returntbl)
	end

	function isNear(X, Y)
		if X > posx + mapTileRenderDistX or X < posx - mapTileRenderDistX - mapTileResolution or Y > posy + mapTileRenderDistY or Y < posy - mapTileRenderDistY - mapTileResolution then
			return false
		else
			return true
		end
	end

	map = {}
	for i = 0, 9 do
		map[i] = {}
		for  n = 0, 9 do
			map[i][n] = love.graphics.newImage("map2/map2-0"..tostring(n).."-0"..tostring(i)..".png")
		end
	end
	movespeed = 15000
end

function love.draw()
	love.graphics.translate(wXh, wYh)
	for k, v in pairs(map) do
		for k2, v2 in pairs(v) do
			local imgx, imgy = k2 * mapTileResolution, k * mapTileResolution
			if isNear(imgx, imgy) then
				love.graphics.draw(v2, imgx - posx, imgy - posy)
			end
		end
	end
	posx, posy = player.body:getPosition()
	love.graphics.setColor(0, 255, 0)
	love.graphics.print(love.timer.getFPS(), -wXh, -wYh, 0, 0.25)
	love.graphics.setColor(193, 47, 14)
	love.graphics.circle("fill", player.body:getX() - posx, player.body:getY() - posy, player.shape:getRadius())
	love.graphics.setColor(50, 50, 50)
	local polytbl = {objects.wall.body:getWorldPoints(objects.wall.shape:getPoints())}
	love.graphics.polygon("fill", subtractPos(polytbl))
	love.graphics.setColor(255, 255, 255)
end

function love.resize(Nx, Ny)
	wX, wY = Nx, Ny
	wXh, wYh = wX / 2, wY / 2
	mapTileRenderDistX = wXh
	mapTileRenderDistY = wYh
end
function love.update(Dt)
	if Dtt > physicsRate then
		world:update(Dt)
		Dtt = 0

		if love.keyboard.isDown("w") then
			player.body:applyForce(0, -movespeed)
		elseif love.keyboard.isDown("s") then
			player.body:applyForce(0, movespeed)
		end
		if love.keyboard.isDown("a") then
			player.body:applyForce(-movespeed, 0 )
		elseif love.keyboard.isDown("d") then
			player.body:applyForce(movespeed, 0)
		end
	else
		Dtt = Dtt + Dt
	end
end

function love.keypressed(Key, Scancode, Repeat)
	if Key == "`" then
		local cmd, rest = string.match(io.read(), "(%S+) (.*)")
		if cmd == "setpos" then
			local param1, param2, param3 = string.match(rest, "(%S+) (%S+) (%S+)")
			if param1 == "self" then
				player.body:setPosition(param2, param3)
			else
				objects[param1].body:setPosition(param2, param3)
			end
		elseif cmd == "getpos" then
			local param1 = string.match(rest, "(%S+)")
			if param1 == "self" then
				print(player.body:getPosition())
			else
				print(objects[param1].body:getPosition())
			end
		elseif cmd == "getvel" then
			local param1 = string.match(rest, "(%S+)")
			if param1 == "self" then
				print(player.body:getLinearVelocity())
			else
				print(objects[param1].body:getLinearVelocity())
			end
		elseif cmd == "setvel" then
			local param1, param2, param3 = string.match(rest, "(%S+) (%S+) (%S+)")
			if param1 == "self" then
				player.body:setLinearVelocity(param2, param3)
			else
				objects[param1].body:setLinearVelocity(param2, param3)
			end
		end
	end
end
