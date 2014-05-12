Class = require 'hump.class'
Vector = require 'hump.vector'

CRenderCircle = Class
{
	name = "CRenderCircle",
	inherits = { Component },
	function(self, gameObj)
		Component.construct(self, gameObj, true)

		self.dependencies = { CPositionable = true }

		self.radius = 16
		self.position = nil
	end
}

function CRenderCircle:start()
	self.positionable = self:get_component("CPositionable")
	self.position = self.positionable.position --self:get_component("CPositionable").position
end

function CRenderCircle:render()
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.circle("fill", self.positionable.position.x, self.positionable.position.y, self.radius)
end

function CRenderCircle:get_blank_data()
	return { radius = 0 }
end

function CRenderCircle:get_data()
	return { radius = self.radius }
end

function CRenderCircle:build(data)
	self.radius = data.radius
end


ComponentFactory.get():register("CRenderCircle", function(...) return CRenderCircle(unpack(arg)) end)