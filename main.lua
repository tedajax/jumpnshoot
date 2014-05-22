Vector = require 'hump.vector'
Timer = require 'hump.timer'
Camera = require 'hump.camera'
require 'locket.locket'
require 'components'
require 'collisionmanager'
require 'colorpalette'
require 'gameobjectfactory'

function love.load()
	globals = {}

	globals.fps = 0
	globals.dt = 0

	globals.camera = Camera(400, 300)

	pxToMeter = 128
	love.physics.setMeter(pxToMeter)
	globals.world = love.physics.newWorld(0, 9.8 * pxToMeter, true)
	
	Timer.addPeriodic(0.05, function() globals.fps = 1 / globals.dt end)

	local enviroPalette = ColorPalette()
	enviroPalette:generate({Color(255, 0, 0), Color(255, 150, 150), default = Color.clear})
	
	blockImageData = {1, 1, 1, 1, 1, 1, 1, 1,
					  1, 2, 2, 2, 2, 2, 2, 1,
				  	  1, 2, 2, 2, 2, 2, 2, 1,
				  	  1, 2, 2, 2, 2, 2, 2, 1,
					  1, 2, 2, 2, 2, 2, 2, 1,
					  1, 2, 2, 2, 2, 2, 2, 1,
					  1, 2, 2, 2, 2, 2, 2, 1,
					  1, 1, 1, 1, 1, 1, 1, 1}
	blockImage = enviroPalette:create_image(blockImageData, 32, 32, 4)

	local playerPalette = ColorPalette()
	playerPalette:gen_test_palette()
	playerImageData = {4, 4, 4, 4, 4, 4, 4, 4,
					   4, 0, 0, 0, 0, 0, 0, 4, 
					   4, 0, 4, 0, 0, 4, 0, 4, 
					   4, 0, 0, 0, 0, 0, 0, 4, 
					   4, 0, 4, 0, 0, 4, 0, 4, 
					   4, 0, 4, 4, 4, 4, 0, 4, 
					   4, 0, 0, 0, 0, 0, 0, 4, 
					   4, 4, 4, 4, 4, 4, 4, 4}
	playerImage = playerPalette:create_image(playerImageData, 16, 16, 2)

	flagImageData = {
		1, 1, 1, 1, 0, 0, 0, 0,
		1, 1, 1, 1, 1, 1, 0, 0,
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 0, 0,
		1, 1, 1, 1, 0, 0, 0, 0,
		1, 1, 0, 0, 0, 0, 0, 0,
		1, 1, 0, 0, 0, 0, 0, 0,
		1, 1, 0, 0, 0, 0, 0, 0
	}
	flagImage = playerPalette:create_image(flagImageData, 16, 16, 2)

	globals.gameObjects = {}
	globals.collision = CollisionManager()

	globals.gameObjects.player = create_player(Vector(50, 50), playerImage)
	globals.player = globals.gameObjects.player

	local room = {
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	}

	local roomWidth = 25
	local roomHeight = 17
	local tileWidth = 32
	local tileHeight = 32
	local a = 50 * 34
	for i = 0, roomHeight - 1 do
		for j = 0, roomWidth - 1 do
			local index = i * roomWidth + j + 1
			-- print(i.." "..j.." "..index)
			if room[index] == 1 then
				local block = create_block(Vector(j * tileWidth, i * tileHeight), blockImage)
				table.insert(globals.gameObjects, block)
			elseif room[index] == 2 then
				if globals.flag == nil then
					globals.flag = create_flag(Vector(j * tileWidth, i * tileHeight), flagImage)
					globals.gameObjects.flag = globals.flag
					globals.player:get_component("CPositionable").position = Vector(j * tileWidth, i * tileHeight)
				else
					print("Already have a flag in level data, can't have more than one")
				end
			end
		end
	end

	for key, obj in pairs(globals.gameObjects) do
		obj:start()
		if obj:get_component("CAABoundingBox") ~= nil then
			-- globals.collision:register(obj)
		end
	end

	globals.room = {}
	local roomcopy = {}
	for i, v in ipairs(room) do
		roomcopy[i] = v
	end

	local tlx = -1
	local tly = -1
	for i = 0, roomHeight - 1 do
		for j = 0, roomWidth - 1 do
			local index = i * roomWidth + j + 1
			local minx = -1
			local miny = -1
			local maxx = -1
			local maxy = -1

			if roomcopy[index] == 1 then
				minx, miny, maxx, maxy = findPhysBox(roomcopy, roomWidth, roomHeight, j, i)

				local tx = (((maxx - minx) + 1) / 2 + minx) * tileWidth
				local ty = (((maxy - miny) + 1) / 2 + miny) * tileHeight

				local physBox = {}
				physBox.body = love.physics.newBody(globals.world, tx, ty, "static")
				physBox.shape = love.physics.newRectangleShape(0,
					0,
					((maxx - minx) + 1) * tileWidth,
					((maxy - miny) + 1) * tileHeight,
					0)
				physBox.fixture = love.physics.newFixture(physBox.body, physBox.shape, 1)
				physBox.fixture:setRestitution(0)

				table.insert(globals.room, physBox)
			end
		end
	end
end

function findPhysBox(room, roomwidth, roomheight, tlx, tly)
	local minx = tlx
	local miny = tly
	local maxx = minx
	local maxy = miny
	
	for x = minx, roomwidth - 1 do
		local index = miny * roomwidth + x + 1
		if room[index] ~= 1 then
			break
		else
			maxx = maxx + 1
		end
	end
			
	for y = miny + 1, roomheight - 1 do
		local goDown = true
		for x = minx, maxx - 1 do
			local index = y * roomwidth + x + 1
			if room[index] ~= 1 then
				goDown = false
			end
		end
		if goDown then
			maxy = maxy + 1
		else
			break
		end
	end

	for y = miny, maxy do
		for x = minx, maxx - 1 do
			local index = y * roomwidth + x + 1
			if room[index] == 1 then
				room[index] = 0
			end
		end
	end

	return minx, miny, maxx - 1, maxy
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.push('quit')
	end
end

function love.update(dt)
	globals.dt = dt

	for key, obj in pairs(globals.gameObjects) do
		obj:req_pre_update(dt)
	end

	globals.world:update(dt)
	
	for key, obj in pairs(globals.gameObjects) do
		obj:req_update(dt)
	end

	--local look = globals.player:get_component("CPositionable").position
	-- globals.camera:lookAt(look.x, look.y)
	
	globals.collision:update(dt)

	Timer.update(dt)
end

function love.draw()
	globals.camera:attach()
	-- globals.collision:debug_render()
	for key, obj in pairs(globals.gameObjects) do
		obj:req_render(dt)
	end	

	globals.camera:detach()

	love.graphics.setColor(255, 255, 0)
	for i, v in ipairs(globals.room) do
		love.graphics.polygon("line", v.body:getWorldPoints(v.shape:getPoints()))
	end

	love.graphics.print("FPS : "..string.format("%.0f", globals.fps), 5, 5)
end