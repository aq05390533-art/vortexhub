--[[
    VORTEX HUB - Premium UI
    Style: Fluent (Like the image provided)
]]--

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Vortex Hub " .. "v2.0",
    SubTitle = "by aq05390533-art",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- يخلي الخلفية شفافة وضبابية زي الصورة
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- إنشاء التبويبات (القائمة الجانبية)
local Tabs = {
    Farm = Window:AddTab({ Title = "Farm", Icon = "sword" }),
    Stats = Window:AddTab({ Title = "Stats", Icon = "bar-chart-2" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map" }),
    Raids = Window:AddTab({ Title = "Raids", Icon = "skull" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

local Options = Fluent.Options

-- =============================================
-- تبويب Farm (زي الصورة بالضبط)
-- =============================================

Tabs.Farm:AddDropdown("WeaponSelect", {
    Title = "Select Weapon",
    Values = {"Melee", "Sword", "Blox Fruit"},
    Multi = false,
    Default = 1,
})

Tabs.Farm:AddSection("Auto Farm")

local FarmToggle = Tabs.Farm:AddToggle("AutoFarmLevel", {
    Title = "Auto Farm Level",
    Description = "Fastest method to max level",
    Default = false
})

FarmToggle:OnChanged(function()
    getgenv().AutoFarm = Options.AutoFarmLevel.Value
    if Options.AutoFarmLevel.Value then
        Fluent:Notify({
            Title = "Vortex Hub",
            Content = "Auto Farm Started!",
            Duration = 3
        })
        -- كود التشغيل يجي هنا
    end
end)

Tabs.Farm:AddToggle("AutoFarmNearest", {
    Title = "Auto Farm Nearest",
    Description = "Farm mobs near you",
    Default = false
})

Tabs.Farm:AddSection("Farm Level")

Tabs.Farm:AddToggle("SkyPheaFarm", {
    Title = "Sky Phea Farm",
    Default = false
})

Tabs.Farm:AddToggle("PlayerHunter", {
    Title = "Player Hunter Quest",
    Default = false
})

Tabs.Farm:AddSection("Chests")

Tabs.Farm:AddToggle("AutoChest", {
    Title = "Auto Chest (Tween)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoChest = Value
    end
})

-- =============================================
-- تبويب Stats
-- =============================================

Tabs.Stats:AddSection("Stats Settings")

Tabs.Stats:AddSlider("StatsPoints", {
    Title = "Point Allocation %",
    Description = "Choose percentage to add",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
})

Tabs.Stats:AddToggle("AutoMelee", { Title = "Auto Melee", Default = false })
Tabs.Stats:AddToggle("AutoDefense", { Title = "Auto Defense", Default = false })
Tabs.Stats:AddToggle("AutoSword", { Title = "Auto Sword", Default = false })
Tabs.Stats:AddToggle("AutoFruit", { Title = "Auto Fruit", Default = false })

-- =============================================
-- تبويب Teleport
-- =============================================

Tabs.Teleport:AddDropdown("IslandSelect", {
    Title = "Select Island",
    Values = {"Jungle", "Pirate Village", "Marine Fortress", "Skylands", "Prison", "Colosseum", "Magma Village"},
    Multi = false,
    Default = 1,
})

Tabs.Teleport:AddButton({
    Title = "Teleport",
    Description = "Teleport to selected island",
    Callback = function()
        Fluent:Notify({Title = "Vortex Hub", Content = "Teleporting...", Duration = 3})
    end
})

-- =============================================
-- تبويب Misc (FPS Boost وغيره)
-- =============================================

Tabs.Misc:AddButton({
    Title = "FPS Boost",
    Description = "Remove lag",
    Callback = function()
        for i,v in pairs(game:GetDescendants()) do
            if v:IsA("Part") then v.Material = "Plastic" end
        end
        Fluent:Notify({Title = "System", Content = "FPS Boost Applied!", Duration = 3})
    end
})

Tabs.Misc:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

-- حفظ الإعدادات
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:BuildInterfaceSection(Tabs.Misc)
SaveManager:BuildConfigSection(Tabs.Misc)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Vortex Hub",
    Content = "Loaded Successfully! Team: " .. (getgenv().Team or "Marines"),
    Duration = 8
})

print("✅ Vortex Hub Loaded | UI Style: Fluent")
