--[[
    VORTEX HUB V3 - PVP ONLY EDITION (FIXED)
    - Removed Silent Aim
    - Fixed Skills Options in UI
]]--

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Vortex Hub V3 | PVP ONLY",
    SubTitle = "Destroy Everyone",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 450),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Tabs = {
    Combat = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
    Skills = Window:AddTab({ Title = "Skills", Icon = "zap" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "move" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

-- ==================== SETTINGS ====================
getgenv().PVP = {
    -- Aimbot
    Aimbot = true,
    FOV = 120,
    FOVVisible = true,
    TeamCheck = false,
    WallCheck = true,
    
    -- Kill Aura
    KillAura = true,
    KillAuraRange = 25,
    
    -- Aim Skills
    AimSkills = true,
    AimZ = true,
    AimX = true,
    AimC = true,
    AimV = true,
    SkillDistance = 100,
    
    -- Auto Skills
    AutoSkills = false,
    AutoZ = false,
    AutoX = false,
    AutoC = false,
    AutoV = false,
    SkillDelay = 1,
    
    -- Others
    GodMode = false,
    AutoHaki = true,
    
    -- Movement
    Fly = false,
    FlySpeed = 150,
    Speed = false,
    SpeedValue = 200,
    NoClip = false,
}

-- ==================== GET CLOSEST PLAYER ====================
local function GetClosestPlayer()
    local Closest = nil
    local Distance = math.huge
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if getgenv().PVP.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local Root = v.Character.HumanoidRootPart
            local Magnitude = (Root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            
            if Magnitude < Distance then
                if getgenv().PVP.WallCheck then
                    local Ray = Ray.new(Camera.CFrame.Position, (Root.Position - Camera.CFrame.Position).Unit * 500)
                    local Hit = workspace:FindPartOnRayWithIgnoreList(Ray, {LocalPlayer.Character})
                    if Hit and Hit:IsDescendantOf(v.Character) then
                        Distance = Magnitude
                        Closest = v
                    end
                else
                    Distance = Magnitude
                    Closest = v
                end
            end
        end
    end
    return Closest
end

-- ==================== AIMBOT (بدون Silent Aim) ====================
RunService.Heartbeat:Connect(function()
    if getgenv().PVP.Aimbot then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
        end
    end
end)

-- ==================== AIM SKILLS ====================
local function AimAtTarget(Target)
    if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
        local TargetPos = Target.Character.HumanoidRootPart.Position
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, TargetPos)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if getgenv().PVP.AimSkills and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Target = GetClosestPlayer()
        if not Target then return end
        
        local Distance = (Target.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        
        if Distance <= getgenv().PVP.SkillDistance then
            if input.KeyCode == Enum.KeyCode.Z and getgenv().PVP.AimZ then
                AimAtTarget(Target)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(true, "Z", false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "Z", false, game)
                
            elseif input.KeyCode == Enum.KeyCode.X and getgenv().PVP.AimX then
                AimAtTarget(Target)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(true, "X", false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "X", false, game)
                
            elseif input.KeyCode == Enum.KeyCode.C and getgenv().PVP.AimC then
                AimAtTarget(Target)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(true, "C", false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "C", false, game)
                
            elseif input.KeyCode == Enum.KeyCode.V and getgenv().PVP.AimV then
                AimAtTarget(Target)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(true, "V", false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "V", false, game)
            end
        end
    end
end)

-- ==================== AUTO SKILLS ====================
spawn(function()
    while task.wait(getgenv().PVP.SkillDelay) do
        if getgenv().PVP.AutoSkills and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local Target = GetClosestPlayer()
            if Target then
                local Distance = (Target.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                
                if Distance <= getgenv().PVP.SkillDistance then
                    pcall(function()
                        AimAtTarget(Target)
                        
                        if getgenv().PVP.AutoZ then
                            VirtualInputManager:SendKeyEvent(true, "Z", false, game)
                            task.wait(0.1)
                            VirtualInputManager:SendKeyEvent(false, "Z", false, game)
                            task.wait(0.5)
                        end
                        
                        if getgenv().PVP.AutoX then
                            VirtualInputManager:SendKeyEvent(true, "X", false, game)
                            task.wait(0.1)
                            VirtualInputManager:SendKeyEvent(false, "X", false, game)
                            task.wait(0.5)
                        end
                        
                        if getgenv().PVP.AutoC then
                            VirtualInputManager:SendKeyEvent(true, "C", false, game)
                            task.wait(0.1)
                            VirtualInputManager:SendKeyEvent(false, "C", false, game)
                            task.wait(0.5)
                        end
                        
                        if getgenv().PVP.AutoV then
                            VirtualInputManager:SendKeyEvent(true, "V", false, game)
                            task.wait(0.1)
                            VirtualInputManager:SendKeyEvent(false, "V", false, game)
                        end
                    end)
                end
            end
        end
    end
end)

-- ==================== KILL AURA ====================
spawn(function()
    while task.wait(0.1) do
        if getgenv().PVP.KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        if (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= getgenv().PVP.KillAuraRange then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                            task.wait(0.05)
                            game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== GODMODE + AUTO HAKI ====================
spawn(function()
    while task.wait(5) do
        pcall(function()
            if getgenv().PVP.GodMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
            
            if getgenv().PVP.AutoHaki and LocalPlayer.Character then
                if not LocalPlayer.Character:FindFirstChild("HasBuso") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)

-- ==================== FLY ====================
local FlyConnection
spawn(function()
    while task.wait() do
        if getgenv().PVP.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if not FlyConnection then
                FlyConnection = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local MoveDirection = LocalPlayer.Character.Humanoid.MoveDirection
                            LocalPlayer.Character.HumanoidRootPart.Velocity = MoveDirection * getgenv().PVP.FlySpeed
                        end
                    end)
                end)
            end
        else
            if FlyConnection then
                FlyConnection:Disconnect()
                FlyConnection = nil
            end
        end
    end
end)

-- ==================== SPEED ====================
local OriginalSpeed = 16
local SpeedConnection

spawn(function()
    while task.wait() do
        if getgenv().PVP.Speed then
            if not SpeedConnection then
                SpeedConnection = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().PVP.SpeedValue
                        end
                    end)
                end)
            end
        else
            if SpeedConnection then
                SpeedConnection:Disconnect()
                SpeedConnection = nil
                
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = OriginalSpeed
                    end
                end)
            end
        end
    end
end)

-- ==================== NOCLIP ====================
local NoClipConnection
spawn(function()
    while task.wait() do
        if getgenv().PVP.NoClip then
            if not NoClipConnection then
                NoClipConnection = RunService.Stepped:Connect(function()
                    pcall(function()
                        if LocalPlayer.Character then
                            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = false
                                end
                            end
                        end
                    end)
                end)
            end
        else
            if NoClipConnection then
                NoClipConnection:Disconnect()
                NoClipConnection = nil
            end
        end
    end
end)

-- ==================== UI ====================

-- Combat Tab
Tabs.Combat:AddToggle("Aimbot", {Title = "🎯 Aimbot", Default = true}):OnChanged(function(v) 
    getgenv().PVP.Aimbot = v 
    Fluent:Notify({Title = "Aimbot", Content = v and "Enabled ✅" or "Disabled ❌", Duration = 2})
end)

Tabs.Combat:AddToggle("TeamCheck", {Title = "👥 Team Check", Default = false}):OnChanged(function(v) 
    getgenv().PVP.TeamCheck = v 
end)

Tabs.Combat:AddToggle("WallCheck", {Title = "🧱 Wall Check", Default = true}):OnChanged(function(v) 
    getgenv().PVP.WallCheck = v 
end)

Tabs.Combat:AddToggle("KillAura", {Title = "⚔️ Kill Aura", Default = true}):OnChanged(function(v) 
    getgenv().PVP.KillAura = v 
    Fluent:Notify({Title = "Kill Aura", Content = v and "Enabled ✅" or "Disabled ❌", Duration = 2})
end)

Tabs.Combat:AddSlider("KillAuraRange", {
    Title = "📏 Kill Aura Range", 
    Min = 10, 
    Max = 50, 
    Default = 25,
    Rounding = 0
}):OnChanged(function(v) 
    getgenv().PVP.KillAuraRange = v 
end)

Tabs.Combat:AddToggle("GodMode", {Title = "🛡️ God Mode", Default = false}):OnChanged(function(v) 
    getgenv().PVP.GodMode = v 
    Fluent:Notify({Title = "God Mode", Content = v and "Enabled ✅" or "Disabled ❌", Duration = 2})
end)

Tabs.Combat:AddToggle("AutoHaki", {Title = "💪 Auto Haki", Default = true}):OnChanged(function(v) 
    getgenv().PVP.AutoHaki = v 
end)

-- Skills Tab
Tabs.Skills:AddParagraph({
    Title = "⚡ Aim Skills",
    Content = "يصوب على أقرب لاعب تلقائياً عند الضغط على Z/X/C/V"
})

Tabs.Skills:AddToggle("AimSkills", {
    Title = "🎯 Enable Aim Skills", 
    Default = true
}):OnChanged(function(v) 
    getgenv().PVP.AimSkills = v 
    Fluent:Notify({Title = "Aim Skills", Content = v and "Enabled ✅" or "Disabled ❌", Duration = 2})
end)

Tabs.Skills:AddToggle("AimZ", {
    Title = "Z - Skill 1", 
    Default = true
}):OnChanged(function(v) 
    getgenv().PVP.AimZ = v 
end)

Tabs.Skills:AddToggle("AimX", {
    Title = "X - Skill 2", 
    Default = true
}):OnChanged(function(v) 
    getgenv().PVP.AimX = v 
end)

Tabs.Skills:AddToggle("AimC", {
    Title = "C - Skill 3", 
    Default = true
}):OnChanged(function(v) 
    getgenv().PVP.AimC = v 
end)

Tabs.Skills:AddToggle("AimV", {
    Title = "V - Skill 4", 
    Default = true
}):OnChanged(function(v) 
    getgenv().PVP.AimV = v 
end)

Tabs.Skills:AddSlider("SkillDistance", {
    Title = "📏 Skill Distance", 
    Min = 50, 
    Max = 200, 
    Default = 100,
    Rounding = 0
}):OnChanged(function(v) 
    getgenv().PVP.SkillDistance = v 
end)

Tabs.Skills:AddParagraph({
    Title = "🤖 Auto Skills",
    Content = "يستخدم السكلات تلقائياً بدون ضغط أي زر"
})

Tabs.Skills:AddToggle("AutoSkills", {
    Title = "🔄 Enable Auto Skills", 
    Default = false
}):OnChanged(function(v) 
    getgenv().PVP.AutoSkills = v 
    Fluent:Notify({Title = "Auto Skills", Content = v and "Enabled ✅" or "Disabled ❌", Duration = 2})
end)

Tabs.Skills:AddToggle("AutoZ", {
    Title = "Auto Z", 
    Default = false
}):OnChanged(function(v) 
    getgenv().PVP.AutoZ = v 
end)

Tabs.Skills:AddToggle("AutoX", {
    Title = "Auto X", 
    Default = false
}):OnChanged(function(v) 
    getgenv().PVP.AutoX = v 
end)

Tabs.Skills:AddToggle("AutoC", {
    Title = "Auto C", 
    Default = false
}):OnChanged(function(v) 
    getgenv().PVP.AutoC = v 
end)

Tabs.Skills:AddToggle("AutoV", {
    Title = "Auto V", 
    Default = false
}):OnChanged(function(v) 
    getgenv().PVP.AutoV = v 
end)

Tabs.Skills:AddSlider("SkillDelay", {
    Title = "⏱️ Skill Delay (sec)", 
    Min = 0.5, 
    Max = 5, 
    Default = 1,
    Rounding = 1
}):OnChanged(function(v) 
    getgenv().PVP.SkillDelay = v 
end)

-- Visual Tab
Tabs.Visual:AddToggle("FOVVisible", {
    Title = "👁️ Show FOV Circle", 
    Default = true
}):OnChanged(function(v) 
    getgenv().PVP.FOVVisible = v 
end)

Tabs.Visual:AddSlider("FOV", {
    Title = "🔍 FOV Size", 
    Min = 50, 
    Max = 300, 
    Default = 120,
    Rounding = 0
}):OnChanged(function(v) 
    getgenv().PVP.FOV = v 
end)

-- Movement Tab
Tabs.Movement:AddToggle("Fly", {
    Title = "✈️ Fly", 
    Default = false
}):OnChanged(function(v) 
    getgenv().PVP.Fly = v 
    Fluent:Notify({Title = "Fly", Content = v and "Enabled ✅" or "Disabled ❌", Duration = 2})
end)

Tabs.Movement:AddSlider("FlySpeed", {
    Title = "💨 Fly Speed", 
    Min = 50, 
    Max = 500, 
    Default = 150,
    Rounding = 0
}):OnChanged(function(v) 
    getgenv().PVP.FlySpeed = v 
end)

Tabs.Movement:AddToggle("Speed", {
    Title = "🏃 Speed Hack", 
    Default = false
}):OnChanged(function(v) 
    getgenv().PVP.Speed = v 
    Fluent:Notify({Title = "Speed", Content = v and "Enabled ✅" or "Disabled ❌", Duration = 2})
end)

Tabs.Movement:AddSlider("SpeedValue", {
    Title = "⚡ Speed Value", 
    Min = 100, 
    Max = 500, 
    Default = 200,
    Rounding = 0
}):OnChanged(function(v) 
    getgenv().PVP.SpeedValue = v 
end)

Tabs.Movement:AddToggle("NoClip", {
    Title = "👻 NoClip", 
    Default = false
}):OnChanged(function(v) 
    getgenv().PVP.NoClip = v 
    Fluent:Notify({Title = "NoClip", Content = v and "Enabled ✅" or "Disabled ❌", Duration = 2})
end)

-- Misc Tab
Tabs.Misc:AddButton({
    Title = "⏰ Anti-AFK",
    Description = "يمنع الكيك من السيرفر",
    Callback = function()
        local VirtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        Fluent:Notify({Title = "Anti-AFK", Content = "Activated ✅", Duration = 3})
    end
})

Tabs.Misc:AddButton({
    Title = "🔄 Rejoin Server",
    Description = "رجوع لنفس السيرفر",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Vortex Hub V3", 
    Content = "PVP Loaded Successfully! 🔥", 
    Duration = 5
})

print("✅ Vortex Hub V3 | PVP ONLY | No Silent Aim | Skills Fixed")
