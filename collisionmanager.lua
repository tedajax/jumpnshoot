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
		-- initialize a few cells
		for i = 1, self.maxCells do
			self.cells[i] = {}
			for j = 1, self.maxCells do
				self.cells[i][j] = {}
			end
		end
	end	
}

function CollisionManager:register(obj)
	local coll = obj:get_component("CAABoundingBox")
	if coll ~= nil then
		table.insert(self.objects, coll)
		coll.cells = self:get_object_cells(coll)

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
	local tl = self:get_cell(collObj:topleft())
	local tr = self:get_cell(collObj:topright())
	local bl = self:get_cell(collObj:bottomleft())
	local br = self:get_cell(collObj:bottomright())	

	local list = {}
	if tl ~= nil then table.insert(list, tl) end
	if tr ~= nil then table.insert(list, tr) end
	if bl ~= nil then table.insert(list, bl) end
	if br ~= nil then table.insert(list, br) end

	return Set(list)
end

function CollisionManager:object_in_cell(obj, cell)
	local tl = self:get_cell(obj:topleft())
	local tr = self:get_cell(obj:topright())
	local bl = self:get_cell(obj:bottomleft())
	local br = self:get_cell(obj:bottomright())

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

	local cells = self:get_object_cells(collObj)
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
					if o1:collides(o2) then
						if o1.collidingWith[o2] or o2.collidingWith[o1] then
							o1:send_message("on_collision_stay",o2)
							o2:send_message("on_collision_stay", o1)
						else
							o1:send_message("on_collision_enter", o2)
							o2:send_message("on_collision_enter", o1)
						end
					else
						if o1.collidingWith[o2] or o2.collidingWith[o1] then
							o1:send_message("on_collision_exit", o2)
							o2:send_message("on_collision_exit", o1)
						end
					end
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
