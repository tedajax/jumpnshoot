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

		self.jumpTime = 0
		self.canJump = true

		self.velY = 0
		self.prevVelY = 0
	end
}

function CPlayerController:start()
	self.positionable = self:get_component("CPositionable")
	self.rigidbody = self:get_component("CRigidBody")
end

function CPlayerController:pre_update(dt)
	self.prevVelY = self.velY
end

function sign(a)
	if a < 0 then
		return -1
	elseif a > 0 then
		return 1
	else
		return 0
	end
end

function CPlayerController:update(dt)
	local moveDir = 0

	if love.keyboard.isDown("left") then moveDir = moveDir - 1 end
	if love.keyboard.isDown("right") then moveDir = moveDir + 1 end

	local xVel, yVel = self.rigidbody.body:getLinearVelocity()
	self.velY = yVel

	if self.onGround and math.abs(self.velY) > 1 then
		self.onGround = false
	elseif not self.onGround and self.velY <= 0 and self.prevVelY > 0 then
		self.onGround = true
	end

	local moveScalar = 0
	if sign(xVel) == sign(moveScalar) then
		moveScalar = 300 - math.abs(xVel)
	else
		moveScalar = 300
	end
	
	self.rigidbody.body:applyForce(moveDir * (300 - math.abs(xVel)), 0)

	local jumpPressed = love.keyboard.isDown("z")

	if jumpPressed and not self.onGround and self.jumpTime <= 0 then
		self.canJump = false
	elseif not jumpPressed and not self.canJump then
		self.canJump = true
	end

	if jumpPressed and (self.onGround or self.jumpTime > 0) and self.canJump then
		if self.jumpTime <= 0 then
			self.rigidbody.body:applyLinearImpulse(0, -100)
		elseif self.jumpTime < 1.5 then
			self.rigidbody.body:applyForce(0, -50)
		end
		self.jumpTime = self.jumpTime + dt
	else
		self.jumpTime = 0
	end
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