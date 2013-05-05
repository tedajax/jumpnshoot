Vector = require 'hump.vector'
Timer = require 'hump.timer'
require 'locket.locket'
require 'collisionmanager'
require 'colorpalette'
require 'gameobjectfactory'

function love.load()
	globals = {}

	globals.fps = 0
	globals.dt = 0
	
	Timer.addPeriodic(0.05, function() globals.fps = 1 / globals.dt end)

	local palette = ColorPalette()
	palette:gen_test_palette()
	testdata = {1, 1, 1, 1, 1, 1, 1, 1,
				0, 0, 1, 0, 0, 1, 0, 0,
				0, 0, 1, 0, 0, 1, 0, 0,
				0, 0, 1, 0, 0, 1, 0, 0,
				0, 0, 1, 0, 0, 1, 0, 0,
				0, 0, 1, 0, 0, 1, 0, 0,
				0, 0, 1, 0, 0, 1, 0, 0,
				1, 1, 1, 1, 1, 1, 1, 1}
	testimage = palette:create_image(testdata, 64, 64, 8)

	globals.gameObjects = {}
	globals.gameObjects.player = GameObject()
	globals.player = globals.gameObjects.player
	
	globals.player:add_component("CPositionable")
	globals.player:add_component("CRotatable")
	globals.player:add_component("CAlignable")
	globals.player:add_component("CColorable")
	globals.player:add_component("CAABoundingBox")
	globals.player:add_component("CGravity")

	globals.collision = CollisionManager()

	for i = 0, 20 do
		local block = create_block(Vector(i * 64, 500), testimage)
		table.insert(globals.gameObjects, block)
	end

	for key, obj in pairs(globals.gameObjects) do
		obj:start()
		if obj:get_component("CAABoundingBox") ~= nil then
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
	
	globals.collision:update(dt)

	Timer.update(dt)
end

function love.draw()
	globals.collision:debug_render()
	love.graphics.print("FPS : "..string.format("%.0f", globals.fps), 5, 5)
	for key, obj in pairs(globals.gameObjects) do
		obj:req_render(dt)
	end
end