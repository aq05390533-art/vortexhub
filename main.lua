--[[
    VORTEX HUB V3 - AIM SKILLS (FIXED 100%)
    ✅ يصوب تلقائياً عند استخدام Z/X/C/V
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
local VirtualInputManager = game:GetService("VirtualInputManager")

-- الإعدادات
_G.AimSkills = {
    Enabled = true,
    Skills = {
        ["Z"] = true,
        ["X"] = true,
        ["C"] = true,
        ["V"] = true
    },
    Distance = 200,
    Debug = true -- لعرض رسائل التصحيح
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
    local myHRP = myChar.HumanoidRootPart
    local direction = (targetHRP.Position - myHRP.Position).Unit
    local lookAtCFrame = CFrame.new(myHRP.Position, myHRP.Position + direction)
    
    myHRP.CFrame = lookAtCFrame
    
    if _G.AimSkills.Debug then
        print("🎯 Aimed at: " .. target.Name .. " | Distance: " .. math.floor((targetHRP.Position - myHRP.Position).Magnitude))
    end
    
    return true
end

-- Hook للـ RemoteEvents (الطريقة الأساسية)
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        if _G.AimSkills.Enabled then
            local eventName = tostring(self)
            
            -- فحص إذا كان الإيفنت متعلق بالمهارات
            -- جرب طباعة اسم الإيفنت لمعرفة الاسم الصحيح
            if _G.AimSkills.Debug then
                print("🔍 Event Fired: " .. eventName)
            end
            
            -- فحص المهارات Z/X/C/V
            for key, enabled in pairs(_G.AimSkills.Skills) do
                if enabled and (eventName:find(key) or eventName:upper():find(key)) then
                    local target = GetClosestPlayer()
                    if target then
                        task.spawn(function()
                            AimAtPlayer(target)
                            Fluent:Notify({
                                Title = "Aim Skills",
                                Content = "🎯 [" .. key .. "] → " .. target.Name,
                                Duration = 1.5
                            })
                        end)
                    end
                    break
                end
            end
        end
    end
    
    return OldNamecall(self, ...)
end))

-- طريقة بديلة: مراقبة ضغط المفاتيح مباشرة
local UserInputService = game:GetService("UserInputService")
local isSkillActive = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not _G.AimSkills.Enabled or isSkillActive then return end
    
    local keyPressed = input.KeyCode.Name
    
    if _G.AimSkills.Debug then
        print("⌨️ Key Pressed: " .. keyPressed)
    end
    
    -- فحص إذا كان المفتاح ضمن المهارات
    if _G.AimSkills.Skills[keyPressed] then
        isSkillActive = true
        
        local target = GetClosestPlayer()
        if target then
            AimAtPlayer(target)
            Fluent:Notify({
                Title = "Aim Skills",
                Content = "🎯 [" .. keyPressed .. "] → " .. target.Name,
                Duration = 1.5
            })
        else
            if _G.AimSkills.Debug then
                print("⚠️ No target found!")
            end
        end
        
        task.wait(0.5) -- منع التكرار السريع
        isSkillActive = false
    end
end)

-- طريقة ثالثة: Hook لـ Combat Events
local Combat = ReplicatedStorage:WaitForChild("Combat", 5)
if Combat then
    for _, remote in pairs(Combat:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local oldFire = remote.FireServer
            remote.FireServer = function(self, ...)
                if _G.AimSkills.Enabled then
                    local target = GetClosestPlayer()
                    if target then
                        AimAtPlayer(target)
                    end
                end
                return oldFire(self, ...)
            end
        end
    end
end

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

Tab:AddToggle("Debug", {
    Title = "🐛 Debug Mode",
    Default = true,
    Description = "عرض رسائل التصحيح في الكونسول"
}):OnChanged(function(v)
    _G.AimSkills.Debug = v
end)

Tab:AddParagraph({Title = "⚔️ Skills Settings", Content = "فعّل/عطّل المهارات:"})

Tab:AddToggle("Z", {Title = "Z Skill", Default = true}):OnChanged(function(v) 
    _G.AimSkills.Skills["Z"] = v 
end)

Tab:AddToggle("X", {Title = "X Skill", Default = true}):OnChanged(function(v) 
    _G.AimSkills.Skills["X"] = v 
end)

Tab:AddToggle("C", {Title = "C Skill", Default = true}):OnChanged(function(v) 
    _G.AimSkills.Skills["C"] = v 
end)

Tab:AddToggle("V", {Title = "V Skill", Default = true}):OnChanged(function(v) 
    _G.AimSkills.Skills["V"] = v 
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

-- زر فتح الكونسول
Tab:AddButton({
    Title = "📋 Open Console (F9)",
    Description = "لمشاهدة رسائل Debug",
    Callback = function()
        game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
    end
})

Fluent:Notify({
    Title = "Vortex Hub V3", 
    Content = "✅ Aim Skills Loaded!\n🐛 Check Console (F9) for debug info", 
    Duration = 4
})

print("✅ Vortex Hub - Aim Skills Loaded")
print("📋 Press F9 to see debug messages")
