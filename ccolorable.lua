Class = require 'hump.class'
Vector = require 'hump.vector'
Color = require 'hump.color'

CColorable = Class
{
	name = "CColorable",
	inherits = { Component },
	function(self, gameObj)
		Component.construct(self, gameObj, false)

		self.dependencies = { }

		self.color = Color.white
	end
}

function CColorable:get_blank_data()
	return { color = Color(0, 0, 0, 0) }
end

function CColorable:get_data()
	return { color = self.color }
end

function CColorable:build(data)
	self.color = data.color
end

ComponentFactory.get():register("CColorable", function(...) return CColorable(unpack(arg)) end)
