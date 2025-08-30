local enabled = PREFSMAN:GetPreference("ShowBackgrounds")
local brightness = 0.45
local t = Def.ActorFrame {}

if enabled then
	t[#t + 1] = Def.Sprite {
		OnCommand = function(self)
			if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSong():GetBackgroundPath() then
				self:finishtweening()
				self:visible(true)
				self:LoadBackground(GAMESTATE:GetCurrentSong():GetBackgroundPath())
				self:scaletocover(0, 0, SCREEN_WIDTH, SCREEN_BOTTOM)
				self:diffusealpha(brightness)
			else
				self:visible(false)
			end
		end
	}
end

t[#t + 1] = Def.Sprite {
	Name = "BGDitheringEffect",
	OnCommand = function(self)
		self:LoadBackground(THEME:GetPathG("", "spr/evaluation/dither"))
		self:FullScreen():zoom(0.45)
		self:SetTextureFiltering(false)
		self:diffuse(ColorMultiplier(getMainColor("positive"),0.75))
		self:diffusealpha(0.4)
	end
}

t[#t + 1] = Def.Sprite {
	Name = "Banner",
	OnCommand = function(self)
		self:x(SCREEN_CENTER_X + 68):y(SCREEN_CENTER_Y - 120):valign(0):halign(0)
		self:scaletoclipped(capWideScale(get43size(336), 336), capWideScale(get43size(105), 105))
		local bnpath = GAMESTATE:GetCurrentSong():GetBannerPath()
		self:visible(true)
		if not BannersEnabled() then
			self:visible(false)
		elseif not bnpath then
			bnpath = THEME:GetPathG("Common", "fallback banner")
		end
		self:LoadBackground(bnpath)
	end
}

return t
