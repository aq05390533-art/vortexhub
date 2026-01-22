--[[
    ╔════════════════════════════════════════════╗
    ║            VORTEX HUB V1.0                 ║
    ║      Best Blox Fruits Script 2025          ║
    ║         Made by aq05390533-art             ║
    ╚════════════════════════════════════════════╝
]]--

repeat wait() until game:IsLoaded()

-- إشعار البداية
game.StarterGui:SetCore("SendNotification", {
    Title = "🔥 VORTEX HUB";
    Text = "Loading... Please wait!";
    Duration = 3;
})

wait(1)

-- إنشاء الواجهة
local VortexHub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local Tab1 = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local AutoFarmBtn = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local AutoStatsBtn = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local FPSBoostBtn = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local ServerHopBtn = Instance.new("TextButton")
local UICorner_6 = Instance.new("UICorner")
local RejoinBtn = Instance.new("TextButton")
local UICorner_7 = Instance.new("UICorner")

-- الإعدادات الأساسية
VortexHub.Name = "VortexHub"
VortexHub.Parent = game.CoreGui
VortexHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الفريم الرئيسي
MainFrame.Name = "MainFrame"
MainFrame.Parent = VortexHub
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- العنوان
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Font = Enum.Font.GothamBold
Title.Text = "🔥 VORTEX HUB | Team: "..(getgenv().Team or "Marines")
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22

-- زر الإغلاق
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(0.91, 0, 0.015, 0)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20

UICorner_2.CornerRadius = UDim.new(0, 8)
UICorner_2.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    VortexHub:Destroy()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Vortex Hub";
        Text = "Closed Successfully!";
        Duration = 2;
    })
end)

-- التبويب الرئيسي
Tab1.Name = "Tab1"
Tab1.Parent = MainFrame
Tab1.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Tab1.BorderSizePixel = 0
Tab1.Position = UDim2.new(0.04, 0, 0.16, 0)
Tab1.Size = UDim2.new(0.92, 0, 0.8, 0)
Tab1.ScrollBarThickness = 6
Tab1.CanvasSize = UDim2.new(0, 0, 2, 0)

UIListLayout.Parent = Tab1
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- زر Auto Farm
AutoFarmBtn.Name = "AutoFarmBtn"
AutoFarmBtn.Parent = Tab1
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
AutoFarmBtn.BorderSizePixel = 0
AutoFarmBtn.Size = UDim2.new(0.95, 0, 0, 50)
AutoFarmBtn.Font = Enum.Font.GothamBold
AutoFarmBtn.Text = "🚀 Auto Farm Level (Best 2025)"
AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmBtn.TextSize = 18

UICorner_3.CornerRadius = UDim.new(0, 8)
UICorner_3.Parent = AutoFarmBtn

AutoFarmBtn.MouseButton1Click:Connect(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Vortex Hub";
        Text = "Auto Farm Started!";
        Duration = 3;
    })
    -- هنا راح نحط كود الأوتو فارم لاحقاً
    loadstring(game:HttpGet("https://raw.githubusercontent.com/aq05390533-art/vortexhub/main/autofarm.lua"))()
end)

-- زر Auto Stats
AutoStatsBtn.Name = "AutoStatsBtn"
AutoStatsBtn.Parent = Tab1
AutoStatsBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
AutoStatsBtn.BorderSizePixel = 0
AutoStatsBtn.Size = UDim2.new(0.95, 0, 0, 50)
AutoStatsBtn.Font = Enum.Font.GothamBold
AutoStatsBtn.Text = "⚡ Auto Stats (Melee/Defense/Sword)"
AutoStatsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoStatsBtn.TextSize = 18

UICorner_4.CornerRadius = UDim.new(0, 8)
UICorner_4.Parent = AutoStatsBtn

AutoStatsBtn.MouseButton1Click:Connect(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Vortex Hub";
        Text = "Auto Stats Started!";
        Duration = 3;
    })
    loadstring(game:HttpGet("https://raw.githubusercontent.com/aq05390533-art/vortexhub/main/autostats.lua"))()
end)

-- زر FPS Boost
FPSBoostBtn.Name = "FPSBoostBtn"
FPSBoostBtn.Parent = Tab1
FPSBoostBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
FPSBoostBtn.BorderSizePixel = 0
FPSBoostBtn.Size = UDim2.new(0.95, 0, 0, 50)
FPSBoostBtn.Font = Enum.Font.GothamBold
FPSBoostBtn.Text = "💨 FPS Boost (Ultra)"
FPSBoostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSBoostBtn.TextSize = 18

UICorner_5.CornerRadius = UDim.new(0, 8)
UICorner_5.Parent = FPSBoostBtn

FPSBoostBtn.MouseButton1Click:Connect(function()
    -- كود FPS Boost الحقيقي
    for i,v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = ""
        end
    end
    
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "Vortex Hub";
        Text = "FPS Boost Applied! +60 FPS";
        Duration = 4;
    })
end)

-- زر Server Hop
ServerHopBtn.Name = "ServerHopBtn"
ServerHopBtn.Parent = Tab1
ServerHopBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ServerHopBtn.BorderSizePixel = 0
ServerHopBtn.Size = UDim2.new(0.95, 0, 0, 50)
ServerHopBtn.Font = Enum.Font.GothamBold
ServerHopBtn.Text = "🌐 Server Hop (Lowest Ping)"
ServerHopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ServerHopBtn.TextSize = 18

UICorner_6.CornerRadius = UDim.new(0, 8)
UICorner_6.Parent = ServerHopBtn

ServerHopBtn.MouseButton1Click:Connect(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Vortex Hub";
        Text = "Searching for best server...";
        Duration = 3;
    })
    loadstring(game:HttpGet("https://raw.githubusercontent.com/aq05390533-art/vortexhub/main/serverhop.lua"))()
end)

-- زر Rejoin
RejoinBtn.Name = "RejoinBtn"
RejoinBtn.Parent = Tab1
RejoinBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
RejoinBtn.BorderSizePixel = 0
RejoinBtn.Size = UDim2.new(0.95, 0, 0, 50)
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.Text = "🔄 Rejoin Server"
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.TextSize = 18

UICorner_7.CornerRadius = UDim.new(0, 8)
UICorner_7.Parent = RejoinBtn

RejoinBtn.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)

-- إشعار النجاح النهائي
game.StarterGui:SetCore("SendNotification", {
    Title = "🔥 VORTEX HUB";
    Text = "Loaded Successfully! Enjoy <3";
    Duration = 6;
})

print("✅ Vortex Hub V1.0 Loaded Successfully!")
print("👤 Team: "..(getgenv().Team or "Marines"))
print("🎯 Made by aq05390533-art")
