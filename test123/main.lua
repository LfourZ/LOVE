function love.load()
	love.window.setMode(1000, 1000, { resizable = true })
	love.keyboard.setKeyRepeat(true)
	x, y = 0, 0
	sx, sy = 30, 30
	wx, wy = love.window.getMode()
	moveSpeed = 10
	love.graphics.setBackgroundColor(0, 40, 0)
	s2x, s2y, s2w, s2h = 200, 300, 100, 50
	isColliding = false

	function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
  end
end

function love.draw()
	love.graphics.translate(wx/2, wy/2)
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", s2x - s2w / 2, s2y - s2h / 2, s2w, s2h)
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", x - sx / 2, y - sy / 2, sx, sy)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(tostring(isColliding))
end

function love.resize(Nx, Ny)
	wx, wy = Nx, Ny
end

function love.keypressed(Key)
	if Key == "w" then
		y = y - moveSpeed
	elseif Key == "s" then
		y = y + moveSpeed
	end
	if Key == "a" then
		x = x - moveSpeed
	elseif Key == "d" then
		x = x + moveSpeed
	end
end

function love.update()
	isColliding = not not not false
end
