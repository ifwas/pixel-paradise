local itsOn = false -- chart preview state
local stepsdisplayx = SCREEN_WIDTH * 0.43
local thesteps = {}

local rowwidth = 51
local rowheight = 21
local cursorwidth = 15
local cursorheight = 21

local numshown = 5
local currentindex = 1
local displayindexoffset = 0

local sd = Def.ActorFrame {
	Name = "StepsDisplay",
	InitCommand = function(self)
		self:xy(stepsdisplayx, 98):valign(0)
	end,
	OffCommand = function(self)
		self:visible(false)
	end,
	OnCommand = function(self)
		self:visible(true)
	end,
	TabChangedMessageCommand = function(self, params)
		self:finishtweening()
		if getTabIndex() < 3 and GAMESTATE:GetCurrentSong() then
			-- dont display this if the score nested tab is already online
			-- prevents repeat 3 presses to break the display
			-- (let page 2 handle this specifically)
			if params.to == 2 then
				return
			end
			self:playcommand("On")
			self:playcommand("UpdateStepsRows")
		else
			self:playcommand("Off")
		end
	end,
	CurrentSongChangedMessageCommand = function(self, song)
		local song = song.ptr
		if song then
			thesteps = song:GetChartsMatchingFilter()
			if self.nested and getTabIndex() == 2 then
				return
			end

			-- if in online scores tab it still pops up for 1 frame
			-- so the bug fixed in the above command makes a return
			-- how sad
			if getTabIndex() < 3 then
				self:playcommand("On")
			end
			self:playcommand("UpdateStepsRows")
		else
			self:playcommand("Off")
		end
	end,
	DelayedChartUpdateMessageCommand = function(self)
		local leaderboardEnabled =
			playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).leaderboardEnabled and DLMAN:IsLoggedIn()
		if leaderboardEnabled and GAMESTATE:GetCurrentSteps() then
			local chartkey = GAMESTATE:GetCurrentSteps():GetChartKey()
			if SCREENMAN:GetTopScreen():GetMusicWheel():IsSettled() then
				DLMAN:RequestChartLeaderBoardFromOnline(
					chartkey,
					function(leaderboard)
					end
				)
			end
		end
	end,
	ChartPreviewOnMessageCommand = function(self)
		if not itsOn then
			self:addx(capWideScale(12, 0)):addy(capWideScale(18, 0))
			itsOn = true
		end
	end,
	ChartPreviewOffMessageCommand = function(self)
		if itsOn then
			self:addx(capWideScale(-12, 0)):addy(capWideScale(-18, 0))
			itsOn = false
		end
	end,
	CalcInfoOnMessageCommand = function(self)
		self:x(20)
	end,
	CalcInfoOffMessageCommand = function(self)
		self:x(stepsdisplayx)
	end
}

local function stepsRows(i)
	local o = Def.ActorFrame {
		InitCommand = function(self)
			self:y(rowheight * (i - 1))
		end,
		UIElements.SpriteButton(1, 1) .. {
			InitCommand = function(self)
				self:Load(THEME:GetPathG("", "spr/wheel/StepDisplayBox")):SetTextureFiltering(false):zoom(0.35):halign(0)
			end,
			UpdateStepsRowsCommand = function(self)
				local steps = thesteps[i + displayindexoffset]
				if steps then
					self:visible(true)
					local diff = steps:GetDifficulty()
					self:diffuse(getDifficultyColor(diff))
				else
					self:visible(false)
				end
			end,
			MouseDownCommand = function(self, params)
				local steps = thesteps[i + displayindexoffset]
				if steps and params.event == "DeviceButton_left mouse button" then
					SCREENMAN:GetTopScreen():ChangeSteps(i - currentindex)
				end
			end
		},
		-- Chart defined "Meter" value, not msd (useful to have this for reference)
		LoadFont("Common Large") .. {
			InitCommand = function(self)
				self:x(rowwidth - 10):addy(-1):zoom(0.3):settext(""):halign(1):maxwidth(75)
			end,
			UpdateStepsRowsCommand = function(self)
				local steps = thesteps[i + displayindexoffset]
				if steps then
					self:settext(steps:GetMeter())
				else
					self:settext("")
				end
			end
		},
		--chart difficulty name
		LoadFont("Common Large") .. {
			InitCommand = function(self)
				self:x(12):zoom(0.18):settext(""):halign(0.5):valign(0)
			end,
			UpdateStepsRowsCommand = function(self)
				local steps = thesteps[i + displayindexoffset]
				if steps then
				local diff = steps:GetDifficulty()
					self:settext(getShortDifficulty(diff))
				else
					self:settext("")
				end
			end
		},
		--chart steps type
		LoadFont("Common Large") .. {
			InitCommand = function(self)
				self:x(12):addy(-9):zoom(0.18):settext(""):halign(0.5):valign(0):maxwidth(23 / 0.18)
			end,
			UpdateStepsRowsCommand = function(self)
				local steps = thesteps[i + displayindexoffset]
				if steps then
				local st = THEME:GetString("StepsDisplay StepsType", ToEnumShortString(steps:GetStepsType()))
					self:settext(st)
				else
					self:settext("")
				end
			end
		}
	}

	return o
end

local sdr = Def.ActorFrame {
	Name = "StepsRows",
}

for i = 1, numshown do
	sdr[#sdr + 1] = stepsRows(i)
end
sd[#sd + 1] = sdr

local center = math.ceil(numshown / 2)
-- cursor goes on top
sd[#sd + 1] = Def.Sprite{
	Name = "StepsCursor",
	Texture=THEME:GetPathG("","spr/wheel/pointer"),
	InitCommand = function(self)
		self:x(61):zoomto(cursorwidth, cursorwidth * 1.1):halign(1):valign(0.5):diffusealpha(0.6):diffuse(getMainColor("positive")):SetTextureFiltering(false)
	end,
	CurrentStepsChangedMessageCommand = function(self, steps)
		for i = 1, 20 do
			if thesteps and thesteps[i] and thesteps[i] == steps.ptr then
				currentindex = i
				break
			end
		end

		if currentindex <= center then
			displayindexoffset = 0
		elseif #thesteps - displayindexoffset > numshown then
			displayindexoffset = currentindex - center
			currentindex = center
		else
			currentindex = currentindex - displayindexoffset
		end

		if #thesteps > numshown and #thesteps - displayindexoffset < numshown then
			displayindexoffset = #thesteps - numshown
		end

		local ddddddddfffffff = thesteps[currentindex]
		local diff = ddddddddfffffff:GetDifficulty()
		self:finishtweening()
		self:smooth(0.03):y(21 * (currentindex - 1)):diffuse(getDifficultyColor(diff))

		if self:GetParent():GetVisible() then
			self:GetParent():GetChild("StepsRows"):playcommand("UpdateStepsRows")
		end
	end,
}

return sd
