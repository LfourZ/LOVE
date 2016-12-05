local shine = require 'shine'
function love.load()

	love.window.setMode(1000, 1000, {resizable = false, borderless = true, vsync = false, msaa = 8})

	--[[
	CHANGES:
	-Can now rerender a single menu at a time
	]]--
	-----
	shader = shine.gaussianBlur()
	shader.parameters = { sigma = 10 }
	fireparticle = love.graphics.newImage("fireparticle.png")
	particle = love.graphics.newParticleSystem(fireparticle, 1000)
	particle:setParticleLifetime(1)
	particle:setSizes(0.1, 0)
	particle:setSpeed(100)
	particle:setSpread(6.28319)
	particle:setEmissionRate(100)
	particle:stop()
	-----
	defaultfontsize = 50
	love.graphics.setNewFont(defaultfontsize)
	canvasfsaa = 8
	--love.graphics.setBlendMode("alpha", "premultiplied")
	wx, wy = love.window.getMode()
	love.graphics.setBackgroundColor(0, 0, 0)
	size = 7
	xp, yp = wx/size, wy/size
	margin = math.floor(((wx + wy) / 2) / 300)
	tiles = {}
	last = 0
	selected = false
	righttime = 70
	rightp = 150 / righttime
	right = 0
	wrongtime = 70
	wrongp = 200 / wrongtime
	wrong = 0
	shades = 7
	spn = 255 / shades
	score = 0
	cornerround = 10
	location = "game"
	menulocation = "main"
	cornerquality = 10 --Doesn't seem to do anything?
	menus = {
		main = {
			rendered = nil,
			objects = {
				quit = {
					action = function ()
						love.event.quit()
					end,
					mode = "fill",
					color = { r = 255, g = 255, b = 255, a = 255 },
					pos = { x1 = 0.1, y1 = 0.1, x2 = 0.9, y2 = 0.2 },
					corner = { radx = 3, rady = 3, segments = nil },
					text = {
						content = "Quit",
						color = { r = 0, g = 0, b = 0, a = 255 }
					}
				},
				restart = {
					action = function ()
						createtiles()
						renderGameCanvas()
					end,
					mode = "fill",
					color = { r = 255, g = 0, b = 0, a = 255 },
					pos = { x1 = 0.1, y1 = 0.21, x2 = 0.9, y2 = 0.3 },
					corner = { radx = 3, rady = 3, segments = nil },
					text = {
						content = "Restart",
						color = { r = 0, g = 0, b = 0, a = 255 }
					}
				},
				smallmode = {
					action = function ()
						particle:setSizes(0.0375, 0)
						particle:setSpeed(37.5)
						love.graphics.setNewFont(19)
						love.window.setMode(300, 300)
						rerender(300, 300)
					end,
					mode = "fill",
					color = { r = 255, g = 255, b = 255, a = 255 },
					pos = { x1 = 0.1, y1 = 0.31, x2 = 0.495, y2 = 0.4 },
					corner = { radx = 3, rady = 3, segments = nil },
					text = {
						content = "Small mode",
						color = { r = 0, g = 0, b = 0, a = 255 }
					}
				},
				vsync = {
					action = function ()
						menus.main.objects.vsync.special.var = not menus.main.objects.vsync.special.var
						love.window.setMode(wx, wy, { vsync = menus.main.objects.vsync.special.var})
						renderMenu("main")
					end,
					mode = "fill",
					color = { r = 255, g = 255, b = 255, a = 255 },
					pos = { x1 = 0.505, y1 = 0.31, x2 = 0.9, y2 = 0.4 },
					corner = { radx = 3, rady = 3, segments = nil },
					text = {
						content = "Vsync",
						color = { r = 0, g = 0, b = 0, a = 255 }
					},
					special = {
						class = "checkbox",
						coloron = { 0, 255, 0 },
						coloroff = { 255, 0, 0 },
						shape = "circle",
						mode = "fill",
						var = true
					}
				},
				msaa = {
					action = function ()
					end,
					mode = "fill",
					color = { r = 255, g = 255, b = 255, a = 255 },
					pos = { x1 = 0.1, y1 = 0.41, x2 = 0.495, y2 = 0.5 },
					corner = { radx = 3, rady = 3, segments = nil },
					text = {
						content = "MSAA",
						color = { r = 0, g = 0, b = 0, a = 255 }
					},
					special = {
						class = "slider",
						colorline = { 0, 255, 0 },
						colorsegment = { 255, 0, 0 },
						colorselected = { 0, 0, 255 },
						shape = nil,
						mode = "fill",
						segments = 4,
						length = 0.5,
						send = 0.9,
						var = 0,
						width = 5,
						style = "smooth"
					}
				}
			}
		}
	}
	function rerender(X, Y)
		wx, wy = X, Y
		xp, yp = wx/size, wy/size
		margin = math.floor(((wx + wy) / 2) / 300)
		renderGameCanvas()
		renderMenus()
	end
	-----
	function isWithinCircle(X, Y, X2, Y2)
		local dx = X - X2
		local dy = Y - Y2
		return math.sqrt((dx ^ 2) + (dy ^ 2))
	end
	-----
	function renderMenu(k)
		local v = menus[k]
		menus[k].rendered = love.graphics.newCanvas(wx, wy, nil, canvasfsaa)
		love.graphics.setCanvas(menus[k].rendered)
		for k2, v2 in pairs(v.objects) do
			love.graphics.setColor(v2.color.r, v2.color.g, v2.color.b, v2.color.a)
			love.graphics.rectangle(v2.mode, v2.pos.x1 * wx, v2.pos.y1 * wy, v2.pos.x2 * wx - v2.pos.x1 * wx, v2.pos.y2 * wy - v2.pos.y1 * wy, v2.corner.radx, v2.corner.rady, v2.corner.segments)
			if v2.text.content ~= nil then
				love.graphics.setColor(v2.text.color.r, v2.text.color.g, v2.text.color.b, v2.text.color.a)
				love.graphics.print(v2.text.content, v2.pos.x1 * wx, v2.pos.y1 * wy)
			end
			if v2.special ~= nil then
				if v2.special.class == "checkbox" then
					if v2.special.var then
						love.graphics.setColor(v2.special.coloron)
					else
						love.graphics.setColor(v2.special.coloroff)
					end
					local radius = (((v2.pos.y2 - v2.pos.y1) * wy) / 2) * 0.5 - 2
					if v2.special.shape == "circle" then
						love.graphics.circle(v2.special.mode, v2.pos.x2 * wx - radius - 2, ((v2.pos.y2 + v2.pos.y1) / 2) * wy, radius)
					end
				elseif v2.special.class == "slider" then
					love.graphics.setColor(v2.special.colorline)
					love.graphics.setLineWidth(v2.special.width)
					love.graphics.setLineStyle(v2.special.style)
					local sliderlen = ((v2.pos.x2 - v2.pos.x1) * wx) * v2.special.length
					love.graphics.line(v2.pos.x2 * wx - sliderlen - 10, ((v2.pos.y2 + v2.pos.y1) / 2) * wy, v2.pos.x2 * wx - 10, ((v2.pos.y2 + v2.pos.y1) / 2) * wy)
					love.graphics.setColor(v2.special.colorsegment)
					local firstsegment = v2.pos.x2 * wx - sliderlen
					local segmentlen = sliderlen / (v2.special.segments - 1)
					local radius = (((v2.pos.y2 - v2.pos.y1) * wy) / 2) * 0.25 - 2
					for i = 0, v2.special.segments - 1 do
						love.graphics.circle(v2.special.mode, firstsegment + i * segmentlen - 10, ((v2.pos.y2 + v2.pos.y1) / 2) * wy, radius)
					end
					love.graphics.setColor(v2.special.colorselected)
					local radius = (((v2.pos.y2 - v2.pos.y1) * wy) / 2) * 0.20 - 2
					love.graphics.circle(v2.special.mode, firstsegment + v2.special.var * segmentlen - 10, ((v2.pos.y2 + v2.pos.y1) / 2) * wy, radius)
				end
			end
		end
		love.graphics.setCanvas()
	end
	-----
	function renderMenus()
		for kt, _ in pairs(menus) do
			renderMenu(kt)
		end
		love.graphics.setCanvas()
	end
	-----
	function renderGameCanvas()
		gamecanvas = love.graphics.newCanvas(nil, nil, nil, canvasfsaa)
		love.graphics.setCanvas(gamecanvas)
		drawtiles()
		markSelected()
		love.graphics.setColor(255, 0, 0)
		love.graphics.print(score, wx / 2)
		love.graphics.draw(particle)
		love.graphics.setCanvas()
	end
	-----
	function getMenuAction(X, Y)
		if not location == "menu" then return end
		local found = false
		for k, v in pairs(menus[menulocation].objects) do
			if X > v.pos.x1 * wx and Y > v.pos.y1 * wy and X < v.pos.x2 * wx and Y < v.pos.y2 * wy then
				if v.special ~= nil and v.special.class == "slider" then

				else
					found = true
					v.action()
					break
				end
			end
		end
		return found
	end
	-----
	function createtiles()
		particle:stop()
		last = 0
		selected = false
		score = 0
		math.randomseed(os.clock())
		for i = 1, size do
			tiles[i] = {}
			for n = 1, size do
				tiles[i][n] = math.random(1, shades)
			end
		end
	end
	-----
	function markSelected()
		if not selected then return end
		love.graphics.setColor(150, 150, 255)
		love.graphics.rectangle("line", (selectedx - 1) * xp, (selectedy - 1) * yp, xp, yp, cornerround, cornerround, cornerquality)
		particle:setPosition(selectedx * xp - xp / 2, selectedy * yp - yp / 2)
		particle:start()
	end
	-----
	function isNextTo()
		if selectedx <= lastx + 1 and selectedx >= lastx - 1 and selectedy <= lasty + 1 and selectedy >= lasty - 1 and not (selectedx == lastx and selectedy == lasty) then
			return true
		else
			return false
		end
	end
	-----
	function isRightColor()
		if selecteds == lasts then
			return true
		else
			return false
		end
	end
	-----
	function getTile(X, Y)
		if X < 0 or Y < 0 then return false end

		local xt = math.floor(X / xp) + 1
		local yt = math.floor(Y / yp) + 1

		return tiles[xt][yt], xt, yt
	end
	-----
	function drawtiles()
		for i = 1, size do
			for n = 1, size do
				local clr = 255 - tiles[i][n] * math.floor(spn)
				love.graphics.setColor(clr, clr, clr)
				love.graphics.rectangle("fill", (i - 1) * xp + margin, (n - 1) * yp + margin, xp - margin * 2, yp - margin * 2, cornerround, cornerround, cornerquality)
			end
		end
	end
	-----
	renderMenus()
	createtiles()
