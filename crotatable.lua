Class = require 'hump.class'
Vector = require 'hump.vector'

CRotatable = Class
{
	name = "CRotatable",
	inherits = { Component },
	function(self, gameObj)
		Component.construct(self, gameObj, false)

		self.dependencies = { }

		self.rotation = 0
	end
}

function CRotatable:get_blank_data()
	return { image = nil }
end

function CRotatable:get_data()
	return { image = self.image }
end

function CRotatable:build(data)
	self.image = data.image
end

ComponentFactory.get():register("CRotatable", function(...) return CRotatable(unpack(arg)) end)