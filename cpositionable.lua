Class = require 'hump.class'
Signal = require 'hump.signal'
Vector = require 'hump.vector'

CPositionable = Class
{
	name = "CPositionable",
	inherits = { Component },
	function(self, gameObj)
		Component.construct(self, gameObj, false)

		self.position = Vector(50, 50)
	end
}

function CPositionable:get_blank_data()
	return { position = Vector(0, 0) }
end

function CPositionable:get_data()
	return { position = self.position }
end

function CPositionable:build(data)
	self.position = data.position
end

ComponentFactory.get():register("CPositionable", function(...) return CPositionable(unpack(arg)) end)