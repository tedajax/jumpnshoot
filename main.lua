Vector = require 'hump.vector'
Timer = require 'hump.timer'
Camera = require 'hump.camera'
require 'locket.locket'
require 'collisionmanager'
require 'colorpalette'
require 'gameobjectfactory'

function love.load()
	globals = {}

	globals.fps = 0
	globals.dt = 0

	globals.camera = Camera(400, 300)
	
	Timer.addPeriodic(0.05, function() globals.fps = 1 / globals.dt end)

	local palette = ColorPalette()
	palette:gen_test_palette()
	blockImageData = {1, 1, 1, 1, 1, 1, 1, 1,
					  0, 0, 1, 0, 0, 1, 0, 0,
				  	  1, 1, 1, 1, 1, 1, 1, 1,
				  	  0, 0, 1, 0, 0, 1, 0, 0,
					  0, 0, 1, 0, 0, 1, 0, 0,
					  1, 1, 1, 1, 1, 1, 1, 1,
					  0, 0, 1, 0, 0, 1, 0, 0,
					  1, 1, 1, 1, 1, 1, 1, 1}
	blockImage = palette:create_image(blockImageData, 64, 64, 8)

	playerImageData = {4, 4, 4, 4, 4, 4, 4, 4,
					   4, 0, 0, 0, 0, 0, 0, 4, 
					   4, 0, 4, 0, 0, 4, 0, 4, 
					   4, 0, 0, 0, 0, 0, 0, 4, 
					   4, 0, 4, 0, 0, 4, 0, 4, 
					   4, 0, 4, 4, 4, 4, 0, 4, 
					   4, 0, 0, 0, 0, 0, 0, 4, 
					   4, 4, 4, 4, 4, 4, 4, 4}
	playerImage = palette:create_image(playerImageData, 64, 64, 8)

	globals.gameObjects = {}
	globals.collision = CollisionManager()

	globals.gameObjects.player = create_player(Vector(50, 50), playerImage)
	globals.player = globals.gameObjects.player

	for i = 0, 20 do
		local block = create_block(Vector(i * 64, 500), blockImage)
		table.insert(globals.gameObjects, block)
	end

	for key, obj in pairs(globals.gameObjects) do
		obj:start()
		if obj:get_component("CAABoundingBox") ~= nil then
			print(obj)
			globals.collision:register(obj)
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
	
	for key, obj in pairs(globals.gameObjects) do
		obj:req_update(dt)
	end

	local look = globals.player:get_component("CPositionable").position
	globals.camera:lookAt(look.x, look.y)
	
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