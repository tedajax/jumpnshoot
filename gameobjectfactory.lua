require 'locket.locket'

function create_player(pos, image)
	local go = GameObject()
	go:add_component("CPositionable")
	go:add_component("CRotatable")
	go:add_component("CAlignable")
	go:add_component("CColorable")
	go:add_component("CAABoundingBox")
	go:add_component("CPlayerController")
	go:add_component("CSpriteRenderer")
	go:add_component("CRigidBody")

	go:get_component("CPositionable").position = pos
	go:get_component("CSpriteRenderer"):set_image(playerImage)

	local phys = go:get_component("CRigidBody")
	phys:init_phys(
		love.physics.newBody(globals.world, pos.x, pos.y, "dynamic"),
		love.physics.newRectangleShape(8, 12, 14, 22, 0),
		6.666667
	)
	phys.body:setFixedRotation(true)
	phys.fixture:setRestitution(0)
	phys.fixture:setGroupIndex(-1)

	go.tag = "player"

	return go
end

function create_flag(pos, image)
	local go = GameObject()
	go:add_component("CPositionable")
	go:add_component("CRotatable")
	go:add_component("CColorable")
	go:add_component("CAlignable")
	go:add_component("CAABoundingBox")
	go:add_component("CSpriteRenderer")
	go:add_component("CFlag")

	go:get_component("CPositionable").position = pos or Vector.zero
	go:get_component("CSpriteRenderer"):set_image(image)

	local phys = go:add_component("CRigidBody")
	phys:init_phys(
		love.physics.newBody(globals.world, pos.x, pos.y, "dynamic"),
		love.physics.newRectangleShape(8, 8, 14, 16, 0),
		10
	)
	phys.fixture:setGroupIndex(-1)

	go.tag = "flag"

	return go
end

function create_spike(pos, image)
	local go = GameObject()
	go:add_component("CPositionable")
	go:add_component("CRotatable")
	go:add_component("CColorable")
	go:add_component("CAlignable")
	local bbox = go:add_component("CAABoundingBox")
	bbox.width = 32
	bbox.height = 32
	go:add_component("CSpriteRenderer")

	go:get_component("CPositionable").position = pos or Vector.zero
	go:get_component("CSpriteRenderer"):set_image(image)

	local phys = go:add_component("CRigidBody")
	phys:init_phys(
		love.physics.newBody(globals.world, pos.x, pos.y, "static"),
		love.physics.newRectangleShape(8, 8, 16, 16, 0),
		10
	)
	phys.fixture:setGroupIndex(-1)
	
	go.tag = "spike"

	return go
end

function create_block(pos, image)
	local go = GameObject()
	go:add_component("CPositionable")
	go:add_component("CRotatable")
	go:add_component("CColorable")
	go:add_component("CAlignable").alignment = "top left"
	go:add_component("CSpriteRenderer")

	go:get_component("CPositionable").position = pos or Vector.zero
	go:get_component("CSpriteRenderer"):set_image(image)

	go.tag = "block"

	return go
end