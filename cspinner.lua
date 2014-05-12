Class = require 'hump.class'

CSpinner = Class
{
	name = "CSpinner",
	inherits = { Component },
	function(self, gameObj)
		Component.construct(self, gameObj, false)

		self.dependencies = { CRotatable = true }

		self.spinRate = 360 -- degrees per second
	end
}

function CSpinner:start()
	self.rotatable = self:get_component("CRotatable")
end

function CSpinner:update(dt)
	local s = (self.spinRate * math.pi) / 180.0 * dt
	self.rotatable.rotation = self.rotatable.rotation + s
end

function CSpinner:get_blank_data()
	return { radius = 0 }
end

function CSpinner:get_data()
	return { radius = self.radius }
end

function CSpinner:build(data)
	self.radius = data.radius
end

ComponentFactory.get():register("CSpinner", function(...) return CSpinner(unpack(arg)) end)