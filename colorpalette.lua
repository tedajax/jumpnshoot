Class = require 'hump.class'
Color = require 'hump.color'

ColorPalette = Class
{
	name = "ColorPalette",
	function(self)
		self.palette = {}
		self.palette.default = Color.clear
	end
}

function ColorPalette:set_default(color)
	self.palette.default = color or Color.clear
end

function ColorPalette:generate(data)
	for index, color in ipairs(data) do
		self.palette[index] = color
	end
	self.palette.default = data.default or Color.clear
end

function ColorPalette:gen_test_palette()
	self:generate({Color.red, Color.green, Color.blue, Color.yellow, default = Color.clear})
end

function ColorPalette:get_color(index)
	if self.palette[index] ~= nil then
		local c = self.palette[index]
		return self.palette[index]
	else
		return self.palette.default
	end
end

function ColorPalette:create_image(data, width, height, pixelWidth, pixelHeight)
	pixelHeight = pixelHeight or pixelWidth

	local result = love.image.newImageData(width * pixelWidth, height * pixelHeight)

	local pIndex = 1
	for x = 0, (width - 1), pixelWidth do
		for y = 0, (height - 1), pixelHeight do
			for px = 0, pixelWidth - 1 do
				for py = 0, pixelHeight - 1 do
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