end

function love.update(Dt)
	if location == "game" then
		gamecanvas = nil
		particle:update(Dt)
	end
	if wrong ~= 0 then
		love.graphics.setBackgroundColor(wrongp * wrong, 0, 0)
		wrong = wrong - 1
	elseif right ~= 0 then
		love.graphics.setBackgroundColor(0, rightp * right, 0)
		right = right - 1
		if right == 0 then
			particle:stop()
		end
	end
end

function love.draw()
	if location == "menu" then
		if gamecanvas == nil then
			renderGameCanvas()
		end
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(gamecanvas)
		love.graphics.draw(menus[menulocation].rendered)
	elseif location == "game" then
		drawtiles()
		markSelected()
		love.graphics.setColor(255, 0, 0)
		love.graphics.print(score, wx / 2)
		shader:draw(function()
			love.graphics.draw(particle)
		end)
		love.graphics.setShader()
	end
	love.graphics.setColor(0, 255, 0)
	love.graphics.print(love.timer.getFPS(), 0, 0, 0, 0.3)
end

function love.resize(X, Y)
	rerender(X, Y)
end

function love.mousepressed(X, Y)
	if location == "game" then
		lasts, lastx, lasty = selecteds, selectedx, selectedy
		selecteds, selectedx, selectedy = getTile(X, Y)
		if not selected then
			selected = true
		else
			particle:stop()
			if isNextTo() and isRightColor() then
				if selecteds == shades then
					tiles[selectedx][selectedy] = 0
				else
					tiles[selectedx][selectedy] = selecteds + 1
				end
				score = score + 1
				right = righttime
			else
				wrong = wrongtime
			end
			selected = false
		end
	elseif location == "menu" then
		getMenuAction(X, Y)
	end
end

function love.keypressed(Key, Scancode, Repeat)
	if Key == "escape" then
		if location == "game" then
			menulocation = "main"
			location = "menu"
		elseif location == "menu" then
			location = "game"
		end
	end
end
