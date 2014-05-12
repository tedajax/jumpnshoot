require 'locket.locket'

function create_player(pos, image)
	local go = GameObject()
	go:add_component("CPositionable")
	go:add_component("CRotatable")
	go:add_component("CAlignable")
	go:add_component("CColorable")
	go:add_component("CAABoundingBox")
	-- go:add_component("CGravity")
	go:add_component("CPlayerController")
	go:add_component("CPlatformCollision")
	go:add_component("CSpriteRenderer")

	go:get_component("CPositionable").position = pos
	go:get_component("CSpriteRenderer"):set_image(playerImage)

	return go
end

function create_flag(pos, image)
	local go = GameObject()
	go:add_component("CPositionable")
	go:add_component("CRotatable")
	go:add_component("CColorable")
	go:add_component("CAlignable")
	go:add_component("CAABoundingBox")
	go:add_component("CGravity")
	go:add_component("CPlatformCollision")
	go:add_component("CSpriteRenderer")

	go:get_component("CPositionable").position = pos or Vector.zero
	go:get_component("CPositionable").layer = "wall"
	go:get_component("CSpriteRenderer"):set_image(image)
	--go:get_component("CAABoundingBox").trigger = true

	return go
end

function create_block(pos, image)
	local go = GameObject()
	go:add_component("CPositionable")
	go:add_component("CRotatable")
	go:add_component("CColorable")
	go:add_component("CAlignable")
	go:add_component("CAABoundingBox")
	go:add_component("CSpriteRenderer")

	go:get_component("CPositionable").position = pos or Vector.zero
	go:get_component("CAABoundingBox").static = true
	go:get_component("CAABoundingBox").layer = "wall"
	go:get_component("CSpriteRenderer"):set_image(image)

	return go
end