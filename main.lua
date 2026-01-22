--[[
    VORTEX HUB V3 - AIM SKILLS (SAFE VERSION)
    ✅ بدون أي تعقيدات أو مشاكل
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

-- إعدادات بسيطة
_G.AimSkills = {
    Enabled = false,
    Distance = 200
}

-- إيجاد أقرب لاعب
local function GetTarget()
    local target = nil
    local dist = _G.AimSkills.Distance
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
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

-- تصويب بسيط
local function Aim(target)
    if not target or not target.Character then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local myHRP = LocalPlayer.Character.HumanoidRootPart
    local targetHRP = target.Character.HumanoidRootPart
    
    -- تدوير بسيط نحو الهدف
    local direction = (targetHRP.Position - myHRP.Position).Unit
    myHRP.CFrame = CFrame.new(myHRP.Position, myHRP.Position + direction)
    
    print("🎯 Aimed: " .. target.Name)
end

-- Hook آمن
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if _G.AimSkills.Enabled and method == "FireServer" then
        local name = tostring(self)
        
        -- اطبع اسم الإيفنت للتشخيص
        print("Event:", name)
        
        -- إذا كان الإيفنت متعلق بالمهارات
        if name:lower():find("skill") or name:lower():find("combat") or name:lower():find("ability") then
            local target = GetTarget()
            if target then
                Aim(target)
            end
        end
    end
    
    return old(self, ...)
end)

setreadonly(mt, true)

-- ═══════════════════════════════════════
-- UI بسيطة
-- ═══════════════════════════════════════

local MainToggle = Tab:AddToggle("MainToggle", {
    Title = "🎯 Enable Aim",
    Default = false
})

MainToggle:OnChanged(function(v)
    _G.AimSkills.Enabled = v
    if v then
        Fluent:Notify({Title = "Aim Skills", Content = "✅ Enabled", Duration = 2})
    else
        Fluent:Notify({Title = "Aim Skills", Content = "❌ Disabled", Duration = 2})
    end
end)

local DistSlider = Tab:AddSlider("DistSlider", {
    Title = "Max Distance",
    Min = 50,
    Max = 300,
    Default = 200,
    Rounding = 0
})

DistSlider:OnChanged(function(v)
    _G.AimSkills.Distance = v
end)

Tab:AddButton({
    Title = "Test",
    Callback = function()
        local target = GetTarget()
        if target then
            Aim(target)
            Fluent:Notify({Title = "Test", Content = "Aimed at: " .. target.Name, Duration = 2})
        else
            Fluent:Notify({Title = "Test", Content = "No target!", Duration = 2})
        end
    end
})

Tab:AddParagraph({
    Title = "📋 Instructions",
    Content = "1. Enable the toggle\n2. Use your skills (Z/X/C/V)\n3. Check F9 console for event names"
})

Fluent:Notify({
    Title = "Vortex Hub", 
    Content = "Loaded! Press F9 to see events", 
    Duration = 3
})

print("✅ Loaded - Press F9 and use skills to see event names")
