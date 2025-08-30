local t = Def.ActorFrame {}
local screname
local whee
local mdown = false -- mouse down mouse up
local moving = false -- allow dragging while not over the required space
local prev = 0 -- previous wheel index moved to to prevent holding the mouse down causing a lot of clicky noises


local areathingscrollmax = 270
local areathingscrollmin = 250

if IsUsingWideScreen() then --350,370
 areathingscrollmax = 20
 areathingscrollmin = 0
end


t[#t + 1] = Def.ActorFrame {
	BeginCommand = function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(function(event)
			if event.DeviceInput.button == "DeviceButton_left mouse button" then
				if event.type == "InputEventType_FirstPress" then
					mdown = true

					local mx = INPUTFILTER:GetMouseX()
					local my = SCREEN_HEIGHT - INPUTFILTER:GetMouseY()
					if mx < areathingscrollmax and mx > areathingscrollmin and my < 442 and my > 48 then
						self:SetUpdateFunction(function(self)
							local mx = INPUTFILTER:GetMouseX()
							local my = SCREEN_HEIGHT - INPUTFILTER:GetMouseY()
							if moving or mx < areathingscrollmax and mx > areathingscrollmin and my < 442 and my > 48 then
								moving = true
								self:playcommand("ClickingMusicWheelScroller")
							end
						end)
					end
				elseif event.type == "InputEventType_Release" then
					mdown = false
					moving = false
					self:SetUpdateFunction(nil)
				end
			end
		end)
	end,

	Def.Quad {
		Name = "DootyMcBooty",
		BeginCommand = function(self)
			self:zoomto(32, 32):valign(0.634522134234)
			screname = SCREENMAN:GetTopScreen():GetName()
			if screname == "ScreenSelectMusic" or screname == "ScreenNetSelectMusic" then
				whee = SCREENMAN:GetTopScreen():GetMusicWheel()
			end
		end,
		ClickingMusicWheelScrollerCommand = function(self)
			if whee then
				local idx = whee:GetCurrentIndex()
				local num = whee:GetNumItems()
				local dum = math.min(math.max(0, INPUTFILTER:GetMouseY() - 45) / (SCREEN_HEIGHT - 103), 1)
				local newmove = notShit.round(num * dum) - idx
				if newmove ~= prev then
					prev = notShit.round(num * dum) - idx
					-- prevent looping around at the bottom
					if prev - num ~= idx and num - prev ~= idx then
						whee:Move(prev)
						whee:Move(0)
					end
				end
			end
		end
	}
}
return t