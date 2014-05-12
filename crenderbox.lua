Class = require 'hump.class'
Vector = require 'hump.vector'

CRenderBox = Class
{
	name = "CRenderBox",
	inherits = { Component },
	function(self, gameObj)
		Component.construct(self, gameObj, true)

		self.dependencies = { CPositionable = true, CAlignable = true }

		self.width = 64
		self.height = 64
		self.fill = "line"
	end
}

function CRenderBox:start()
	self.positionable = self:get_component("CPositionable")
	self.alignable = self:get_component("CAlignable")
end

function CRenderBox:render()
	local ox = self.alignable.origin.x * self.width
	local oy = self.alignable.origin.y * self.height

	love.graphics.rectangle(self.fill, self.positionable.positio.x - ox, self.positionable.position.y - oy, self.width, self.height)
end

function CRenderBox:get_blank_data()
	return { width = 0, height = 0, fill = "fill" }
end

function CRenderBox:get_data()
	return { width = self.width, height = self.height, fill = self.fill }
end

function CRenderBox:build(data)
	self.width = data.width
	self.height = data.height
	self.fill = data.fill
end

ComponentFactory.get():register("CRenderBox", function(...) return CRenderBox(unpack(arg)) end)