t = Def.ActorFrame { }


--this dims song select
t[#t + 1] = Def.Quad {
	InitCommand=function(self)
		self:halign(0):valign(0)
		self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT)
		self:diffuse(color("#000000"))
		self:diffusealpha(0)
	end,
	OnCommand=function(self)
		self:decelerate(0.2)
		self:diffusealpha(0.8)
	end,
	Outcommand=function(self)
		self:decelerate(0.2)
		self:diffusealpha(0)
	end,
}


return t
