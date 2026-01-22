--[[
    VORTEX HUB - Best Blox Fruits Script 2025
    Made by aq05390533-art
]]--

repeat wait() until game:IsLoaded()

-- التحقق من اللعبة
if game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.PlaceId ~= 7447072717 then
    game.Players.LocalPlayer:Kick("⚠️ Vortex Hub only works on Blox Fruits!")
    return
end

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
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local Tab1 = Instance.new("ScrollingFrame")
local AutoFarmBtn = Instance.new("TextButton")
local AutoStatsBtn = Instance.new("TextButton")
local FPSBoostBtn = Instance.new("TextButton")

-- الإعدادات الأساسية
VortexHub.Name = "VortexHub"
VortexHub.Parent = game.CoreGui
VortexHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الفريم الرئيسي
MainFrame.Parent = VortexHub
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

-- العنوان
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Font = Enum.Font.GothamBold
Title.Text = "🔥 VORTEX HUB | Team: "..(getgenv().Team or "Marines")
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

-- زر الإغلاق
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(0.92, 0, 0, 5)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.MouseButton1Click:Connect(function()
    VortexHub:Destroy()
end)

-- التبويب
Tab1.Parent = MainFrame
Tab1.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Tab1.BorderSizePixel = 0
Tab1.Position = UDim2.new(0.05, 0, 0.15, 0)
Tab1.Size = UDim2.new(0.9, 0, 0.8, 0)
Tab1.ScrollBarThickness = 8

-- زر Auto Farm
AutoFarmBtn.Parent = Tab1
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
AutoFarmBtn.BorderSizePixel = 0
AutoFarmBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
AutoFarmBtn.Size = UDim2.new(0.9, 0, 0, 40)
AutoFarmBtn.Font = Enum.Font.GothamBold
AutoFarmBtn.Text = "🚀 Auto Farm Level (Best 2025)"
AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmBtn.TextSize = 16
AutoFarmBtn.MouseButton1Click:Connect(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Vortex Hub";
        Text = "Auto Farm Started!";
        Duration = 3;
    })
    -- هنا حط كود الأوتو فارم لاحقاً
end)

-- زر Auto Stats
AutoStatsBtn.Parent = Tab1
AutoStatsBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
AutoStatsBtn.BorderSizePixel = 0
AutoStatsBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
AutoStatsBtn.Size = UDim2.new(0.9, 0, 0, 40)
AutoStatsBtn.Font = Enum.Font.GothamBold
AutoStatsBtn.Text = "⚡ Auto Stats (Melee/Defense/Sword)"
AutoStatsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoStatsBtn.TextSize = 16
AutoStatsBtn.MouseButton1Click:Connect(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Vortex Hub";
        Text = "Auto Stats Started!";
        Duration = 3;
    })
end)

-- زر FPS Boost
FPSBoostBtn.Parent = Tab1
FPSBoostBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
FPSBoostBtn.BorderSizePixel = 0
FPSBoostBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
FPSBoostBtn.Size = UDim2.new(0.9, 0, 0, 40)
FPSBoostBtn.Font = Enum.Font.GothamBold
FPSBoostBtn.Text = "💨 FPS Boost (Ultra)"
FPSBoostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSBoostBtn.TextSize = 16
FPSBoostBtn.MouseButton1Click:Connect(function()
    -- كود FPS Boost
    for i,v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        end
    end
    game.StarterGui:SetCore("SendNotification", {
        Title = "Vortex Hub";
        Text = "FPS Boost Applied!";
        Duration = 3;
    })
end)

-- إشعار النجاح
game.StarterGui:SetCore("SendNotification", {
    Title = "🔥 VORTEX HUB";
    Text = "Loaded Successfully! Enjoy <3";
    Duration = 5;
})

print("✅ Vortex Hub Loaded | Team: "..(getgenv().Team or "Marines"))
