maxx, maxy = love.window.getDesktopDimensions()
function love.load()
    love.window.setMode(maxx, maxy, {resizable=true, vsync=true, minwidth=400, minheight=300})
end
local tmpx, tmpy = love.window.getMode()
local density = 1
local wavedist = 7
local speed = 0.05
local wave = 0
local cubes = {}
local movespeed = 0.5
local sqrsize = 20
local defx, defy = 800, 600
function love.draw()
	--love.graphics.polygon('fill', 100, 100, 200, 100, 150, 200)
	for k, v in pairs(cubes) do
		if v.y == 600 then
			cubes[k] = nil
		else
			local delta = (math.sin(wave + v.channel) * wavedist)
			love.graphics.rectangle("fill", v.x + delta, v.y, v.size, v.size)
			v.y = v.y + movespeed
		end
	end
	wave = wave + speed
	love.graphics.print(tostring(love.timer.getFPS()))
end

function love.resize(W, H)
	tmpx, tmpy = W, H
end

function love.keypressed(Key, Scancode, Isrepeat)
	if Key == "w" then
		posy = posy - 1 * movespeed
	elseif Key == "s" then
		posy = posy + 1 * movespeed
	elseif Key == "a" then
		posx = posx - 1 * movespeed
	elseif Key == "d" then
		posx = posx + 1 * movespeed
	end
end

function love.update()
	for i = 1, density do
		cubes[table.getn(cubes) + 1] = {x = math.random(-10, tmpx + 10), y = 0, size = math.random(3,15), channel = math.random(1, 5)}
	end
end
