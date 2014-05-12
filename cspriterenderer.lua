Class = require 'hump.class'
Vector = require 'hump.vector'
Color = require 'hump.color'

CSpriteRenderer = Class
{
	name = "CSpriteRenderer",
	inherits = { Component },
	function(self, gameObj)
		Component.construct(self, gameObj, true)

		self.dependencies = { 
			CPositionable = true,
			CRotatable = true,
			CAlignable = true, 
			CColorable = true 
		}

		self.image = nil
		self.width = 0
		self.height = 0
	end
}

function CSpriteRenderer:start()
	self.positionable = self:get_component("CPositionable")
	self.rotatable = self:get_component("CRotatable")
	self.alignable = self:get_component("CAlignable")
	self.colorable = self:get_component("CColorable")
	
	self.position = self.positionable.position
	self.rotation = self.rotatable.rotation
	self.alignment = self.alignable.alignment
	self.origin = self.alignable.origin
	self.color = self.colorable.color
end

function CSpriteRenderer:update(dt)
	self.position = self.positionable.position
	self.rotation = self.rotatable.rotation
	self.alignment = self.alignable.alignment
	self.origin = self.alignable.origin
	self.color = self.colorable.color
end

function CSpriteRenderer:render()
	if not self.image then return end

	local cbyte = self.color:tobyte()
	love.graphics.setColor(cbyte.r, cbyte.g, cbyte.b, cbyte.a)
	local ox = self.origin.x * self.width
	local oy = self.origin.y * self.height

	love.graphics.draw(self.image, self.position.x, self.position.y,
	                   self.rotation, 1, 1, ox, oy)
end

function CSpriteRenderer:set_image(img)
	self.image = img
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()
end

function CSpriteRenderer:get_blank_data()
	return { image = nil }
end

function CSpriteRenderer:get_data()
	return { image = self.image }
end

function CSpriteRenderer:build(data)
	self.image = data.image
end


ComponentFactory.get():register("CSpriteRenderer", function(...) return CSpriteRenderer(unpack(arg)) end)