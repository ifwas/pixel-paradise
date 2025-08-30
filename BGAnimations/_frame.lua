local t = Def.ActorFrame {}
--folder
t[#t + 1] = UIElements.SpriteButton(1, 1, THEME:GetPathG("", "spr/wheel/sortorderBackground")) .. {
	InitCommand = function(self)
		self:xy(13, 20):SetTextureFiltering(false):zoom(0.455):halign(0)
		self:diffuse(ColorMultiplier(getMainColor("positive"),1.5))
	end
}

t[#t + 1] = UIElements.SpriteButton(1, 1, THEME:GetPathG("", "spr/wheel/sortorderBackground")) .. {
	InitCommand = function(self)
		self:xy(5, 20):SetTextureFiltering(false):zoom(0.45):halign(0)
		self:diffuse(ColorMultiplier(getMainColor("positive"),0.75))
		self:diffusealpha(0.2):blend(Blend.Add)
	end
}

--date
t[#t + 1] = UIElements.SpriteButton(1, 1, THEME:GetPathG("", "spr/wheel/datetimebox")) .. {
	InitCommand = function(self)
		self:xy(25, SCREEN_BOTTOM - 20):SetTextureFiltering(false):zoom(0.45):halign(0)
		self:diffuse(ColorMultiplier(getMainColor("positive"),1.5))
	end
}

t[#t + 1] = UIElements.SpriteButton(1, 1, THEME:GetPathG("", "spr/wheel/datetimebox")) .. {
	InitCommand = function(self)
		self:xy(25, SCREEN_BOTTOM - 20):SetTextureFiltering(false):zoom(0.45):halign(0)
		self:diffuse(ColorMultiplier(getMainColor("positive"),0.75))
		self:diffusealpha(0.2):blend(Blend.Add)
	end
}


return t
