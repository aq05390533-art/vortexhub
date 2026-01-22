--[[
    VORTEX HUB V3 - PVP ONLY EDITION
    Aimbot + Auto Skills + Kill Aura + Godmode + Fly + Speed
    تم حذف كل شيء يتعلق بالفل والكويستات والفارم
]]--

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Vortex Hub V3 | PVP ONLY",
    SubTitle = "Destroy Everyone",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 400),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Tabs = {
    Combat = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "zap" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

-- ==================== SETTINGS ====================
getgenv().PVP = {
    Aimbot = true,
    SilentAim = true,
    FOV = 120,
    FOVVisible = true,
    TeamCheck = false,
    WallCheck = true,
    
    KillAura = true,
    KillAuraRange = 25,
    
    AutoSkills = true,
    Z_Key = true,
    X_Key = true,
    C_Key = true,
    V_Key = true,
    
    GodMode = true,
    AutoHaki = true,
    
    Fly = false,
    FlySpeed = 150,
    
    Speed = false,
    SpeedValue = 200,
    
    NoClip = false,
}

-- ==================== AIMBOT ====================
local function GetClosestPlayer()
    local Closest = nil
    local Distance = math.huge
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if getgenv().PVP.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local Root = v.Character.HumanoidRootPart
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
            local MouseDistance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(ScreenPos.X, ScreenPos.Y)).Magnitude
            
            if OnScreen and MouseDistance < Distance and MouseDistance <= getgenv().PVP.FOV then
                if getgenv().PVP.WallCheck then
                    local Ray = Ray.new(Camera.CFrame.Position, (Root.Position - Camera.CFrame.Position).Unit * 500)
                    local Hit = workspace:FindPartOnRayWithIgnoreList(Ray, {LocalPlayer.Character})
                    if Hit and Hit:IsDescendantOf(v.Character) then
                        Distance = MouseDistance
                        Closest = v
                    end
                else
                    Distance = MouseDistance
                    Closest = v
                end
            end
        end
    end
    return Closest
end

-- Silent Aim Hook
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FindPartOnRayWithIgnoreList" and getgenv().PVP.SilentAim then
        local Player = GetClosestPlayer()
        if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            args[1] = Ray.new(workspace.Camera.CFrame.Position, (Player.Character.HumanoidRootPart.Position - workspace.Camera.CFrame.Position).Unit * 1000)
            return oldNamecall(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)

RunService.Heartbeat:Connect(function()
    if getgenv().PVP.Aimbot then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
        end
    end
end)

-- ==================== KILL AURA ====================
spawn(function()
    while task.wait(0.1) do
        if getgenv().PVP.KillAura then
            pcall(function()
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
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

-- ==================== AUTO SKILLS ====================
UserInputService.InputBegan:Connect(function(input)
    if getgenv().PVP.AutoSkills then
        if input.KeyCode == Enum.KeyCode.Z and getgenv().PVP.Z_Key then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
        elseif input.KeyCode == Enum.KeyCode.X and getgenv().PVP.X_Key then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "X", false, game)
        elseif input.KeyCode == Enum.KeyCode.C and getgenv().PVP.C_Key then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "C", false, game)
        elseif input.KeyCode == Enum.KeyCode.V and getgenv().PVP.V_Key then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "V", false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "V", false, game)
        end
    end
end)

-- ==================== GODMODE + AUTO HAKI ====================
spawn(function()
    while task.wait(1) do
        if getgenv().PVP.GodMode then
            pcall(function()
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end)
        end
        if getgenv().PVP.AutoHaki then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
            end)
        end
    end
end)

-- ==================== FLY ====================
spawn(function()
    while task.wait() do
        if getgenv().PVP.Fly then
            pcall(function()
                local BodyVelocity = Instance.new("BodyVelocity")
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                BodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
                
                repeat task.wait()
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.Humanoid.MoveDirection * getgenv().PVP.FlySpeed / 50
                until not getgenv().PVP.Fly or not LocalPlayer.Character
                
                BodyVelocity:Destroy()
            end)
        end
    end
end)

-- ==================== SPEED ====================
RunService.Stepped:Connect(function()
    if getgenv().PVP.Speed then
        pcall(function()
            LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().PVP.SpeedValue
        end)
    else
        pcall(function()
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end)
    end
end)

-- ==================== NOCLIP ====================
RunService.Stepped:Connect(function()
    if getgenv().PVP.NoClip then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ==================== UI ====================
Tabs.Combat:AddToggle("Aimbot", {Title = "Aimbot", Default = true}):OnChanged(function(v) getgenv().PVP.Aimbot = v end)
Tabs.Combat:AddToggle("SilentAim", {Title = "Silent Aim", Default = true}):OnChanged(function(v) getgenv().PVP.SilentAim = v end)
Tabs.Combat:AddToggle("KillAura", {Title = "Kill Aura", Default = true}):OnChanged(function(v) getgenv().PVP.KillAura = v end)
Tabs.Combat:AddSlider("KillAuraRange", {Title = "Kill Aura Range", Min = 10, Max = 50, Default = 25}):OnChanged(function(v) getgenv().PVP.KillAuraRange = v end)
Tabs.Combat:AddToggle("AutoSkills", {Title = "Auto Skills (Z,X,C,V)", Default = true}):OnChanged(function(v) getgenv().PVP.AutoSkills = v end)
Tabs.Combat:AddToggle("GodMode", {Title = "God Mode", Default = true}):OnChanged(function(v) getgenv().PVP.GodMode = v end)

Tabs.Visual:AddToggle("FOVVisible", {Title = "Show FOV Circle", Default = true}):OnChanged(function(v) getgenv().PVP.FOVVisible = v end)
Tabs.Visual:AddSlider("FOV", {Title = "FOV Size", Min = 50, Max = 300, Default = 120}):OnChanged(function(v) getgenv().PVP.FOV = v end)

Tabs.Movement:AddToggle("Fly", {Title = "Fly (Hold Space)", Default = false}):OnChanged(function(v) getgenv().PVP.Fly = v end)
Tabs.Movement:AddSlider("FlySpeed", {Title = "Fly Speed", Min = 50, Max = 500, Default = 150}):OnChanged(function(v) getgenv().PVP.FlySpeed = v end)
Tabs.Movement:AddToggle("Speed", {Title = "Speed Hack", Default = false}):OnChanged(function(v) getgenv().PVP.Speed = v end)
Tabs.Movement:AddSlider("SpeedValue", {Title = "Speed Value", Min = 100, Max = 500, Default = 200}):OnChanged(function(v) getgenv().PVP.SpeedValue = v end)
Tabs.Movement:AddToggle("NoClip", {Title = "NoClip", Default = false}):OnChanged(function(v) getgenv().PVP.NoClip = v end)

Fluent:Notify({Title = "Vortex Hub V3", Content = "PVP ONLY LOADED - تدمير شامل", Duration = 6})
print("Vortex Hub V3 - PVP ONLY EDITION LOADED SUCCESSFULLY")
