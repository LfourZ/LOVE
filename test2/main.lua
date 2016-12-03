local debugWorldDraw = love.filesystem.load("debugWorldDraw.lua")()
local currentWorld,currentSurfaceBody,currentVehicleBody
local moveSpeed = 300
local rotationSpeed = 8
local wheelForceFriction = 50
local wheelTorqueFriction = 1

local vehicles = {}

local function newVehicle(world,x,y,width,height)
	local body = love.physics.newBody(world,x,y,"dynamic")
	local shape = love.physics.newRectangleShape(width,height)
	local fixture = love.physics.newFixture(body,shape,1)
	vehicles[body] = {width=width,height=height}
	return body
end

function love.load()
	love.graphics.setBackgroundColor(139,137,137,255)
	currentWorld = love.physics.newWorld(0,0,true)
	currentSurfaceBody = love.physics.newBody(currentWorld,0,0,"static")

	for x=1,20 do
		for y=1,10 do
			local vehicleBody = newVehicle(currentWorld,300+x*100,300+y*200,50,100)
			if (x==10 and y==5) then
				currentVehicleBody = vehicleBody
			end
		end
	end
end

local function newJoint(surface,body,x,y,maxForce,maxTorque)
	local tempFrictionJoint = love.physics.newFrictionJoint(surface,body,x,y,true)
	tempFrictionJoint:setMaxForce(body:getMass()*maxForce)
	tempFrictionJoint:setMaxTorque(body:getInertia()*maxTorque)
	vehicles[body][tempFrictionJoint] = true
end

local function rotatePoint(x,y,angle)
	local s = math.sin(angle)
	local c = math.cos(angle)
	return x*c - y*s,x*s + y*c
end

function love.update(dt)
	for body,data in pairs(vehicles) do
		for joint in pairs(data) do
			if (type(joint) == "userdata" and joint:type()=="FrictionJoint") then
				joint:destroy()
				data[joint] = nil
			end
		end
	end

	if (love.keyboard.isDown("a")) then
		local body = currentVehicleBody
		local inertia = body:getInertia()
		body:applyTorque(-rotationSpeed*inertia)
	elseif (love.keyboard.isDown("d")) then
		local body = currentVehicleBody
		local inertia = body:getInertia()
		body:applyTorque(rotationSpeed*inertia)
	end
	
	if (love.keyboard.isDown("w")) then
		local body = currentVehicleBody
		local mass = body:getMass()
		local angle = body:getAngle()
		local fx = -moveSpeed*mass*math.sin(-angle)
		local fy = -moveSpeed*mass*math.cos(-angle)
		body:applyForce(fx,fy)
	elseif (love.keyboard.isDown("s")) then
		local body = currentVehicleBody
		local mass = body:getMass()
		local angle = body:getAngle()
		local fx = moveSpeed*mass*math.sin(-angle)
		local fy = moveSpeed*mass*math.cos(-angle)
		body:applyForce(fx,fy)
	end
	
	for body,data in pairs(vehicles) do
		local x,y = body:getWorldCenter()
		local angle = body:getAngle()
		
		local width,height = data.width,data.height
		
		local x1,y1 = rotatePoint(-width/2,-height/2,angle) --front left
		local x2,y2 = rotatePoint(width/2,-height/2,angle) --front right
		local x3,y3 = rotatePoint(-width/2,height/2,angle) --back left
		local x4,y4 = rotatePoint(width/2,height/2,angle) --back right
		
		local maxForce,maxTorque = wheelForceFriction,wheelTorqueFriction
		newJoint(currentSurfaceBody,body,x+x1,y+y1,maxForce,maxTorque)
		newJoint(currentSurfaceBody,body,x+x2,y+y2,maxForce,maxTorque)
		newJoint(currentSurfaceBody,body,x+x3,y+y3,maxForce,maxTorque)
		newJoint(currentSurfaceBody,body,x+x4,y+y4,maxForce,maxTorque)
	end
	
	currentWorld:update(dt)
end

function love.draw()
	local x,y = currentVehicleBody:getWorldCenter()
	local width,height = love.window.getMode()
	love.graphics.push()
	love.graphics.translate(-x+width/2,-y+height/2)
	
	love.graphics.setColor(196,196,196,128)
	
	math.randomseed(3)
	for x=-50,50 do
		for y=-50,100 do
			love.graphics.setPointSize(math.random(5,20))
			love.graphics.points(x*100+math.random()*100,y*100+math.random()*100)
		end
	end
	debugWorldDraw(currentWorld)
	
	love.graphics.pop()
end