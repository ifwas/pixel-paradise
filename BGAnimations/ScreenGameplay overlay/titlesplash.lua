local mods = {}
local translated_info = {
	InvalidMods = THEME:GetString("ScreenGameplay", "InvalidMods"),
	By = THEME:GetString("ScreenGameplay", "CreatedBy")
}

-- splashy thing when you first start a song
local t = Def.ActorFrame {
	Name = "Splashy",
	DootCommand = function(self) self:RemoveAllChildren() end
}

t[#t + 1] = Def.ActorFrame {
	Def.Sprite {
		Name = "FileBanner",
		InitCommand = function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - -50)
			self:scaletoclipped(400, 100) -- Fixed size
			self:fadeleft(0.4):faderight(0.4)
			local song = GAMESTATE:GetCurrentSong()
			local bnpath = song and song:GetBannerPath() or SONGMAN:GetSongGroupBannerPath(song:GetGroupName())
			if not bnpath or bnpath == "" then bnpath = THEME:GetPathG("Common", "fallback banner") end
			self:LoadBackground(bnpath)
		end,
		OnCommand = function(self) self:smooth(0.5):diffusealpha(1):sleep(1):smooth(0.3):diffusealpha(0):queuecommand("Remove") end,
		RemoveCommand = function(self) self:visible(false) end
	},

	Def.Sprite {
		Name = "DitherOverlayBanner",
		Texture = THEME:GetPathG("", "dither.png"),
		InitCommand = function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - -50)
			self:scaletoclipped(400, 100)
			self:diffusealpha(0.3)
			self:fadeleft(0.4):faderight(0.4)
			self:blend("BlendMode_Add")
		end,
		OnCommand = function(self) self:smooth(0.5):diffusealpha(0.3):sleep(1):smooth(0.3):diffusealpha(0):queuecommand("Remove") end,
		RemoveCommand = function(self) self:visible(false) end
	}
}

t[#t + 1] = Def.ActorFrame {
	Def.Quad {
		Name = "PopupBG",
		InitCommand = function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 37):zoomto(400, 58):diffuse(getMainColor("highlight"))
			self:fadeleft(0.4):faderight(0.4):diffusealpha(0)
		end,
		OnCommand = function(self) self:smooth(0.5):diffusealpha(1):sleep(1):smooth(0.3):diffusealpha(0):queuecommand("Remove") end,
		RemoveCommand = function(self) self:visible(false) end
	},

	Def.Sprite {
		Name = "DitherOverlayPopup",
		Texture = THEME:GetPathG("", "dither.png"),
		InitCommand = function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 37)
			self:zoomto(400, 58)
			self:diffusealpha(0.1)
			self:fadeleft(0.4):faderight(0.4)
			self:blend("BlendMode_Add")
		end,
		OnCommand = function(self) self:smooth(0.5):diffusealpha(0.3):sleep(1):smooth(0.3):diffusealpha(0):queuecommand("Remove") end,
		RemoveCommand = function(self) self:visible(false) end
	}
}

t[#t + 1] = Def.ActorFrame {
	LoadFont("Common Large") .. {
		Name = "SongTitle",
		InitCommand = function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 50):zoom(0.5):diffusealpha(0):maxwidth(400 / 0.45)
		end,
		BeginCommand = function(self) self:settext(GAMESTATE:GetCurrentSong():GetDisplayMainTitle()) end,
		OnCommand = function(self) self:smooth(0.5):diffusealpha(1):sleep(1):smooth(0.3):diffusealpha(0):queuecommand("Remove") end,
		RemoveCommand = function(self) self:visible(false) end
	},

	LoadFont("Common Normal") .. {
		Name = "SongSubtitle",
		InitCommand = function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 35):zoom(0.45):diffusealpha(0):maxwidth(400 / 0.45)
		end,
		BeginCommand = function(self) self:settext(GAMESTATE:GetCurrentSong():GetDisplaySubTitle()) end,
		OnCommand = function(self) self:smooth(0.5):diffusealpha(1):sleep(1):smooth(0.3):diffusealpha(0):queuecommand("Remove") end,
		RemoveCommand = function(self) self:visible(false) end
	},

	LoadFont("Common Normal") .. {
		Name = "SongArtist",
		InitCommand = function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 25):zoom(0.45):diffusealpha(0) end,
		BeginCommand = function(self) self:settext(GAMESTATE:GetCurrentSong():GetDisplayArtist()) end,
		OnCommand = function(self) self:smooth(0.5):diffusealpha(1):sleep(1):smooth(0.3):diffusealpha(0):queuecommand("Remove") end,
		RemoveCommand = function(self) self:visible(false) end
	},

	LoadFont("Common Normal") .. {
		Name = "SimfileAuthor",
		InitCommand = function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 15):zoom(0.3):diffusealpha(0) end,
		BeginCommand = function(self)
			local auth = GAMESTATE:GetCurrentSong():GetOrTryAtLeastToGetSimfileAuthor()
			self:settextf("%s: %s", translated_info["By"], auth)
		end,
		OnCommand = function(self) self:smooth(0.5):diffusealpha(1):sleep(1):smooth(0.3):diffusealpha(0):queuecommand("Remove") end,
		RemoveCommand = function(self) self:visible(false) end
	}
}

return t
