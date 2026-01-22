--[[
    VORTEX HUB V3 - AIM SKILLS ONLY
    Fixed & Simplified
]]--

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Vortex Hub V3 | Aim Skills",
    SubTitle = "Auto Aim When Using Skills",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 350),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Aim Skills", Icon = "crosshair" })
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ==================== SETTINGS ====================
getgenv().AimSkills = {
    Enabled = true,
    AimZ = true,
    AimX = true,
    AimC = true,
    AimV = true,
    MaxDistance = 150,
    TeamCheck = false,
}

-- ==================== GET CLOSEST ENEMY ====================
local function GetClosestEnemy()
    local Closest = nil
    local ShortestDistance = getgenv().AimSkills.MaxDistance
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then continue end
        if not player.Character:FindFirstChild("HumanoidRootPart") then continue end
        if not player.Character:FindFirstChild("Humanoid") then continue end
        if player.Character.Humanoid.Health <= 0 then continue end
        
        -- Team Check
        if getgenv().AimSkills.TeamCheck and player.Team == LocalPlayer.Team then 
            continue 
        end
        
        local Distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        
        if Distance < ShortestDistance then
            ShortestDistance = Distance
            Closest = player
        end
    end
    
    return Closest, ShortestDistance
end

-- ==================== AIM AT TARGET ====================
local function AimAtEnemy(enemy)
    if not enemy or not enemy.Character then return end
    if not enemy.Character:FindFirstChild("HumanoidRootPart") then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local TargetPosition = enemy.Character.HumanoidRootPart.Position
    local MyPosition = LocalPlayer.Character.HumanoidRootPart.Position
    
    -- تصويب الكاميرا
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, TargetPosition)
    
    -- تصويب الشخصية
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(MyPosition, TargetPosition)
    
    print("🎯 Aimed at: " .. enemy.Name .. " | Distance: " .. math.floor((TargetPosition - MyPosition).Magnitude))
end

-- ==================== SKILL DETECTION (FIXED) ====================
UserInputService.InputBegan:Connect(function(input, isTyping)
    -- تجاهل إذا كان يكتب في الشات
    if isTyping then return end
    
    -- التأكد من تفعيل النظام
    if not getgenv().AimSkills.Enabled then return end
    
    -- التحقق من وجود الشخصية
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return 
    end
    
    -- فحص أي زر تم الضغط عليه
    local skillPressed = false
    
    if input.KeyCode == Enum.KeyCode.Z and getgenv().AimSkills.AimZ then
        skillPressed = true
    elseif input.KeyCode == Enum.KeyCode.X and getgenv().AimSkills.AimX then
        skillPressed = true
    elseif input.KeyCode == Enum.KeyCode.C and getgenv().AimSkills.AimC then
        skillPressed = true
    elseif input.KeyCode == Enum.KeyCode.V and getgenv().AimSkills.AimV then
        skillPressed = true
    end
    
    -- إذا تم الضغط على أحد السكلات
    if skillPressed then
        local enemy, distance = GetClosestEnemy()
        
        if enemy then
            print("✅ Skill detected! Aiming at closest enemy...")
            AimAtEnemy(enemy)
        else
            print("❌ No enemies in range!")
        end
    end
end)

-- ==================== UI SETUP ====================

Tabs.Main:AddParagraph({
    Title = "⚡ Aim Skills System",
    Content = "يصوب تلقائياً على أقرب عدو عند استخدام Z/X/C/V"
})

Tabs.Main:AddToggle("EnableAimSkills", {
    Title = "🎯 Enable Aim Skills",
    Description = "تفعيل نظام التصويب التلقائي",
    Default = true
}):OnChanged(function(value)
    getgenv().AimSkills.Enabled = value
    Fluent:Notify({
        Title = "Aim Skills", 
        Content = value and "Enabled ✅" or "Disabled ❌", 
        Duration = 3
    })
end)

Tabs.Main:AddToggle("TeamCheck", {
    Title = "👥 Team Check",
    Description = "عدم التصويب على أعضاء الفريق",
    Default = false
}):OnChanged(function(value)
    getgenv().AimSkills.TeamCheck = value
end)

Tabs.Main:AddParagraph({
    Title = "🎮 Skills Toggle",
    Content = "اختر السكلات اللي تبي التصويب التلقائي يشتغل معها"
})

Tabs.Main:AddToggle("AimZ", {
    Title = "Z - Skill 1",
    Default = true
}):OnChanged(function(value)
    getgenv().AimSkills.AimZ = value
end)

Tabs.Main:AddToggle("AimX", {
    Title = "X - Skill 2",
    Default = true
}):OnChanged(function(value)
    getgenv().AimSkills.AimX = value
end)

Tabs.Main:AddToggle("AimC", {
    Title = "C - Skill 3",
    Default = true
}):OnChanged(function(value)
    getgenv().AimSkills.AimC = value
end)

Tabs.Main:AddToggle("AimV", {
    Title = "V - Skill 4",
    Default = true
}):OnChanged(function(value)
    getgenv().AimSkills.AimV = value
end)

Tabs.Main:AddSlider("MaxDistance", {
    Title = "📏 Max Distance",
    Description = "أقصى مسافة للتصويب",
    Min = 50,
    Max = 300,
    Default = 150,
    Rounding = 0
}):OnChanged(function(value)
    getgenv().AimSkills.MaxDistance = value
end)

Tabs.Main:AddButton({
    Title = "🔄 Test Aim",
    Description = "اختبار التصويب على أقرب عدو",
    Callback = function()
        local enemy, distance = GetClosestEnemy()
        if enemy then
            AimAtEnemy(enemy)
            Fluent:Notify({
                Title = "Test Successful", 
                Content = "Aimed at " .. enemy.Name .. " (" .. math.floor(distance) .. " studs)", 
                Duration = 4
            })
        else
            Fluent:Notify({
                Title = "Test Failed", 
                Content = "No enemies found in range!", 
                Duration = 4
            })
        end
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Vortex Hub V3",
    Content = "Aim Skills Loaded! Press Z/X/C/V to test 🎯",
    Duration = 5
})

print("✅ Vortex Hub V3 - Aim Skills Only")
print("📋 How to use:")
print("   1. Enable 'Aim Skills' toggle")
print("   2. Select which skills (Z/X/C/V) to aim")
print("   3. Press skill button near enemy")
print("   4. Auto aim will activate!")
