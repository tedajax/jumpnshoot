require 'locket.locket'

function love.load()
	globals = {}

	globals.gameObjects = {}
	globals.gameObjects.player = GameObject()
	globals.player = globals.gameObjects.player
	
	globals.player:add_component("CPositionable")
	globals.player:add_component("CRotatable")
	globals.player:add_component("CAlignable")
	globals.player:add_component("CColorable")
	globals.player:add_component("CRenderCircle")
	globals.player:add_component("CGravity")

	for key, obj in pairs(globals.gameObjects) do
		obj:start()
	end
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.push('quit')
	end
end

function love.update(dt)
	for key, obj in pairs(globals.gameObjects) do
		obj:req_update(dt)
	end
end

function love.draw()
	for key, obj in pairs(globals.gameObjects) do
		obj:req_render(dt)
	end
end