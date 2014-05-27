Class = require 'hump.class'
Vector = require 'hump.vector'

CFlag = Class
{
	name = "CFlag",
	inherits = { Component },
	function(self, gameObj)
		Component.construct(self, gameObj, false)
		
		self.dependencies = {}

		self.pickedUp = false
	end
}

function CFlag:start()
	self.rigidbody = self:get_component("CRigidBody")
	self.playerPos = globals.player:get_component("CPositionable")
end

function CFlag:update(dt)
	
end

function CFlag:post_update(dt)
	if self.pickedUp then
		px, py = self.playerPos.position:unpack()
		self.rigidbody:set_position(px, py - 8)
		self.rigidbody.body:setLinearVelocity(0, 0)
	end
end

function CFlag:pickup()
	self.pickedUp = true
end

function CFlag:drop()
	self.pickedUp = false
end

function CFlag:throw(vx, vy)
	self.pickedUp = false
	self.rigidbody.body:applyLinearImpulse(vx, vy)
end

ComponentFactory.get():register("CFlag", function(...) return CFlag(unpack(arg)) end)