--[[
    VORTEX HUB V3 - AIM SKILLS (FIXED)
    ✅ يصوب تلقائياً على أقرب لاعب عند استخدام المهارات
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- الإعدادات
_G.AimSkills = {
    Enabled = true,
    Skills = {
        Z = true,
        X = true,
        C = true,
        V = true
    },
    Distance = 200,
    AutoRotate = true -- تدوير تلقائي نحو الهدف
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
    
    -- تدوير الشخصية باتجاه الهدف
    if _G.AimSkills.AutoRotate then
        local lookAtCFrame = CFrame.new(
            myChar.HumanoidRootPart.Position,
            Vector3.new(targetHRP.Position.X, myChar.HumanoidRootPart.Position.Y, targetHRP.Position.Z)
        )
        myChar.HumanoidRootPart.CFrame = lookAtCFrame
    end
    
    return true
end

-- مراقبة ضغط المهارات
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not _G.AimSkills.Enabled then return end
    
    local key = input.KeyCode.Name
    
    -- فحص إذا كان المفتاح ضمن المهارات المفعلة
    if _G.AimSkills.Skills[key] then
        local target = GetClosestPlayer()
        
        if target then
            local success = AimAtPlayer(target)
            if success then
                print("🎯 [" .. key .. "] Aimed at: " .. target.Name)
                Fluent:Notify({
                    Title = "Aim Skills",
                    Content = "🎯 Targeted: " .. target.Name,
                    Duration = 1.5
                })
            end
        else
            print("⚠️ No target found within range!")
        end
    end
end)

-- Hook لـ RemoteEvents (خيار إضافي)
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and method == "FireServer" and _G.AimSkills.Enabled then
        local eventName = tostring(self)
        
        -- فحص إذا كان الإيفنت يتعلق بالمهارات
        if eventName:match("Skill") or eventName:match("Ability") or eventName:match("Combat") then
            local target = GetClosestPlayer()
            if target then
                AimAtPlayer(target)
            end
        end
    end
    
    return OldNamecall(self, ...)
end))

-- ═══════════════════════════════════════
-- UI CONTROLS
-- ═══════════════════════════════════════

Tab:AddToggle("Enable", {
    Title = "🎯 Enable Auto Aim",
    Default = true
}):OnChanged(function(v)
    _G.AimSkills.Enabled = v
    Fluent:Notify({
        Title = "Aim Skills", 
        Content = v and "Enabled ✅" or "Disabled ❌", 
        Duration = 2
    })
end)

Tab:AddToggle("AutoRotate", {
    Title = "🔄 Auto Rotate Character",
    Default = true,
    Description = "تدوير الشخصية نحو الهدف تلقائياً"
}):OnChanged(function(v)
    _G.AimSkills.AutoRotate = v
end)

Tab:AddParagraph({Title = "⚔️ Skills Settings", Content = "فعّل/عطّل المهارات المحددة:"})

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
    Description = "أقصى مسافة للبحث عن الأهداف",
    Min = 50,
    Max = 500,
    Default = 200,
    Rounding = 0
}):OnChanged(function(v)
    _G.AimSkills.Distance = v
end)

-- زر اختبار
Tab:AddButton({
    Title = "🧪 Test Aim",
    Description = "اختبار التصويب على أقرب لاعب",
    Callback = function()
        local target = GetClosestPlayer()
        if target then
            AimAtPlayer(target)
            Fluent:Notify({
                Title = "Test",
                Content = "✅ Aimed at: " .. target.Name,
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Test",
                Content = "❌ No players nearby!",
                Duration = 2
            })
        end
    end
})

Fluent:Notify({
    Title = "Vortex Hub V3", 
    Content = "✅ Aim Skills Loaded Successfully!", 
    Duration = 3
})

print("✅ Vortex Hub - Aim Skills Loaded")
