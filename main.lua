--[[
     ╔════════════════════════════════════════════╗
     ║               VORTEX HUB                   ║
     ║           The Best Blox Fruits Script      ║
     ║                2025 - 2026                 ║
     ╚════════════════════════════════════════════╝
]]--

repeat wait() until game:IsLoaded()
if game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.PlaceId ~= 7447072717 then
    game.Players.LocalPlayer:Kick("Vortex Hub Only Works On Blox Fruits Dumbass")
    return
end

local VortexHub = {}
VortexHub.Name = "Vortex Hub"
VortexHub.Version = "1.0.0"
VortexHub.Team = getgenv().Team or "Marines"

-- مكتبة الـ UI (أقوى وأجمل واحدة حاليًا 2025)
loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/UI-Libraries/main/Vynixius/Source.lua"))()

local GUI = Library:Create{
    Name = "Vortex Hub",
    Theme = "Dark",
    Size = UDim2.fromOffset(600, 400),
    Position = UDim2.fromScale(0.5, 0.5),
    Draggable = true,
    AccentColor = Color3.fromRGB(0, 170, 255)
}

GUI:Notify{
    Title = "Vortex Hub",
    Message = "Loaded Successfully!\nTeam: "..VortexHub.Team.."\nWelcome Bro <3",
    Duration = 8
}

local Tab1 = GUI:Tab{
    Name = "Main Features",
    Icon = "http://www.roblox.com/asset/?id=7733964640"
}

Tab1:Button{
    Name = "Auto Farm Level (Best Method 2025)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realvortexlol/vortexhub/main/autofarm.lua"))()
    end
}

Tab1:Button{
    Name = "Auto Sea King / Leviathan",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realvortexlol/vortexhub/main/seaking.lua"))()
    end
}

Tab1:Button{
    Name = "Auto Mirage + Gear",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realvortexlol/vortexhub/main/mirage.lua"))()
    end
}

Tab1:Button{
    Name = "Server Hop (Lowest Ping)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realvortexlol/vortexhub/main/serverhop.lua"))()
    end
}

-- تبويب الستاتس
local Tab2 = GUI:Tab{
    Name = "Stats & Combat",
    Icon = "http://www.roblox.com/asset/?id=7734058919"
}

Tab2:Toggle{
    Name = "Auto Stats (Melee + Defense + Sword)",
    Callback = function(state)
        getgenv().AutoStats = state
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realvortexlol/vortexhub/main/autostats.lua"))()
    end
}

-- تبويب الميسك
local Tab3 = GUI:Tab{
    Name = "Misc",
    Icon = "http://www.roblox.com/asset/?id=7733774602"
}

Tab3:Button{
    Name = "FPS Boost (Ultra)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realvortexlol/vortexhub/main/fpsboost.lua"))()
    end
}

Tab3:Button{
    Name = "Rejoin Server",
    Callback = function() 
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
}

print("Vortex Hub Loaded Successfully | Made by [اسمك هنا]")

return VortexHub
