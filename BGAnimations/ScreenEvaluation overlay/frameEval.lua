local t = Def.ActorFrame {}
local topFrameHeight = 38
local bottomFrameHeight = 54
local borderWidth = 1.4


t[#t + 1] = UIElements.QuadButton(1, 1) .. {
	InitCommand = function(self)
		self:xy(0, 0):halign(0):valign(0):zoomto(SCREEN_WIDTH, topFrameHeight):diffuse(color("#000000"))
	end
}

t[#t + 1] = Def.Quad {
	InitCommand = function(self)
		self:xy(0, topFrameHeight):halign(0):valign(1):zoomto(SCREEN_WIDTH, borderWidth):diffuse(getMainColor("highlight"))
	end
}

return t