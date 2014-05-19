Class = require 'hump.class'
Vector = require 'hump.vector'

CPlayerController = Class
{
	name = "CPlayerController",
	inherits = { Component },
	function(self, gameObj)
		Component.construct(self, gameObj, false)

		self.dependencies = { CPositionable = true }

		self.moveSpeed = 200
		self.acceleration = 5000
		self.velocity = Vector.zero
		self.gravity = 0 -- 980
		self.terminalVelocity = 1000
		self.onGround = false
		self.vertSpeed = 0

		self.jumpSpeed = -350
		self.isJumping = false
		self.pressJump = false
	end
}

function CPlayerController:start()
	self.positionable = self:get_component("CPositionable")
	self.rigidbody = self:get_component("CRigidBody")
end

function CPlayerController:update(dt)
	local moveDir = 0

	if love.keyboard.isDown("left") then moveDir = moveDir - 1 end
	if love.keyboard.isDown("right") then moveDir = moveDir + 1 end

	local xVel = self.rigidbody.body:getLinearVelocity()

	self.rigidbody.body:applyForce(moveDir * (300 - math.abs(xVel)), 0)
	self.rigidbody.body:setAngle(0)

	self.velocity = self.velocity + Vector(moveDir * self.acceleration * dt, 0.0)
	self.velocity:clamp(Vector(-self.moveSpeed, 0), Vector(self.moveSpeed, 0))

	if moveDir == 0 then
		self.velocity.x = self.velocity.x * 0.9
	end

	if math.abs(self.velocity.x) < 10 then self.velocity.x = 0 end

	if not self.onGround then
		self.vertSpeed = self.vertSpeed + self.gravity * dt
		if self.vertSpeed > self.terminalVelocity then self.vertSpeed = self.terminalVelocity end
	else
		self.vertSpeed = 0
	end

	if love.keyboard.isDown("z") then
		if not self.pressJump then
			self.rigidbody.body:applyLinearImpulse(0, -250)
		end
		self.pressJump = true
		if self.onGround and not self.isJumping then
			self.isJumping = true
			
		end
	else
		self.pressJump = false
		if self.onGround then
			self.isJumping = false
		end
	end

	self.velocity.y = self.vertSpeed
	local newPosition = self.positionable.position + self.velocity * dt
	-- self.rigidbody.body:setPosition(newPosition:unpack())
end

function CPlayerController:hit_wall(side)
	print("hit "..side)
	if side == "top" then
		self.onGround = true
	elseif side == "left" then
		if self.velocity.x > 0 then
			print("stop right")
			self.velocity.x = 0
		end
	elseif side == "right" then
		if self.velocity.x < 0 then
			self.velocity.x = 0
		end
	elseif side == "bottom" then
		self.vertSpeed = 0
	end
end

function CPlayerController:get_blank_data()
	return { moveSpeed = 0, acceleration = 0 }
end

function CPlayerController:get_data()
	return { moveSpeed = self.moveSpeed, acceleration = self.acceleration }
end

function CPlayerController:build(data)
	self.moveSpeed = data.moveSpeed
	self.acceleration = data.acceleration
end

ComponentFactory.get():register("CPlayerController", function(...) return CPlayerController(unpack(arg)) end) 