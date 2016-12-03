function renderMenus()
	for k, v in pairs(menus) do
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
				end
			end
		end
	end
	love.graphics.setCanvas()
end

function renderMenu(k)
	local v = menus[k].rendered = love.graphics.newCanvas(wx, wy, nil, canvasfsaa)
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
			end
		end
	end
	love.graphics.setCanvas()
end
