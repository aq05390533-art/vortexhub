local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

local GUI = Mercury:Create{
    Name = "Vortex Hub",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "https://github.com/aq05390533-art/vortexhub"
}

local Tab = GUI:Tab{
	Name = "Main",
	Icon = "rbxassetid://8569322835"
}

Tab:Toggle{
	Name = "Auto Farm Level",
	StartingState = false,
	Description = nil,
	Callback = function(state)
        getgenv().AutoFarm = state
	end
}

Tab:Toggle{
	Name = "Auto Farm Mastery",
	StartingState = false,
	Description = nil,
	Callback = function(state)
        getgenv().AutoMastery = state
	end
}

Tab:Button{
	Name = "FPS Boost",
	Description = nil,
	Callback = function()
        for i,v in pairs(game:GetDescendants()) do
            if v:IsA("Part") then v.Material = "Plastic" end
        end
	end
}

Tab:Button{
	Name = "Server Hop",
	Description = nil,
	Callback = function()
        -- Server hop code
	end
}

GUI:Notification{
	Title = "Vortex Hub",
	Text = "Loaded Successfully!",
	Duration = 5,
	Callback = function() end
}
