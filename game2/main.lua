function love.load()
	node0 = {-100, -100, -100}
	node1 = {-100, -100,  100}
	node2 = {-100,  100, -100}
	node3 = {-100,  100,  100}
	node4 = { 100, -100, -100}
	node5 = { 100, -100,  100}
	node6 = { 100,  100, -100}
	node7 = { 100,  100,  100}
	nodes = {node0, node1, node2, node3, node4, node5, node6, node7}

	edge0  = {1, 2}
	edge1  = {2, 4}
	edge2  = {4, 3}
	edge3  = {3, 1}
	edge4  = {5, 6}
	edge5  = {6, 8}
	edge6  = {8, 7}
	edge7  = {7, 5}
	edge8  = {1, 5}
	edge9  = {2, 6}
	edge10 = {3, 7}
	edge11 = {4, 8}
	edges  = {edge0, edge1, edge2, edge3, edge4, edge5, edge6, edge7, edge8, edge9, edge10, edge11}

	bgcl = {255, 255, 255}
	ncl = {40, 168, 107}
	ecl = {34, 68, 204}
	nodeSize = 8

	function draw()
		love.graphics.setBackgroundColor(bgcl[1], bgcl[2], bgcl[3])
		--Draw edges
	    love.graphics.setColor(ecl[1], ecl[2], ecl[3])
	    for i = 1, #edges do
	        n0 = edges[i][1]
	        n1 = edges[i][2]
	        node0 = nodes[n0]
	        node1 = nodes[n1]
	        love.graphics.line(node0[1], node0[2], node1[1], node1[2])
	    end

		--Draw nodes
	    love.graphics.setColor(ncl[1], ncl[2], ncl[3])
	    for n = 1, #nodes do
	        node = nodes[n]
	        love.graphics.circle("fill", node[1], node[2], nodeSize)
	    end
	end

	function rotateZ3D(theta)
	    sin_t = math.sin(theta)
	    cos_t = math.cos(theta)

	    for n = 1, #nodes do
	        node = nodes[n]
	        local x = node[1]
	        local y = node[2]
	        node[1] = x * cos_t - y * sin_t
	        node[2] = y * cos_t + x * sin_t
	    end
	end

	function rotateY3D(theta)
	    sin_t = math.sin(theta)
	    cos_t = math.cos(theta)

	    for n = 1, #nodes do
	        node = nodes[n]
	        local x = node[1]
	        local z = node[2]
	        node[1] = x * cos_t - z * sin_t
	        node[3] = z * cos_t + x * sin_t
	    end
	end

	function rotateX3D(theta)
	    sin_t = math.sin(theta)
	    cos_t = math.cos(theta)

	    for n = 1, #nodes do
	        node = nodes[n]
	        local y = node[1]
	        local z = node[2]
	        node[2] = y * cos_t - z * sin_t
	        node[3] = z * cos_t + y * sin_t
	    end
	end
end

function love.draw()
	love.graphics.translate(200, 200)
	draw()
	rotateY3D(0.01)
	rotateX3D(0.01)
end
