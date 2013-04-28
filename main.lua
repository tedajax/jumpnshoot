Vector = require 'hump.vector'
Timer = require 'hump.timer'
require 'locket.locket'
require 'collisionmanager'

function love.load()
	globals = {}

	globals.fps = 0
	globals.dt = 0
	
	Timer.addPeriodic(0.05, function() globals.fps = 1 / globals.dt end)

	globals.gameObjects = {}
	globals.gameObjects.player = GameObject()
	globals.player = globals.gameObjects.player
	
	globals.player:add_component("CPositionable")
	globals.player:add_component("CRotatable")
	globals.player:add_component("CAlignable")
	globals.player:add_component("CColorable")
	globals.player:add_component("CAABoundingBox")
	globals.player:add_component("CGravity")

	globals.gameObjects.block = GameObject()
	globals.block = globals.gameObjects.block
	globals.block:add_component("CPositionable")
	globals.block:add_component("CAlignable")
	globals.block:add_component("CAABoundingBox")
	globals.block:get_component("CPositionable").position = Vector(50, 450)
	globals.block:get_component("CAABoundingBox").static = true
	globals.block:get_component("CAABoundingBox").layer = "wall"

	for key, obj in pairs(globals.gameObjects) do
		obj:start()
	end

	globals.collision = CollisionManager()
	globals.collision:register(globals.player)
	globals.collision:register(globals.block)
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