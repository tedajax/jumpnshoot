Class = require 'hump.class'
Vector = require 'hump.vector'
require 'datastructs'

CollisionManager = Class
{
	name = "CollisionManager",
	function(self)
		self.objects = {}

		self.cellSize = 400
		self.cells = {}
		self.maxCells = 50
		self.offset = self.maxCells / 2 * self.cellSize

		-- HACK ALERT
		-- There's issues with objects not ending their collisions if one of them happens
		-- to be on the edge of a cell
		-- we'll just increase the effective size of the collision boxes by this amount
		-- when determining if the object is in a cell or not to "fix this"
		self.fudge = 10
		self.tlFudge = Vector(-self.fudge, -self.fudge)
		self.trFudge = Vector(self.fudge, -self.fudge)
		self.blFudge = Vector(-self.fudge, self.fudge)
		self.brFudge = Vector(self.fudge, self.fudge)

		-- initialize a few cells
		for i = 1, self.maxCells do
			self.cells[i] = {}
			for j = 1, self.maxCells do
				self.cells[i][j] = {}
			end
		end
		self.cellRects = self:get_cells_as_rectangles()
	end	
}

function CollisionManager:register(obj)
	local coll = obj:get_component("CAABoundingBox")
	if coll ~= nil then
		table.insert(self.objects, coll)
		coll.cells = self:get_object_cells(coll).objects

		for cell, _ in pairs(coll.cells) do
			table.insert(cell, coll)
		end
	end
end

function CollisionManager:unregister(obj)
	-- remove the object from the objects list
	for i, o in ipairs(self.objects) do
		if obj == o then
			table.remove(self.objects, i)
			break
		end
	end

	-- find all the cells the object is in and remove it from those
	local coll = obj:get_component("CAABoundingBox")
	for cell, _ in pairs(coll.cells) do
		for i, o in ipairs(cell) do
			if o == coll then
				table.remove(cell, i)
				break
			end
		end
	end
end	

function CollisionManager:get_cell(position)
	local i, j = self:get_cell_indices(position)
	if i < 1 or i > self.maxCells or j < 1 or j > self.maxCells then return nil end

	return self.cells[i][j]
end

function CollisionManager:get_object_cells(collObj)
	local tl = self:get_cell(collObj:topleft() + self.tlFudge)
	local tr = self:get_cell(collObj:topright() + self.trFudge)
	local bl = self:get_cell(collObj:bottomleft() + self.blFudge)
	local br = self:get_cell(collObj:bottomright() + self.brFudge) 	

	local list = {}
	if tl ~= nil then table.insert(list, tl) end
	if tr ~= nil then table.insert(list, tr) end
	if bl ~= nil then table.insert(list, bl) end
	if br ~= nil then table.insert(list, br) end

	return Set(list)
end

function CollisionManager:object_in_cell(obj, cell)
	local tl = self:get_cell(obj:topleft() + self.tlFudge)
	local tr = self:get_cell(obj:topright() + self.trFudge)
	local bl = self:get_cell(obj:bottomleft() + self.blFudge)
	local br = self:get_cell(obj:bottomright()+ self.brFudge)

	return tl == cell or tr == cell or bl == cell or br == cell
end

function CollisionManager:update_object_cells(collObj)
	for cell, _ in pairs(collObj.cells) do
		if not self:object_in_cell(collObj, cell) then
			for i, o in ipairs(cell) do
				if o == collObj then
					table.remove(cell, i)
					print("removing object from cell")
					break
				end
			end
		end		
	end

	local cells = self:get_object_cells(collObj).objects
	for c1, _ in pairs(cells) do
		local found = false
		for c2, _ in pairs(collObj.cells) do
			if c1 == c2 then
				found = true
			end
		end
		if not found then
			table.insert(c1, collObj)
			print("adding object to cell")
		end
	end
	collObj.cells = cells
end

function CollisionManager:get_cell_indices(position)
	local cx = math.floor((position.x + self.offset) / self.cellSize) + 1
	local cy = math.floor((position.y + self.offset) / self.cellSize) + 1

	return cx, cy
end

function CollisionManager:collision_response(o1, o2)
	if o1.static and o2.static then return end
	if o1.static then o1, o2 = o2, o1 end
	local o1collresponse, o2collresponse = "collision", "collision"

	if o2.trigger then o1collresponse = "trigger" end
	if o1.trigger then o2collresponse = "trigger" end

	local c1, c2 = nil, nil

	if not o2.trigger then c1 = o1:collides(o2)	end
	if not o1.trigger then c2 = o2:collides(o1) end

	local param1, param2 = c1, c2
	if o2.trigger then param1 = o2 end
	if o1.trigger then param2 = o1 end

	if o1:intersects(o2) then
		if o1.collidingWith[o2] or o2.collidingWith[o1] then
			o1:send_message("on_"..o1collresponse.."_stay", param1)
			o2:send_message("on_"..o2collresponse.."_stay", param2)
		else
			o1:send_message("on_"..o1collresponse.."_enter", param1)
			o2:send_message("on_"..o2collresponse.."_enter", param2)
		end
	else
		if o1.collidingWith[o2] or o2.collidingWith[o1] then
			o1:send_message("on_"..o1collresponse.."_exit", param1)
			o2:send_message("on_"..o2collresponse.."_exit", param2)
		end
	end
end

function CollisionManager:update(dt)
	for _, obj in ipairs(self.objects) do
		if not obj.static then
			self:update_object_cells(obj)
		end
	end

	for _, row in ipairs(self.cells) do
		for _, cell in ipairs(row) do
			for i = 1, table.getn(cell) - 1 do
				for j = i + 1, table.getn(cell) do
					local o1, o2 = cell[i], cell[j]
					self:collision_response(o1, o2)
				end
			end
		end
	end
end

function CollisionManager:debug_render()
	love.graphics.setColor(255, 255, 0)
	local left = -self.offset
	local right = self.maxCells * self.cellSize - self.offset
	for i = 1, self.maxCells + 1 do
		local r = (i - 1) * self.cellSize - self.offset
		love.graphics.line(left, r, right, r)
	end

	local top = -self.offset
	local bottom = self.maxCells * self.cellSize - self.offset
	for j = 1, self.maxCells + 1 do
		local c = (j - 1) * self.cellSize - self.offset
		love.graphics.line(c, top, c, bottom)
	end
end

function CollisionManager:get_cells_as_rectangles()
	local result = {}
	for i, row in ipairs(self.cells) do
		for j, _ in ipairs(row) do
			local topleftx = (j - 1) * self.cellSize - self.offset
			local toplefty = (i - 1) * self.cellSize - self.offset
			local botrightx = j * self.cellSize - self.offset
			local botrighty = i * self.cellSize - self.offset
			table.insert(result, {tl = Vector(topleftx, toplefty), br = Vector(botrightx, botrighty)})
		end
	end

	return result
end