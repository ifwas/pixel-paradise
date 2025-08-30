t = Def.ActorFrame { }

t[#t + 1] = LoadActor(THEME:GetPathG("", "_OptionsScreen")) ..  {
	OnCommand = function(self)
		self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center():diffusealpha(0.1)
	end
}

return t
