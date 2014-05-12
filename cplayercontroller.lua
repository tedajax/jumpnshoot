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
		self.gravity = 980
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
end

function CPlayerController:update(dt)
	local moveDir = 0

	if love.keyboard.isDown("left") then moveDir = moveDir - 1 end
	if love.keyboard.isDown("right") then moveDir = moveDir + 1 end

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
		self.pressJump = true
		if self.onGround and not self.isJumping then
			self.isJumping = true
			self.vertSpeed = self.jumpSpeed
		end
	else
		self.pressJump = false
		if self.onGround then
			self.isJumping = false
		end
	end

	self.velocity.y = self.vertSpeed
	self.positionable.position = self.positionable.position + self.velocity * dt
end

function CPlayerController:hit_wall(side)
	if side == "top" then
		self.onGround = true
	elseif side == "right" then
		if self.velocity.x > 0 then
			self.velocity.x = 0
		end
	elseif side == "left" then
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