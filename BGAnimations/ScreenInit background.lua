local t = Def.ActorFrame {}
local minanyms = {
	"Who?"
}

math.random()

local t = Def.ActorFrame {}

-- background iamge (easily replaceable)
t[#t + 1] = Def.Sprite {
    InitCommand = function(self)
        self:Center()
        self:Load(THEME:GetPathG("", "startup")) -- Cfvhange "image" to match your filename.
        self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
        self:diffusealpha(0)
        self:linear(1):diffusealpha(1)
        self:sleep(1.75)
        self:linear(1.5):diffusealpha(0)
    end
}

-- BLACKBAR!!!! BAR!!! pub... need beer... N E E D   B E E R
t[#t + 1] = Def.Quad {
    InitCommand = function(self)
        self:Center()
        self:zoomto(SCREEN_WIDTH, 250) 
        self:diffuse(color("#000000"))
        self:diffusealpha(0.7) 
        self:diffusealpha(0)
        self:sleep(0.5):linear(1):diffusealpha(0.7):sleep(1.75)
        self:linear(2):diffusealpha(0)
    end
}

-- etterna!!!!!
t[#t + 1] = LoadFont("Common Large") .. {
    InitCommand = function(self)
        self:CenterX():y(SCREEN_CENTER_Y - 80)
        self:settext("Etterna Project")
        self:diffuse(color("#FFFFFF"))
        self:diffusealpha(0)
        self:sleep(0.5):linear(1):diffusealpha(1):sleep(1.75)
        self:linear(2):diffusealpha(0)
    end
}

-- theme name
t[#t + 1] = LoadFont("Common Normal") .. {
    InitCommand = function(self)
        self:CenterX():y(SCREEN_CENTER_Y - 40)
        self:settext("Pixel Paradise")
        self:diffuse(color("#CCCCCC"))
        self:diffusealpha(0)
        self:sleep(0.5):linear(1):diffusealpha(1):sleep(1.75)
        self:linear(2):diffusealpha(0)
    end
}

-- disclaimeryer
t[#t + 1] = LoadFont("Common Normal") .. {
    InitCommand = function(self)
        self:CenterX():y(SCREEN_CENTER_Y + 10)
        self:settext("This theme is a work of fiction. All characters and organizations that appear have passed into fantasy.")
        self:zoom(0.6)
        self:diffuse(color("#66CC66"))
        self:diffusealpha(0)
        self:sleep(0.5):linear(1):diffusealpha(1):sleep(1.75)
        self:linear(2):diffusealpha(0)
    end
}

-- credit
t[#t + 1] = LoadFont("Common Normal") .. {
    InitCommand = function(self)
        self:CenterX():y(SCREEN_CENTER_Y + 80)
        self:settext("themed by\n\nMartzi and Reimuboobs")
        self:diffuse(color("#FFFFFF"))
        self:diffusealpha(0)
        self:zoom(0.7)
        self:sleep(0.5):linear(1):diffusealpha(1):sleep(1.75)
        self:linear(2):diffusealpha(0)
    end
}



return t
