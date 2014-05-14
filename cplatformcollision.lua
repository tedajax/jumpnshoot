Class = require 'hump.class'
Vector = require 'hump.vector'
require 'datastructs'

CPlatformCollision = Class
{
	name = "CPlatformCollision",
	inherits = { Component },
	function(self, gameObj)
		Component.construct(self, gameObj, false)

		self.dependencies = { CAABoundingBox = true }

		self.groundBlocks = Set()
	end
}

function CPlatformCollision:start()
	self.positionable = self:get_component("CPositionable")
	self.collider = self:get_component("CAABoundingBox")
	self.controller = self:get_component("CPlayerController") or self:get_component("CGravity")
end

function CPlatformCollision:update(dt)
end

function CPlatformCollision:resolve_collision(collision)
	local x, y = self.positionable.position.x, self.positionable.position.y
	local collider = collision.collider

	local side = self.collider:intersect_side(collider)

	local width = (collider.width / 2) + (self.collider.width / 2)
	local height = (collider.height / 2) + (self.collider.height / 2)

	local cx = collider.positionable.position.x
	local cy = collider.positionable.position.y

	if side == "top" then
		y = cy - height
	elseif side == "bottom" then
		y = cy + height
	elseif side == "left" then
		x = cx - width - 0
	elseif side == "right" then
		x = cx + width + 0
	end

	self.positionable.position.x = x
	self.positionable.position.y = y

	return side
end

function CPlatformCollision:on_collision_enter(collision)	
	local side = self:resolve_collision(collision)
	self.controller:hit_wall(side)

	if side == "top" then
		self.groundBlocks:add(collision.collider)
	end
end

function CPlatformCollision:on_collision_stay(collision)
	local side = self:resolve_collision(collision)
end

function CPlatformCollision:on_collision_exit(collision)
	local collider = collision.collider
	if self.groundBlocks:contains(collider) then
		self.groundBlocks:remove(collider)
	end
	if self.groundBlocks.size == 0 then
		self.controller.onGround = false
	end
end

function CPlatformCollision:get_blank_data()
	return {}
end

function CPlatformCollision:get_data()
	return {}
end

function CPlatformCollision:build(data)

end

ComponentFactory.get():register("CPlatformCollision", function(...) return CPlatformCollision(unpack(arg)) end)