local t = Def.ActorFrame {}

t[#t + 1] = LoadActor("frameEval")
t[#t + 1] = LoadActor("../_PlayerInfo")

translated_info = {
	Title = THEME:GetString("ScreenEvaluation", "Title"),
	Replay = THEME:GetString("ScreenEvaluation", "ReplayTitle")
}

--what the settext says
t[#t + 1] = LoadFont("Common Large") .. {
	InitCommand = function(self)
		self:xy(5, SCREEN_BOTTOM - 5):halign(0):valign(1):zoom(0.3)
		self:settext("")
	end,
	OnCommand = function(self)
		local title = translated_info["Title"]
		local ss = SCREENMAN:GetTopScreen():GetStageStats()
		if not ss:GetLivePlay() then title = translated_info["Replay"] end
		local gamename = GAMESTATE:GetCurrentGame():GetName():lower()
		if gamename ~= "dance" then
			title = gamename:gsub("^%l", string.upper) .. " " .. title
		end
		self:settextf("%s:", title)
	end,
}

--cdtitle
t[#t + 1] = UIElements.SpriteButton(1, 1, nil) .. {
	Texture= GAMESTATE:GetCurrentSong():GetCDTitlePath(),
	InitCommand=function(self)
		self:xy(SCREEN_CENTER_X - 80, SCREEN_BOTTOM - 65):bob():effectmagnitude(0,1,0)

		local height = self:GetHeight()
		local width = self:GetWidth()

		if height >= 60 and width >= 75 then
			if height * (75 / 60) >= width then
				self:zoom(60 / height)
			else
				self:zoom(75 / width)
			end
		elseif height >= 60 then
			self:zoom(60 / height)
		elseif width >= 75 then
			self:zoom(75 / width)
		else
			self:zoom(1)
		end
	end,
	ToolTipCommand = function(self)
		if isOver(self) then
			local auth = GAMESTATE:GetCurrentSong():GetOrTryAtLeastToGetSimfileAuthor()
			TOOLTIP:SetText(auth)
			TOOLTIP:Show()
		end
	end,
	MouseOverCommand = function(self)
		self:playcommand("ToolTip")
	end,
	MouseOutCommand = function(self)
		TOOLTIP:Hide()
	end,
}


--Group folder name
local frameWidth = 280
local frameHeight = 20
local frameX = SCREEN_CENTER_X
local frameY = 15

t[#t + 1] = LoadFont("Common Large") .. {
	InitCommand = function(self)
		self:xy(frameX, frameY + 12):zoom(0.3):maxwidth((frameWidth - 40) / 0.35)
	end,
	BeginCommand = function(self)
		self:queuecommand("Set"):diffuse(getMainColor("positive"))
	end,
	SetCommand = function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song ~= nil then
			self:settext(song:GetGroupName())
		end
	end
}

t[#t + 1] = LoadActor("../_cursor")

return t
