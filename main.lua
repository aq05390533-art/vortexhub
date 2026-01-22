--[[
    VORTEX HUB V3 - AIM SKILLS (SIMPLE & WORKING)
]]--

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Vortex Hub V3 | Aim Skills",
    SubTitle = "Auto Aim Skills",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 300),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tab = Window:AddTab({ Title = "Aim Skills", Icon = "crosshair" })

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- الإعدادات
_G.AimSkills = {
    Enabled = true,
    Z = true,
    X = true,
    C = true,
    V = true,
    Distance = 200
}

-- الحصول على أقرب لاعب
local function GetTarget()
    local target = nil
    local dist = _G.AimSkills.Distance
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local magnitude = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if magnitude < dist then
                dist = magnitude
                target = v
            end
        end
    end
    
    return target
end

-- Hook الأزرار
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and method == "FireServer" then
        local eventName = tostring(self)
        
        -- فحص إذا كان السكل Z/X/C/V
        if _G.AimSkills.Enabled then
            if (eventName:find("Z") and _G.AimSkills.Z) or 
               (eventName:find("X") and _G.AimSkills.X) or 
               (eventName:find("C") and _G.AimSkills.C) or 
               (eventName:find("V") and _G.AimSkills.V) then
                
                local target = GetTarget()
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    -- تصويب الشخصية على الهدف
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                        LocalPlayer.Character.HumanoidRootPart.Position,
                        target.Character.HumanoidRootPart.Position
                    )
                    print("🎯 Aimed at: " .. target.Name)
                end
            end
        end
    end
    
    return OldNamecall(self, ...)
end))

-- UI
Tab:AddToggle("Enable", {
    Title = "🎯 Enable Aim Skills",
    Default = true
}):OnChanged(function(v)
    _G.AimSkills.Enabled = v
    Fluent:Notify({Title = "Aim Skills", Content = v and "Enabled ✅" or "Disabled ❌", Duration = 2})
end)

Tab:AddToggle("Z", {Title = "Z Skill", Default = true}):OnChanged(function(v) _G.AimSkills.Z = v end)
Tab:AddToggle("X", {Title = "X Skill", Default = true}):OnChanged(function(v) _G.AimSkills.X = v end)
Tab:AddToggle("C", {Title = "C Skill", Default = true}):OnChanged(function(v) _G.AimSkills.C = v end)
Tab:AddToggle("V", {Title = "V Skill", Default = true}):OnChanged(function(v) _G.AimSkills.V = v end)

Tab:AddSlider("Dist", {
    Title = "Max Distance",
    Min = 50,
    Max = 300,
    Default = 200,
    Rounding = 0
}):OnChanged(function(v)
    _G.AimSkills.Distance = v
end)

Fluent:Notify({Title = "Vortex Hub", Content = "Aim Skills Loaded!", Duration = 3})
print("✅ Aim Skills Loaded")
