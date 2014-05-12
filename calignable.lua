Class = require 'hump.class'
Vector = require 'hump.vector'

CAlignable = Class
{
	name = "CAlignable",
	inherits = { Component },
	function(self, gameObj)
		Component.construct(self, gameObj, false)

		self.dependencies = { }

		self.alignment = "top left"
		self.oldAlignment = self.alignment
		self.origin = Vector.zero
	end
}

function CAlignable:start()
end

function CAlignable:updateOrigin()
	if self.alignment == "top left" then
		self.origin = Vector(0, 0)
	elseif self.alignment == "top" then
		self.origin = Vector(0.5, 0)
	elseif self.alignment == "top right" then
		self.origin = Vector(1, 0)
	elseif self.alignment == "left" then
		self.origin = Vector(0, 0.5)
	elseif self.alignment == "center" then
		self.origin = Vector(0.5, 0.5)
	elseif self.alignment == "right" then
		self.origin = Vector(1, 0.5)
	elseif self.alignment == "bottom left" then
		self.origin = Vector(0, 1)
	elseif self.alignment == "bottom" then
		self.origin = Vector(0.5, 1)
	elseif self.alignment == "bottom right" then
		self.origin = Vector(1, 1)
	end
end

function CAlignable:update(dt)
	if self.oldAlignment ~= self.alignment then
		self:updateOrigin()
		self.oldAlignment = self.alignment
	end
end

function CAlignable:get_blank_data()
	return {
		alignment = "top left",
		origin = Vector.zero
	}
end

function CAlignable:get_data()
	return {
		alignment = self.alignment,
		origin = self.origin
	}
end

function CAlignable:build(data)
	self.alignment = data.alignment
	self.origin = data.origin
end

ComponentFactory.get():register("CAlignable", function(...) return CAlignable(unpack(arg)) end)