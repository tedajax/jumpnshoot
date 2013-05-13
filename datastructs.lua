Class = require 'hump.class'

Stack = Class
{
	name = "Stack",
	function(self) 
		self.objects = {}
		self.root = 0
		self.head = self.root
	end	
}

function Stack:push(obj)
	self.objects[self.head + 1] = obj
	self.head = self.head + 1
end

function Stack:pop()
	local result = nil
	if self.head > self.root then
		result = self.objects[self.head]
		self.head = self.head - 1
	end

	return result
end

function Stack:peek()
	return self.objects[self.head]
end

function Stack:clear()
	for i, _ in ipairs(self.objects) do
		self.objects[i] = nil
	end
	self.head = self.root
end

function Stack:size()
	return self.head
end

Queue = Class
{
	name = "Queue",
	function(self)
		self.objects = {}
		self.head = 1
		self.tail = 1	
	end
}

function Queue:push(obj)
	self.objects[self.tail] = obj
	self.tail = self.tail + 1
end

function Queue:pop()
	local result = self.objects[self.head]
	if self.tail > self.head then
		self.head = self.head + 1
		if self.head == self.tail then
			self.head = 1
			self.tail = 1
		end
	end
end

function Queue:peek()
	return self.objects[self.head]
end

function Queue:clear()
	for i, _ in ipairs(self.objects) do
		self.objects[i] = nil
	end
	self.head = 1
	self.tail = 1
end

function Queue:size()
	return self.tail - self.head
end

Set = Class
{
	name = "Set",
	function(self, list)
		self.objects = {}
		self.size = 0
		list = list or {}
		for _, l in ipairs(list) do 
			self.objects[l] = true 
			self.size = self.size + 1
		end
	end
}

function Set:add(key)
	self.objects[key] = true
	self.size = self.size + 1
end

function Set:remove(key)
	self.objects[key] = nil
	self.size = self.size - 1
end

function Set:contains(key)
	return self.objects[key] ~= nil
end
