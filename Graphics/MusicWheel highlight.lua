return Def.ActorFrame {
	Def.Quad {
		Name = "Horizontal",
		InitCommand = function(self)
			self:xy(-493, 0):zoomto(340, 43):halign(0):fadeleft(1)
		end,
		SetCommand = function(self)
			self:diffuseramp()
			self:effectcolor1(color("#FFFFFF23"))
			self:effectclock("beat")
			self:effectcolor2(color("#FFFFFF33"))
		end,
		BeginCommand = function(self)
			self:queuecommand("Set")
		end,
		OffCommand = function(self)
			self:visible(false)
		end
	}
}
