if IsSMOnlineLoggedIn() then
	CloseConnection()
end

local t = Def.ActorFrame {}

local frameX = THEME:GetMetric("ScreenTitleMenu", "ScrollerX") - 10
local frameY = THEME:GetMetric("ScreenTitleMenu", "ScrollerY")

t[#t + 1] = Def.Sprite {
    InitCommand = function(self)
        self:Load(THEME:GetPathG("", "background.png"))
        self:FullScreen()
        self:diffusealpha(0.3)
    end
}

t[#t + 1] = LoadActor("hover.png") .. {
    InitCommand = function(self)
        self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 180):zoom(0.5)
        self:diffusealpha(1)
    end,
	OnCommand = function(self)
		self:bob():effectmagnitude(0,1,0)
    end
}

t[#t + 1] = LoadFont("Common Large") .. {
    InitCommand = function(self)
        self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 100):zoom(0.7):align(0.5, 1)
		self:settext("Pixel Paradise")
        self:diffusealpha(1)
    end
}

local playingMusic = {}
local playingMusicCounter = 1
--Version number
t[#t + 1] = UIElements.TextToolTip(1, 1, "Common Large") .. {
	Name = "Version",
	InitCommand=function(self)
		self:xy(4,frameY + 87):zoom(0.25):align(0,1)
		self:diffusetopedge(Saturation(getMainColor("highlight"), 0.5))
		self:diffusebottomedge(Saturation(getMainColor("positive"), 0.8))
	end,
	BeginCommand = function(self)
		self:settext(GAMESTATE:GetEtternaVersion())
	end,
	MouseDownCommand = function(self, params)
		if params.event == "DeviceButton_left mouse button" then
			DLMAN:ShowProjectReleases()
		end
	end
}

--game update button
local gameneedsupdating = false
local buttons = {x = 20, y = 20, width = 142, height = 42, fontScale = 0.35, color = getMainColor("frames")}
t[#t + 1] = Def.ActorFrame {
	InitCommand = function(self)
		self:xy(buttons.x,buttons.y)
	end,
	UIElements.QuadButton(1, 1) .. {
		InitCommand = function(self)
			self:zoomto(buttons.width, buttons.height):halign(0):valign(0):diffuse(buttons.color):diffusealpha(0)
			self:playcommand("LastVersionUpdated")
		end,
		LastVersionUpdatedMessageCommand = function(self)
			local latest = tonumber((DLMAN:GetLastVersion():gsub("[.]", "", 1)))
			local current = tonumber((GAMESTATE:GetEtternaVersion():gsub("[.]", "", 1)))
			if latest and latest > current then
				gameneedsupdating = true
			end
			self:playcommand("On")
		end,
		OnCommand = function(self)
			if gameneedsupdating then
				self:diffusealpha(0.3)
			end
		end,
		MouseDownCommand = function(self, params)
			if params.event == "DeviceButton_left mouse button" and gameneedsupdating then
				DLMAN:ShowProjectReleases()
			end
		end
	},
	LoadFont("Common Large") .. {
		OnCommand = function(self)
			self:xy(1.7, 1):align(0,0):zoom(buttons.fontScale):diffuse(getMainColor("positive"))
			if gameneedsupdating then
				self:settext(THEME:GetString("ScreenTitleMenu", "UpdateAvailable"))
			else
				self:settext("")
			end
		end
	}
}

local function mysplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

--random music title thingy, made by poco
t[#t+1] = Def.Actor {
    OnCommand = function(self)
        self:queuecommand("PlayMusic")
    end,
    PlayMusicCommand = function(self)
        local songfiles = FILEMAN:GetDirListing("/Themes/".. THEME:GetCurThemeName() .. "/Sounds/Title/", 0, true)
        if #songfiles > 0 then
            local randomsel = songfiles[math.random(#songfiles)]
            SOUND:StopMusic()
            SOUND:PlayMusicPart(randomsel, 0, 1000)
        else
            ms.ok("oops")
        end
    end
}

local transformF = THEME:GetMetric("ScreenTitleMenu", "ScrollerTransform")
local scrollerX = THEME:GetMetric("ScreenTitleMenu", "ScrollerX")
local scrollerY = THEME:GetMetric("ScreenTitleMenu", "ScrollerY")
local scrollerChoices = THEME:GetMetric("ScreenTitleMenu", "ChoiceNames")
local _, count = string.gsub(scrollerChoices, "%,", "")
local choices = mysplit(scrollerChoices, ",")
local choiceCount = count + 1
local i
for i = 1, choiceCount do
	t[#t + 1] = UIElements.QuadButton(1, 1) .. {
		OnCommand = function(self)
			self:xy(scrollerX, scrollerY):zoomto(260, 16)
			transformF(self, 0, i, choiceCount)
			self:addx(SCREEN_CENTER_X - 20)
			self:addy(SCREEN_CENTER_Y - 20)
			self:diffusealpha(0)
		end,
		MouseDownCommand = function(self, params)
			if params.event == "DeviceButton_left mouse button" then
				SCREENMAN:GetTopScreen():playcommand("MadeChoicePlayer_1")
				SCREENMAN:GetTopScreen():playcommand("Choose")
				if choices[i] == "Multi" or choices[i] == "GameStart" then
					GAMESTATE:JoinPlayer()
				end
				GAMESTATE:ApplyGameCommand(THEME:GetMetric("ScreenTitleMenu", "Choice" .. choices[i]))
			end
		end
	}
end

return t
