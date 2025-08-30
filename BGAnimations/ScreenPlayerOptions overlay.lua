local t = Def.ActorFrame {}
local topFrameHeight = 35
local bottomFrameHeight = 54
local borderWidth = 4

local widescreen = GetScreenAspectRatio() > 1.7

local t =
	Def.ActorFrame {
	Name = "PlayerAvatar"
}

curGameVolume = PREFSMAN:GetPreference("SoundVolume")


local profileP1

local profileNameP1 = THEME:GetString("GeneralInfo", "NoProfile")
local playCountP1 = 0
local playTimeP1 = 0
local noteCountP1 = 0

local AvatarXP1 = 5
local AvatarYP1 = 44

local bpms = {}
if GAMESTATE:GetCurrentSong() then
	bpms = GAMESTATE:GetCurrentSong():GetDisplayBpms(false)
	bpms[1] = math.round(bpms[1])
	bpms[2] = math.round(bpms[2])
end

t[#t + 1] =
	Def.Actor {
	BeginCommand = function(self)
		self:queuecommand("Set")
	end,
	SetCommand = function(self)
		if GAMESTATE:IsPlayerEnabled() then
			profileP1 = GetPlayerOrMachineProfile(PLAYER_1)
			if profileP1 ~= nil then
				profileNameP1 = profileP1:GetDisplayName()
				playCountP1 = profileP1:GetTotalNumSongsPlayed()
				playTimeP1 = profileP1:GetTotalSessionSeconds()
				noteCountP1 = profileP1:GetTotalTapsAndHolds()
			else
				profileNameP1 = THEME:GetString("GeneralInfo", "NoProfile")
				playCountP1 = 0
				playTimeP1 = 0
				noteCountP1 = 0
			end
		else
			profileNameP1 = THEME:GetString("GeneralInfo", "NoProfile")
			playCountP1 = 0
			playTimeP1 = 0
			noteCountP1 = 0
		end
	end
}

--header
t[#t + 1] =
	LoadFont("Common Normal") ..
	{
		InitCommand = function(self)
			self:xy(75, 24):halign(0):valign(0):zoom(0.7):diffuse(color(skinConfig["Overlays"]["Header"]))
			self:settextf("%s", THEME:GetString("ScreenPlayerOptions", "Title"))
			self:diffusealpha(0)
		end,
		OnCommand = function(self)
			self:decelerate(0.2)
			self:diffusealpha(1)
		end
	}

local NSPreviewSize = 1
local NSPreviewX = SCREEN_CENTER_X + 150
local NSPreviewY = SCREEN_CENTER_Y - 32
local NSPreviewXSpan = 64
local NSPreviewReceptorY = 64
local OptionRowHeight = 18
local NoteskinRow = 0
local NSDirTable = GameToNSkinElements()

local function NSkinPreviewWrapper(dir, ele)
	return Def.ActorFrame {
		InitCommand = function(self)
			self:zoom(NSPreviewSize)
		end,
		LoadNSkinPreview("Get", dir, ele, PLAYER_1)
	}
end
local function NSkinPreviewExtraTaps()
	local out = Def.ActorFrame {}
	for i = 1, #NSDirTable do
		if i ~= 2 then
			out[#out+1] = Def.ActorFrame {
				Def.ActorFrame {
					InitCommand = function(self)
						self:x(NSPreviewXSpan * (i-1))
					end,
					NSkinPreviewWrapper(NSDirTable[i], "Tap Note")
				},
				Def.ActorFrame {
					InitCommand = function(self)
						self:x(NSPreviewXSpan * (i-1)):y(NSPreviewReceptorY)
					end,
					NSkinPreviewWrapper(NSDirTable[i], "Receptor")
				}
			}
		end
	end
	return out
end
t[#t + 1] =
	Def.ActorFrame {
	OnCommand = function(self)
		self:visible(true)
		self:xy(NSPreviewX, NSPreviewY)
		for i = 0, SCREENMAN:GetTopScreen():GetNumRows() - 1 do
			if SCREENMAN:GetTopScreen():GetOptionRow(i) and SCREENMAN:GetTopScreen():GetOptionRow(i):GetName() == "NoteSkins" then
				NoteskinRow = i
			end
		end
		self:SetUpdateFunction(
			function(self)
				local row = SCREENMAN:GetTopScreen():GetCurrentRowIndex(PLAYER_1)
				local pos = 0
				if row > 4 then
					pos =
						NSPreviewY + NoteskinRow * OptionRowHeight -
						(SCREENMAN:GetTopScreen():GetCurrentRowIndex(PLAYER_1) - 4) * OptionRowHeight
				else
					pos = NSPreviewY + NoteskinRow * OptionRowHeight
				end
				self:y(NSPreviewY)
				self:visible(true)
			end
		)
	end,
	Def.ActorFrame {
		InitCommand = function(self)
			if widescreen then
				self:x(NSPreviewXSpan)
			else
				self:x(NSPreviewXSpan/4)
			end
		end,
		NSkinPreviewWrapper(NSDirTable[2], "Tap Note")
	},
	Def.ActorFrame {
		InitCommand = function(self)
			if widescreen then
				self:x(NSPreviewXSpan)
			else
				self:x(NSPreviewXSpan/4)
			end
			self:y(NSPreviewReceptorY)
		end,
		NSkinPreviewWrapper(NSDirTable[2], "Receptor")
	}
}

t[#t][#(t[#t]) + 1] = NSkinPreviewExtraTaps()

return t
