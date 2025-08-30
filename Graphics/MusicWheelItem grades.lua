return Def.ActorFrame {
	Def.Quad { --todo: modify to make it fancier, use an icon, dunno
		InitCommand = function(self)
			self:xy(350, -2):zoomto(4, 30):fadetop(0.5):fadebottom(0.5)
		end,
		SetGradeCommand = function(self, params)
			if params.HasGoal then
				if not params.AllGoalsComplete then
					self:diffuse(byJudgment("TapNoteScore_Miss"))
				else
					self:diffuse(byJudgment("TapNoteScore_W1"))
				end
				self:diffusealpha(1)
			else
				self:diffusealpha(0)
			end
		end
	},
	LoadFont("Common Normal") .. {
		InitCommand = function(self)
			self:xy(14, 14):zoom(0.55):maxwidth(WideScale(get43size(20), 20) / 0.5)
		end,
		SetGradeCommand = function(self, params)
			local sGrade = params.Grade or "Grade_None"
			self:valign(0.5):halign(0)
			self:settext(THEME:GetString("Grade", ToEnumShortString(sGrade)) or "")
			self:diffuse(getGradeColor(sGrade))
		end
	},
	Def.Sprite {
		InitCommand = function(self)
			self:xy(355, 10):zoomto(4, 19):halign(0)
		end,
		SetGradeCommand = function(self, params)
			if params.PermaMirror then
				self:Load(THEME:GetPathG("", "mirror"))
				self:zoomto(15, 15)
				self:visible(true)
			else
				self:visible(false)
			end
		end
	},
	Def.Sprite {
		InitCommand = function(self)
			self:xy(355, -15):zoomto(15, 15)
		end,
		SetGradeCommand = function(self, params)
			if params.Favorited then
				self:Load(THEME:GetPathG("", "favorite"))
				self:zoomto(15, 15)
				self:visible(true)
			else
				self:visible(false)
			end
		end
	}
}
