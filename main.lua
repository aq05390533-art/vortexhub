--[[
    VORTEX HUB V3 - AIM SKILLS (FIXED - NO INPUT BLOCK)
    ✅ يصوب تلقائياً بدون تعطيل الأزرار
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

-- الإعدادات
_G.AimSkills = {
    Enabled = true,
    Skills = {
        Z = true,
        X = true,
        C = true,
        V = true
    },
    Distance = 200
}

-- الحصول على أقرب لاعب
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = _G.AimSkills.Distance
    
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then 
        return nil 
    end
    
    local myPos = myChar.HumanoidRootPart.Position
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChild("Humanoid")
                
                if hrp and hum and hum.Health > 0 then
                    local distance = (hrp.Position - myPos).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- تصويب نحو اللاعب
local function AimAtPlayer(target)
    if not target or not target.Character then return false end
    
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return false end
    
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return false end
    
    local myHRP = myChar.HumanoidRootPart
    local direction = (targetHRP.Position - myHRP.Position).Unit
    local lookAtCFrame = CFrame.new(myHRP.Position, myHRP.Position + direction)
    
    myHRP.CFrame = lookAtCFrame
    
    print("🎯 Aimed at: " .. target.Name)
    return true
end

-- Hook للـ RemoteEvents فقط (بدون تعطيل Input)
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        if _G.AimSkills.Enabled then
            local eventName = tostring(self)
            
            -- طباعة اسم الإيفنت للتشخيص
            print("🔍 Event: " .. eventName)
            
            -- فحص المهارات
            if (eventName:find("Z") or eventName:find("KeyZ")) and _G.AimSkills.Skills.Z then
                local target = GetClosestPlayer()
                if target then AimAtPlayer(target) end
                
            elseif (eventName:find("X") or eventName:find("KeyX")) and _G.AimSkills.Skills.X then
                local target = GetClosestPlayer()
                if target then AimAtPlayer(target) end
                
            elseif (eventName:find("C") or eventName:find("KeyC")) and _G.AimSkills.Skills.C then
                local target = GetClosestPlayer()
                if target then AimAtPlayer(target) end
                
            elseif (eventName:find("V") or eventName:find("KeyV")) and _G.AimSkills.Skills.V then
                local target = GetClosestPlayer()
                if target then AimAtPlayer(target) end
            end
        end
    end
    
    return OldNamecall(self, ...)
end))

-- ═══════════════════════════════════════
-- UI (بسيطة بدون مشاكل)
-- ═══════════════════════════════════════

Tab:AddToggle("Enable", {
    Title = "🎯 Enable Auto Aim",
    Default = true
}):OnChanged(function(v)
    _G.AimSkills.Enabled = v
    print(v and "✅ Enabled" or "❌ Disabled")
end)

Tab:AddToggle("Z", {Title = "Z Skill", Default = true}):OnChanged(function(v) 
    _G.AimSkills.Skills.Z = v 
end)

Tab:AddToggle("X", {Title = "X Skill", Default = true}):OnChanged(function(v) 
    _G.AimSkills.Skills.X = v 
end)

Tab:AddToggle("C", {Title = "C Skill", Default = true}):OnChanged(function(v) 
    _G.AimSkills.Skills.C = v 
end)

Tab:AddToggle("V", {Title = "V Skill", Default = true}):OnChanged(function(v) 
    _G.AimSkills.Skills.V = v 
end)

Tab:AddSlider("Dist", {
    Title = "📏 Max Distance",
    Min = 50,
    Max = 500,
    Default = 200,
    Rounding = 0
}):OnChanged(function(v)
    _G.AimSkills.Distance = v
end)

Tab:AddButton({
    Title = "🧪 Test Aim",
    Callback = function()
        local target = GetClosestPlayer()
        if target then
            AimAtPlayer(target)
            print("✅ Test: Aimed at " .. target.Name)
        else
            print("❌ No target found")
        end
    end
})

print("✅ Vortex Hub - Aim Skills Loaded")
print("📋 Press F9 to see event names")
