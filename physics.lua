Class = require 'hump.class'
Vector = require 'hump.vector'

Physics = Class
{
	name = "Physics",
	function(self, collManager)
		assert(collManager ~= nil, "Must pass in collision manager to physics")
		self.collision = collManager
	end
}

-- returns the location of the intersection of two line segments or nil if no intersection
function Physics.line_segment_intersection(line1p1, line1p2, line2p1, line2p2)
	assert(line1p1:is_a("vector") and line1p2:is_a("vector") and line2p1:is_a("vector") and line2p2:is_a("vector"), "Incorrect types sent to Physics.line_segment_intersection.  Expected <vector>")

	local p = line1p1
	local r = line1p2 - line1p1
	local q = line2p1
	local s = line2p2 - line2p1

	local t = (q - p):cross(s) / (r:cross(s))
	local u = (q - p):cross(r) / (r:cross(s))

	if u >= 0 and u <= 1 and t >= 0 and t <= 1 then
		return Vector.lerp(p, p+r, t)
	end

	return nil
end

function Physics.ray_intersects_rect(start, dir, dist, topleft, botright)
	local raystart = start
	local rayend = start + (dir * dist)

	local rectlines = {}
	local tl = Vector(topleft.x, topleft.y)
	local tr = Vector(botright.x, topleft.y)
	local bl = Vector(topleft.x, botright.y)
	local br = Vector(botright.x, botright.y)
	table.insert(rectlines, {p1 = tl, p2 = tr})
	table.insert(rectlines, {p1 = tr, p2 = br})
	table.insert(rectlines, {p1 = bl, p2 = br})
	table.insert(rectlines, {p1 = tl, p2 = bl})

	local intersects = false
	local intersectionPoints = {}
	local firstIntersectionPoint = nil

	for _, line in ipairs(rectlines) do
		local p = Physics.line_segment_intersection(raystart, rayend, line.p1, line.p2)
		if p ~= nil then
			table.insert(intersectionPoints, p)
		end
	end

	if table.getn(intersectionPoints) > 0 then
		intersects = true
		local minDist = math.huge

		for _, point in ipairs(intersectionPoints) do
			local d = Vector.distsq(raystart, point)
			if d < minDist then
				minDist = d
				firstIntersectionPoint = point
			end
		end	
	end

	return firstIntersectionPoint
end

function Physics.ray_in_cells(start, dir, dist)
	
end

function Physics.ray_cast(start, dir, dist, layer)
	start = start or Vector.zero
	dir = dir or Vector.unit_x
	dist = dist or 1000


end