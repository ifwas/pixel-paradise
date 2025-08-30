local lastclick = GetTimeSinceStart()
local requiredtimegap = 0.1
local t =  Def.ActorFrame{}

t[#t + 1] = UIElements.SpriteButton(1, 1, THEME:GetPathG("", "spr/wheel/ItemWheel")) .. {
		InitCommand = function(self)
			self:halign(0)
			self:xy(0,0)
			self:diffusealpha(1)
			self:zoomto(354, 57)
		end,
        SetCommand = function(self, params)
            self.index = params.DrawIndex
        end,
		MouseDownCommand = function(self, params) 
            if params.event == "DeviceButton_left mouse button" then
                local now = GetTimeSinceStart()
                if now - lastclick < requiredtimegap then return end
                lastclick = now

                local numwheelitems = 10 
                local middle = 6 --the thing to fix this code in order to be compatible with 10 wheelitems will deriviate from me inventing a new term for magic numbers: voodoo numbers 
                local top = SCREENMAN:GetTopScreen()
                local we = top:GetMusicWheel()
                if we then
                    local dist = self.index - middle
                    if dist == 0 and we:IsSettled() then
                        -- clicked current item
                        top:SelectCurrent()
                    else
                        local itemtype = we:MoveAndCheckType(self.index - middle)
                        we:Move(0)
                        if itemtype == "WheelItemDataType_Section" then
                            -- clicked a group
                            top:SelectCurrent()
                        end
                    end
                end
            elseif params.event == "DeviceButton_right mouse button" then
                -- right click opens playlists
                local tind = getTabIndex()
	    		setTabIndex(7)
    			MESSAGEMAN:Broadcast("TabChanged", {from = tind, to = 7})
            end
		end,
}

t[#t + 1] = LoadFont("Common Normal") .. {
		InitCommand = function(self)
			self:xy(25, 14):zoom(0.55):maxwidth(WideScale(get43size(20), 20) / 0.5)
		end,
		SetGradeCommand = function(self, params)
			local song = params.Song 
			if song then
				local meter = params.ChartKey
				self:settext(meter)
            end
		end
}

return t
