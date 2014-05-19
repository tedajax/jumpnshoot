Class = require 'hump.class'
Vector = require 'hump.vector'

CRigidBody = Class
{
	name = "CRigidBody",
	inherits = { Component },
	function(self, gameObj)
		Component.construct(self, gameObj, true)

		self.dependencies = { CPositionable = true }

		self.body = nil
		self.shape = nil
		self.fixture = nil
	end
}

function CRigidBody:start()
	self.positionable = self:get_component("CPositionable")
end

function CRigidBody:update(dt)
	self.positionable.position.x = self.body:getX()
	self.positionable.position.y = self.body:getY()
end

function CRigidBody:render()
	love.graphics.setColor(255, 255, 0)

	if not self.shape:typeOf("CircleShape") then
		love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
	else
		love.graphics.circle("fill", self.body:getWorldPoints(self.shape:getPosition()), self.shape:getRadius())
	end
end

function CRigidBody:init_phys(body, shape, density)
	self.body = body
	self.shape = shape
	density = density or 1
	self.fixture = love.physics.newFixture(body, shape, density)
end

ComponentFactory.get():register("CRigidBody", function(...) return CRigidBody(unpack(arg)) end)