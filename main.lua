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

	pxToMeter = 64
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
		1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
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
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.push('quit')
	end
end

function love.update(dt)
	globals.dt = dt

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

	love.graphics.print("FPS : "..string.format("%.0f", globals.fps), 5, 5)
end