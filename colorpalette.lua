Class = require 'hump.class'
Color = require 'hump.color'

ColorPalette = Class
{
	name = "ColorPalette",
	function(self)
		self.palette = {}
	end
}

function ColorPalette:generate(data)
	for index, color in ipairs(data) do
		self.palette[index] = color
	end
	self.palette.default = data.default or Color.clear
end

function ColorPalette:gen_test_palette()
	self:generate({Color.red, Color.green, Color.blue, Color.yellow, default = Color.black})
end

function ColorPalette:get_color(index)
	if self.palette[index] ~= nil then
		return self.palette[index]
	else
		return self.palette.default
	end
end

function ColorPalette:create_image(data, width, height, pixelSize)
	local result = love.image.newImageData(width * pixelSize, height * pixelSize)

	local pIndex = 1
	for x = 0, (width - 1), pixelSize do
		for y = 0, (height - 1), pixelSize do
			for px = 0, pixelSize - 1 do
				for py = 0, pixelSize - 1 do
					local ix = x + px
					local iy = y + py
					result:setPixel(iy, ix, self:get_color(data[pIndex]):unpack())
				end
			end
			pIndex = pIndex + 1
		end
	end

	return love.graphics.newImage(result)
end