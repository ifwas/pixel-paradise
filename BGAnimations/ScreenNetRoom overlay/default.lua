local t = Def.ActorFrame { }

t[#t + 1] =
	Def.Actor {
	CodeMessageCommand = function(self, params)
		if params.Name == "AvatarShow" and not SCREENMAN:get_input_redirected(PLAYER_1) then
			SCREENMAN:SetNewScreen("ScreenAssetSettings")
		end
	end,
	OnCommand = function(self)
		inScreenSelectMusic = true
	end,
	EndCommand = function(self)
		inScreenSelectMusic = nil
	end
}

t[#t + 1] = LoadActor("../_frame")
t[#t + 1] = LoadActor("../_lightinfo")
t[#t + 1] = LoadActor("currentsort")
t[#t + 1] =
	LoadFont("Common Large") ..
	{
		InitCommand = function(self)
			self:xy(160, 25):valign(1):zoom(0.3):diffuse(getMainColor("positive"))
			self:settext(THEME:GetString("ScreenNetRoom", "Title"))
		end
	}
t[#t + 1] = LoadActor("../_cursor")
t[#t + 1] = LoadActor("../_mousewheelscroll")
t[#t + 1] = LoadActor("../_halppls")
--t[#t + 1] = LoadActor("../_userlist")
t[#t + 1] = LoadActor("../_lobbyuserlist")

return t
