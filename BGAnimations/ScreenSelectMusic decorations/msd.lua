--Local vars
local update = false
local steps
local song
local frameX = capWideScale(270,380)
local frameY = 40
local frameWidth = SCREEN_WIDTH * 0.56
local frameHeight = 368
local fontScale = 0.4
local distY = 15
local offsetX = 10
local offsetY = 20
local pn = GAMESTATE:GetEnabledPlayers()[1]
local greatest = 0
local txtDist = 29
local steps
local meter = {}
meter[1] = 0.00

local cd -- chord density graph

local translated_text = {
	AverageNPS = THEME:GetString("TabMSD", "AverageNPS"),
	NegBPM = THEME:GetString("TabMSD", "NegativeBPM"),
	Title = THEME:GetString("TabMSD", "Title")
}

--Actor Frame
local t = Def.ActorFrame {
	Name = "MSDTab",
	BeginCommand = function(self)
		cd = self:GetChild("ChordDensityGraph")
		cd:xy(frameX + offsetX + 145, frameY + 122):visible(false)
		self:queuecommand("Set"):visible(false)
	end,
	OffCommand = function(self)
		self:bouncebegin(0.2):xy(500, 0):diffusealpha(0)
		self:sleep(0.04):queuecommand("Invis")
	end,
	InvisCommand= function(self)
		self:visible(false)
	end,
	OnCommand = function(self)
		self:bouncebegin(0.2):xy(0, 0):diffusealpha(1)
	end,
	SetCommand = function(self)
		self:finishtweening()
		if getTabIndex() == 1 then
			self:queuecommand("On")
			self:visible(true)
			song = GAMESTATE:GetCurrentSong()
			steps = GAMESTATE:GetCurrentSteps()

			--Find max MSD value, store MSD values in meter[]
			-- I plan to have c++ store the highest msd value as a separate variable to aid in the filter process so this won't be needed afterwards - mina
			greatest = 0
			if song and steps then
				for i = 1, #ms.SkillSets do
					meter[i + 1] = steps:GetMSD(getCurRateValue(), i)
					if meter[i + 1] > meter[greatest + 1] then
						greatest = i
					end
				end
			end

			if song and steps then
				cd:visible(true)
				cd:queuecommand("GraphUpdate")
			else
				cd:visible(false)
			end
			update = true
		else
			self:queuecommand("Off")
			cd:visible(false)
			update = false
		end
	end,
	CurrentRateChangedMessageCommand = function(self)
		self:playcommand("Set")
	end,
	CurrentStepsChangedMessageCommand = function(self)
		if getTabIndex() == 1 then
			self:queuecommand("Set")
		end
	end,
	TabChangedMessageCommand = function(self)
		self:queuecommand("Set")
	end,
}

--BG quad
t[#t + 1] = Def.Sprite {
	InitCommand = function(self)
		self:xy(frameX - 10, frameY):zoom(0.44):halign(0):valign(0)
		self:Load(THEME:GetPathG("","spr/tab/TemplateTabBox")):SetTextureFiltering(false)
		self:diffuse(getMainColor("positive"))
	end
}

--Skillset label function
local function littlebits(i)
	local t = Def.ActorFrame {
		LoadFont("Common Large") .. {
			InitCommand = function(self)
				self:xy(frameX + offsetX + 150, frameY + 100 + txtDist * i):halign(0):valign(0):zoom(0.55):maxwidth(155 / 0.55)
			end,
			SetCommand = function(self)
				--skillset name
				if song and steps then
					self:settext(ms.SkillSetsTranslated[i] .. ":")
				else
					self:settext("")
				end
				--highlight
				if greatest == i then
					self:diffusetopedge(Saturation(getMainColor("highlight"), 0.5))
					self:diffusebottomedge(Saturation(getMainColor("positive"), 0.6))
				end
			end
		},
		LoadFont("Common Large") .. {
			InitCommand = function(self)
				self:xy(frameX + capWideScale(270, 450), frameY + 100 + txtDist * i):halign(1):valign(0):zoom(0.55):maxwidth(110 / 0.55)
			end,
			SetCommand = function(self)
				if song and steps then
					self:settextf("%05.2f", meter[i + 1])
					self:diffuse(byMSD(meter[i + 1]))
				else
					self:settext("")
				end
			end
		}
	}
	return t
end

--Tab Title
t[#t + 1] = LoadFont("Common Normal") .. {
	InitCommand = function(self)
		self:xy(frameX + 450, frameY + offsetY - 3):zoom(0.5):halign(1)
		self:settextf("%s (Calc v%s)",translated_text["Title"], GetCalcVersion())
		self:diffuse(Saturation(getMainColor("positive"), 0.1))
	end
}
--Song Title
t[#t + 1] = LoadFont("Common Large") .. {
	InitCommand = function(self)
		self:xy(frameX + 450, frameY + 35):zoom(0.3):halign(1):diffuse(getMainColor("positive"))
		self:maxwidth(SCREEN_CENTER_X / 0.3)
		self:diffusetopedge(Saturation(getMainColor("highlight"), 0.5))
		self:diffusebottomedge(Saturation(getMainColor("positive"), 0.6))
	end,
	SetCommand = function(self)
		if song then
			self:settext(song:GetDisplayMainTitle())
		else
			self:settext("")
		end
	end
}

-- Music Rate Display
t[#t + 1] = LoadFont("Common Large") .. {
	InitCommand = function(self)
		self:xy(frameX + capWideScale(290,440), frameY + offsetY + 44):visible(true):halign(1):zoom(0.3)
	end,
	SetCommand = function(self)
		if steps then
			self:settext(getCurRateDisplayString(true))
		else
			self:settext("")
		end
	end
}

--Difficulty
t[#t + 1] = LoadFont("Common Normal") .. {
	Name = "StepsAndMeter",
	InitCommand = function(self)
		self:xy(frameX + offsetX + 270, frameY + offsetY + 44):zoom(0.5):halign(1):maxwidth(350)
	end,
	SetCommand = function(self)
		steps = GAMESTATE:GetCurrentSteps()
		if steps ~= nil then
			local diff = getDifficulty(steps:GetDifficulty())
			local stype = ToEnumShortString(steps:GetStepsType()):gsub("%_", " ")
			local meter = steps:GetMeter()
			if update then
				self:settext(stype .. " " .. diff .. " " .. meter)
				self:diffuse(getDifficultyColor(GetCustomDifficulty(steps:GetStepsType(), steps:GetDifficulty())))
			end
		else
			self:settext("")
		end
	end
}

--NPS
t[#t + 1] = LoadFont("Common Normal") .. {
	Name = "NPS",
	InitCommand = function(self)
		self:xy(frameX + offsetX + 380, frameY + offsetY + 44):zoom(0.45):halign(1)
	end,
	SetCommand = function(self)
		steps = GAMESTATE:GetCurrentSteps()
		--local song = GAMESTATE:GetCurrentSong()
		local notecount = 0
		local length = 1
		if steps ~= nil and song ~= nil and update then
			length = steps:GetLengthSeconds()
			if length == 0 then length = 1 end
			notecount = steps:GetRadarValues(pn):GetValue("RadarCategory_Notes")
			self:settextf("%0.2f %s", notecount / length, translated_text["AverageNPS"])
			self:diffuse(Saturation(getDifficultyColor(GetCustomDifficulty(steps:GetStepsType(), steps:GetDifficulty())), 0.3))
		else
			self:settext("")
		end
	end
}


--Skillset labels
for i = 1, #ms.SkillSets do
	t[#t + 1] = littlebits(i)
end

t[#t + 1] = LoadActor("../_chorddensitygraph.lua")

return t
