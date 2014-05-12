Class = require 'hump.class'
Vector = require 'hump.vector'

local max = math.max
local min = math.min

CAABoundingBox = Class
{
	name = "CAABoundingBox",
	inherits = { Component },
	function(self, gameObj, staticObj)
		Component.construct(self, gameObj, true)

		self.dependencies = { CPositionable = true, CAlignable = true}

		self.layer = "default"
		self.collidesWith = { default = true, wall = true }

		self.cells = nil
		self.static = false
		self.trigger = false
		if staticObj ~= nil then self.static = staticObj end

		self.lastPosition = Vector(0, 0)

		self.width = 16
		self.height = 16

		self.collCount = 0
		self.isColliding = false
		self.collidingWith = {}

		self.debugOn = false
	end
}

function CAABoundingBox:start()
	self.positionable = self:get_component("CPositionable")
	self.alignable = self:get_component("CAlignable")
end

function CAABoundingBox:left()
	local ox = self.alignable.origin.x * self.width

	return self.positionable.position.x - ox
end

function CAABoundingBox:right()
	local ox = self.alignable.origin.x * self.width

	return self.positionable.position.x + self.width - ox
end

function CAABoundingBox:top()
	local oy = self.alignable.origin.y * self.height

	return self.positionable.position.y - oy
end

function CAABoundingBox:bottom()
	local oy = self.alignable.origin.y * self.height

	return self.positionable.position.y + self.height - oy
end

function CAABoundingBox:center()
	local ox = self.alignable.origin.x * self.width
	local oy = self.alignable.origin.y * self.height

	return self.positionable.position - Vector(ox, oy)
end

function CAABoundingBox:topleft()
	return Vector(self:left(), self:top())
end

function CAABoundingBox:topright()
	return Vector(self:right(), self:top())
end

function CAABoundingBox:bottomleft()
	return Vector(self:left(), self:bottom())
end

function CAABoundingBox:bottomright()
	return Vector(self:right(), self:bottom())
end

function CAABoundingBox:on_trigger_enter(collider)
	self.collidingWith[collider] = true
	self.collCount = self.collCount + 1
	if self.collCount > 0 then self.isColliding = true end
end

function CAABoundingBox:on_trigger_stay(collider)
end

function CAABoundingBox:on_trigger_exit(collider)
	self.collidingWith[collider] = false
	self.collCount = self.collCount - 1
	if self.collCount <= 0 then self.isColliding = false end
end

function CAABoundingBox:on_collision_enter(collision)
	self:on_trigger_enter(collision.collider)
end

function CAABoundingBox:on_collision_stay(collision)
end

function CAABoundingBox:on_collision_exit(collision)
	self:on_trigger_exit(collision.collider)
end

function CAABoundingBox:collides(other)
	local diff = other:center() - self:center()
	local normal = diff:normalized()

	local collision = {}

	collision.normal = normal
	collision.collider = other

	return collision
end

function CAABoundingBox:intersect_side(other, tolerance)
	tolerance = 16 -- REMOVE THIS LATER THIS IS FOR TESTING

	local diff = self.positionable.position - other.positionable.position
	local norm = diff:normalized()

	local angle = math.atan2(norm.y, norm.x) * 180 / math.pi + 180

	if angle >= 45 and angle < 135 then
		return "top"
	elseif angle >= 135 and angle < 225 then
		return "right"
	elseif angle >= 225 and angle < 315 then
		return "bottom"
	else
		return "left"
	end
end

function CAABoundingBox:intersects(other)
	if self.collidesWith[other.layer] then
		return self:right() >= other:left() and self:left() <= other:right() and
	   		   self:bottom() >= other:top() and self:top() <= other:bottom()
	else
		return false
	end
end

function CAABoundingBox:render()
	if not self.debugOn then return end

	local ox = self.alignable.origin.x * self.width
	local oy = self.alignable.origin.y * self.height

	if self.isColliding then
		love.graphics.setColor(255, 0, 0)
	else
		love.graphics.setColor(0, 255, 0)
	end
	love.graphics.rectangle("line", self.positionable.position.x - ox, self.positionable.position.y - oy, self.width, self.height)
end

ComponentFactory.get():register("CAABoundingBox", function(...) return CAABoundingBox(unpack(arg)) end)