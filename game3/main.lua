function love.load()
	winw, winh = love.window.getMode()
	winh, winw = winh/2, winw/2
	ballpos = {x = 0, y = 0}
	ballvel = {x = math.random(1, 10), y = math.random(1, 10)}
	ballradius = 10
	bounce = -0.8
	stopvel = 0.05
	slowx, slowy = 0, 0
	stoplen = 30
	num = 0
	touchy, touchx = 0, 0
	touchstoplen = 100
	friction = 0.99
	moving = true
	debug = "Nothing"
end

function love.draw()
	love.graphics.translate(winw, winh)
	love.graphics.circle("line", ballpos["x"], ballpos["y"], ballradius)
	love.graphics.print(debug.."X:"..tostring(math.floor(ballpos["x"])).."      Y:"..tostring(math.floor(ballpos["y"])).."\nvel X:"..tostring(math.floor(ballvel["x"])).."    Y:"..tostring(math.floor(ballvel["y"])))
end

function love.update()
	if moving then
		touchy, touchx = touchy - 1, touchx - 1
		test = love.window.getMode()

		if ballvel["y"] < stopvel and ballvel["y"] > -stopvel then
			if slowy >= stoplen then
				if touchy > 0 then
					ballvel["y"] = 0
				end
			else
				slowy = slowy + 1
			end
		else
			slowy = 0
			if ballpos["y"] + ballradius >= winw then
				ballvel["y"] = ballvel["y"] *bounce
				touchy = touchstoplen
			end
			if ballpos["y"] - ballradius <= -winw then
				ballvel["y"] = ballvel["y"] *bounce
				touchy = touchstoplen
			end
		end

		if ballvel["x"] < stopvel and ballvel["x"] > -stopvel then
			if slowx >= stoplen then
				if touchx > 0 then
					ballvel["x"] = 0
				else
					ballvel["x"] = ballvel["x"] + 0.1
				end
			else
				slowx = slowx + 1
			end
		else
			slowx = 0
			if ballpos["x"] + ballradius >= winh then
				ballvel["x"] = ballvel["x"] * bounce
				ballvel["y"] = ballvel["y"] * friction
				touchx = touchstoplen
			else
				ballvel["y"] = ballvel["y"] + 0.1
			end
		end

		ballpos["y"] = ballpos["y"] + ballvel["y"]
		ballpos["x"] = ballpos["x"] + ballvel["x"]
	end
end
