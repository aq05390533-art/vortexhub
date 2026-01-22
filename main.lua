--[[
    ██╗   ██╗ ██████╗ ██████╗ ████████╗███████╗██╗  ██╗
    ██║   ██║██╔═══██╗██╔══██╗╚══██╔══╝██╔════╝╚██╗██╔╝
    ██║   ██║██║   ██║██████╔╝   ██║   █████╗   ╚███╔╝ 
    ╚██╗ ██╔╝██║   ██║██╔══██╗   ██║   ██╔══╝   ██╔██╗ 
     ╚████╔╝ ╚██████╔╝██║  ██║   ██║   ███████╗██╔╝ ██╗
      ╚═══╝   ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
    
    🔥 VORTEX HUB V3 - REDZ STYLE 🔥
    ⚡ Advanced Anti-Ban System
    🛡️ Bypass Detection Engine
    🎯 Smart Quest System
]]--

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer
repeat wait() until game.Players.LocalPlayer.Character

-- =============================================
-- 🔐 ANTI-BAN PROTECTION
-- =============================================
local function InitAntiKick()
    if getgenv().VortexProtected then return end
    getgenv().VortexProtected = true
    
    -- Hook Kick/Teleport
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        -- Anti-Kick
        if method == "Kick" then
            return nil
        end
        
        -- Delay Remotes
        if (method == "FireServer" or method == "InvokeServer") then
            task.wait(math.random(5, 15) / 1000)
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    print("✅ Anti-Ban Loaded")
end

InitAntiKick()

-- =============================================
-- 🎨 LOAD UI LIBRARY
-- =============================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "🔱 VORTEX HUB V3 🔱",
    SubTitle = "by Redz Style",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 480),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- =============================================
-- 📋 TABS
-- =============================================
local Tabs = {
    Home = Window:AddTab({ Title = "🏠 Home", Icon = "home" }),
    Farm = Window:AddTab({ Title = "⚔️ Auto Farm", Icon = "zap" }),
    Combat = Window:AddTab({ Title = "⚡ Combat", Icon = "shield" }),
    Stats = Window:AddTab({ Title = "📊 Stats", Icon = "trending-up" }),
    Teleport = Window:AddTab({ Title = "🌍 Teleport", Icon = "map-pin" }),
    Shop = Window:AddTab({ Title = "🛒 Shop", Icon = "shopping-cart" }),
    Misc = Window:AddTab({ Title = "⚙️ Misc", Icon = "settings" }),
    Configs = Window:AddTab({ Title = "💾 Configs", Icon = "save" })
}

-- =============================================
-- 🎮 SERVICES
-- =============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Update Character
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

-- =============================================
-- ⚙️ CONFIGURATION
-- =============================================
getgenv().Settings = {
    -- Auto Farm
    AutoFarm = false,
    AutoFarmLevel = false,
    AutoFarmBone = false,
    AutoFarmCake = false,
    AutoRaidPirate = false,
    
    -- Weapon
    SelectWeapon = "Melee",
    
    -- Combat
    FastAttack = true,
    FastAttackDelay = 0.1,
    AutoHaki = true,
    AutoSeraphim = false,
    
    -- Mob Settings
    BringMob = true,
    FarmDistance = 25,
    BringDistance = 350,
    
    -- Quest
    AutoQuest = true,
    CheckQuestBeforeFarm = true,
    
    -- Teleport
    TweenSpeed = 350,
    BypassTeleport = true,
    InstantTeleport = false,
    TeleportHeight = 25,
    
    -- NoClip
    NoClip = false,
    
    -- Stats
    AutoStats = {
        Melee = false,
        Defense = false,
        Sword = false,
        Gun = false,
        Fruit = false
    },
    
    -- Misc
    WhiteScreen = false,
    RemoveFog = false,
    LockFPS = false,
    FPSCap = 60,
    
    -- Anti AFK
    AntiAFK = true
}

-- =============================================
-- 📊 HOME TAB
-- =============================================
local PlayerSection = Tabs.Home:AddSection("Player Information")

Tabs.Home:AddParagraph({
    Title = "👤 Player Stats",
    Content = string.format(
        "Name: %s\nLevel: %d\nBeli: %s\nFragments: %s",
        Player.Name,
        Player.Data.Level.Value,
        tostring(Player.Data.Beli.Value),
        tostring(Player.Data.Fragments.Value or 0)
    )
})

local StatusLabel = Tabs.Home:AddParagraph({
    Title = "⚡ Status",
    Content = "Idle"
})

function UpdateStatus(text)
    StatusLabel:SetDesc(text)
end

-- Credits
Tabs.Home:AddParagraph({
    Title = "👨‍💻 Credits",
    Content = "Script by: Vortex Team\nStyle: Redz Hub\nVersion: 3.0.0"
})

-- =============================================
-- 🗺️ QUEST DATABASE (SEA 1, 2, 3)
-- =============================================
local QuestDatabase = {
    -- ========== FIRST SEA ==========
    {Level = {1, 9}, Quest = "BanditQuest1", QuestLvl = 1, Enemy = "Bandit",
     QuestCFrame = CFrame.new(1059.37, 16.55, 1550.42),
     MobCFrame = CFrame.new(1145.45, 16.55, 1550.18)},
    
    {Level = {10, 14}, Quest = "JungleQuest", QuestLvl = 1, Enemy = "Monkey",
     QuestCFrame = CFrame.new(-1598.09, 35.55, 153.38),
     MobCFrame = CFrame.new(-1448.51, 49.85, 11.46)},
    
    {Level = {15, 29}, Quest = "BuggyQuest1", QuestLvl = 1, Enemy = "Bandit",
     QuestCFrame = CFrame.new(-1119.81, 4.79, 3831.37),
     MobCFrame = CFrame.new(-1145.45, 16.55, 3550.18)},
    
    {Level = {30, 39}, Quest = "DesertQuest", QuestLvl = 1, Enemy = "Desert Bandit",
     QuestCFrame = CFrame.new(897.03, 6.45, 4388.93),
     MobCFrame = CFrame.new(932.13, 6.45, 4488.38)},
    
    {Level = {40, 59}, Quest = "DesertQuest", QuestLvl = 2, Enemy = "Desert Officer",
     QuestCFrame = CFrame.new(897.03, 6.45, 4388.93),
     MobCFrame = CFrame.new(1580.13, 4.45, 4384.88)},
    
    {Level = {60, 74}, Quest = "MarineQuest2", QuestLvl = 1, Enemy = "Chief Petty Officer",
     QuestCFrame = CFrame.new(-5039.59, 28.65, 4324.68),
     MobCFrame = CFrame.new(-4882.69, 22.65, 4255.53)},
    
    {Level = {75, 89}, Quest = "AreaQuest", QuestLvl = 1, Enemy = "Sky Bandit",
     QuestCFrame = CFrame.new(-4841.83, 717.67, -2623.96),
     MobCFrame = CFrame.new(-4955.72, 717.67, -2953.18)},
    
    {Level = {90, 99}, Quest = "AreaQuest", QuestLvl = 2, Enemy = "Dark Master",
     QuestCFrame = CFrame.new(-4841.83, 717.67, -2623.96),
     MobCFrame = CFrame.new(-5079.98, 717.67, -2909.42)},
    
    {Level = {100, 119}, Quest = "PrisonerQuest", QuestLvl = 1, Enemy = "Prisoner",
     QuestCFrame = CFrame.new(5308.93, 1.66, 475.12),
     MobCFrame = CFrame.new(5411.93, 1.66, 475.12)},
    
    {Level = {120, 149}, Quest = "PrisonerQuest", QuestLvl = 2, Enemy = "Dangerous Prisoner",
     QuestCFrame = CFrame.new(5308.93, 1.66, 475.12),
     MobCFrame = CFrame.new(5654.04, 1.66, 866.82)},
    
    {Level = {150, 174}, Quest = "MagmaQuest", QuestLvl = 1, Enemy = "Lava Pirate",
     QuestCFrame = CFrame.new(-5234.61, 51.95, -4732.22),
     MobCFrame = CFrame.new(-5308.29, 51.95, -4890.31)},
    
    {Level = {175, 189}, Quest = "MagmaQuest", QuestLvl = 2, Enemy = "Magma Admiral",
     QuestCFrame = CFrame.new(-5234.61, 51.95, -4732.22),
     MobCFrame = CFrame.new(-5530.12, 51.95, -5130.33)},
    
    {Level = {190, 209}, Quest = "FishmanQuest", QuestLvl = 1, Enemy = "Fishman Warrior",
     QuestCFrame = CFrame.new(61122.65, 18.50, 1569.38),
     MobCFrame = CFrame.new(60946.84, 18.50, 1584.03)},
    
    {Level = {210, 249}, Quest = "FishmanQuest", QuestLvl = 2, Enemy = "Fishman Commando",
     QuestCFrame = CFrame.new(61122.65, 18.50, 1569.38),
     MobCFrame = CFrame.new(61922.65, 18.50, 1606.87)},
    
    {Level = {250, 274}, Quest = "SkypieaQuest", QuestLvl = 1, Enemy = "God's Guard",
     QuestCFrame = CFrame.new(-4721.98, 843.87, -1949.97),
     MobCFrame = CFrame.new(-4628.48, 843.87, -1931.23)},
    
    {Level = {275, 299}, Quest = "SkypieaQuest", QuestLvl = 2, Enemy = "Shanda",
     QuestCFrame = CFrame.new(-7859.98, 5545.48, -379.98),
     MobCFrame = CFrame.new(-7678.48, 5566.48, -497.39)},
    
    {Level = {300, 324}, Quest = "SkyExp1Quest", QuestLvl = 1, Enemy = "Royal Squad",
     QuestCFrame = CFrame.new(-7903.48, 5635.48, -1410.98),
     MobCFrame = CFrame.new(-7654.48, 5637.48, -1407.98)},
    
    {Level = {325, 374}, Quest = "SkyExp1Quest", QuestLvl = 2, Enemy = "Royal Soldier",
     QuestCFrame = CFrame.new(-7903.48, 5635.48, -1410.98),
     MobCFrame = CFrame.new(-7836.48, 5659.48, -1792.98)},
    
    {Level = {375, 399}, Quest = "SkyExp2Quest", QuestLvl = 1, Enemy = "Galley Pirate",
     QuestCFrame = CFrame.new(-4970.21, 717.70, -2990.10),
     MobCFrame = CFrame.new(-5123.21, 717.70, -2890.10)},
    
    {Level = {400, 449}, Quest = "SkyExp2Quest", QuestLvl = 2, Enemy = "Galley Captain",
     QuestCFrame = CFrame.new(-4970.21, 717.70, -2990.10),
     MobCFrame = CFrame.new(-5530.21, 717.70, -2890.10)},
    
    {Level = {450, 474}, Quest = "FountainQuest", QuestLvl = 1, Enemy = "Cyborg",
     QuestCFrame = CFrame.new(5253.84, 38.53, 4049.73),
     MobCFrame = CFrame.new(6014.84, 38.53, 3984.73)},
    
    {Level = {475, 524}, Quest = "FountainQuest", QuestLvl = 2, Enemy = "Cyborg",
     QuestCFrame = CFrame.new(5253.84, 38.53, 4049.73),
     MobCFrame = CFrame.new(6014.84, 38.53, 3984.73)},
    
    {Level = {525, 549}, Quest = "ZombieQuest", QuestLvl = 1, Enemy = "Zombie",
     QuestCFrame = CFrame.new(-5495.95, 48.52, -794.14),
     MobCFrame = CFrame.new(-5657.95, 48.52, -794.14)},
    
    {Level = {550, 574}, Quest = "ZombieQuest", QuestLvl = 2, Enemy = "Vampire",
     QuestCFrame = CFrame.new(-5495.95, 48.52, -794.14),
     MobCFrame = CFrame.new(-6030.95, 48.52, -1310.14)},
    
    {Level = {575, 599}, Quest = "MarineQuest3", QuestLvl = 1, Enemy = "Marine Lieutenant",
     QuestCFrame = CFrame.new(-2440.79, 71.79, -3216.06),
     MobCFrame = CFrame.new(-2842.79, 71.79, -2901.06)},
    
    {Level = {600, 624}, Quest = "MarineQuest3", QuestLvl = 2, Enemy = "Marine Captain",
     QuestCFrame = CFrame.new(-2440.79, 71.79, -3216.06),
     MobCFrame = CFrame.new(-1890.79, 71.79, -3208.06)},
    
    {Level = {625, 649}, Quest = "ColosseumQuest", QuestLvl = 1, Enemy = "Gladiator",
     QuestCFrame = CFrame.new(-1427.09, 7.32, -2842.11),
     MobCFrame = CFrame.new(-1277.09, 7.32, -2907.11)},
    
    {Level = {650, 699}, Quest = "ColosseumQuest", QuestLvl = 2, Enemy = "Gladiator",
     QuestCFrame = CFrame.new(-1427.09, 7.32, -2842.11),
     MobCFrame = CFrame.new(-1277.09, 7.32, -2907.11)},
    
    {Level = {700, 749}, Quest = "ColosseumQuest2", QuestLvl = 1, Enemy = "Toga Warrior",
     QuestCFrame = CFrame.new(-1580.05, 7.32, -2983.70),
     MobCFrame = CFrame.new(-1943.05, 7.32, -2968.70)},
    
    {Level = {750, 799}, Quest = "ColosseumQuest2", QuestLvl = 2, Enemy = "Warden",
     QuestCFrame = CFrame.new(-1580.05, 7.32, -2983.70),
     MobCFrame = CFrame.new(-1820.05, 7.32, -2931.70)},
    
    {Level = {800, 849}, Quest = "SnowQuest", QuestLvl = 1, Enemy = "Snowman",
     QuestCFrame = CFrame.new(1386.89, 87.22, -1298.07),
     MobCFrame = CFrame.new(1289.89, 87.22, -1432.07)},
    
    {Level = {850, 874}, Quest = "SnowQuest", QuestLvl = 2, Enemy = "Winter Warrior",
     QuestCFrame = CFrame.new(1386.89, 87.22, -1298.07),
     MobCFrame = CFrame.new(1201.89, 401.22, -1297.07)},
    
    {Level = {875, 899}, Quest = "SnowMountainQuest", QuestLvl = 1, Enemy = "Frost Viking",
     QuestCFrame = CFrame.new(609.86, 401.44, -5370.43),
     MobCFrame = CFrame.new(574.86, 401.44, -5170.43)},
    
    {Level = {900, 949}, Quest = "SnowMountainQuest", QuestLvl = 2, Enemy = "Female Islander",
     QuestCFrame = CFrame.new(609.86, 401.44, -5370.43),
     MobCFrame = CFrame.new(1194.86, 401.44, -5229.43)},
    
    {Level = {950, 974}, Quest = "MarineTreeIsland", QuestLvl = 1, Enemy = "Lab Subordinate",
     QuestCFrame = CFrame.new(2184.68, 448.91, -7535.17),
     MobCFrame = CFrame.new(2064.68, 448.91, -7335.17)},
    
    {Level = {975, 999}, Quest = "MarineTreeIsland", QuestLvl = 2, Enemy = "Horned Warrior",
     QuestCFrame = CFrame.new(2184.68, 448.91, -7535.17),
     MobCFrame = CFrame.new(2289.68, 448.91, -7190.17)},
    
    {Level = {1000, 1049}, Quest = "IceQuest", QuestLvl = 1, Enemy = "Lab Subordinate",
     QuestCFrame = CFrame.new(5524.89, 51.65, -4978.43),
     MobCFrame = CFrame.new(5636.89, 51.65, -4678.43)},
    
    {Level = {1050, 1099}, Quest = "IceQuest", QuestLvl = 2, Enemy = "Horned Warrior",
     QuestCFrame = CFrame.new(5524.89, 51.65, -4978.43),
     MobCFrame = CFrame.new(6401.89, 51.65, -5809.43)},
    
    {Level = {1100, 1124}, Quest = "FireQuest", QuestLvl = 1, Enemy = "Golem",
     QuestCFrame = CFrame.new(-5497.06, 11.86, -5376.24),
     MobCFrame = CFrame.new(-5897.06, 11.86, -5176.24)},
    
    {Level = {1125, 1149}, Quest = "FireQuest", QuestLvl = 2, Enemy = "Magma Ninja",
     QuestCFrame = CFrame.new(-5497.06, 11.86, -5376.24),
     MobCFrame = CFrame.new(-5922.06, 11.86, -5743.24)},
    
    {Level = {1150, 1174}, Quest = "ShipQuest1", QuestLvl = 1, Enemy = "Ship Deckhand",
     QuestCFrame = CFrame.new(1040.42, 125.08, 32915.22),
     MobCFrame = CFrame.new(921.42, 125.08, 33235.22)},
    
    {Level = {1175, 1199}, Quest = "ShipQuest1", QuestLvl = 2, Enemy = "Ship Engineer",
     QuestCFrame = CFrame.new(1040.42, 125.08, 32915.22),
     MobCFrame = CFrame.new(886.42, 125.08, 33552.22)},
    
    {Level = {1200, 1224}, Quest = "ShipQuest2", QuestLvl = 1, Enemy = "Ship Steward",
     QuestCFrame = CFrame.new(968.28, 125.08, 33244.70),
     MobCFrame = CFrame.new(918.28, 125.08, 33444.70)},
    
    {Level = {1225, 1249}, Quest = "ShipQuest2", QuestLvl = 2, Enemy = "Ship Officer",
     QuestCFrame = CFrame.new(968.28, 125.08, 33244.70),
     MobCFrame = CFrame.new(955.28, 125.08, 32839.70)},
    
    {Level = {1250, 1274}, Quest = "FrostQuest", QuestLvl = 1, Enemy = "Arctic Warrior",
     QuestCFrame = CFrame.new(5668.09, 26.71, -6486.08),
     MobCFrame = CFrame.new(5935.09, 26.71, -6301.08)},
    
    {Level = {1275, 1299}, Quest = "FrostQuest", QuestLvl = 2, Enemy = "Snow Lurker",
     QuestCFrame = CFrame.new(5668.09, 26.71, -6486.08),
     MobCFrame = CFrame.new(5518.09, 63.71, -6773.08)},
    
    -- ========== SECOND SEA ==========
    {Level = {1300, 1324}, Quest = "ChocQuest1", QuestLvl = 1, Enemy = "Chocolate Bar Battler",
     QuestCFrame = CFrame.new(233.23, 29.88, -12201.23),
     MobCFrame = CFrame.new(172.23, 29.88, -12305.48)},
    
    {Level = {1325, 1349}, Quest = "ChocQuest1", QuestLvl = 2, Enemy = "Sweet Thief",
     QuestCFrame = CFrame.new(233.23, 29.88, -12201.23),
     MobCFrame = CFrame.new(34.23, 29.88, -12601.23)},
    
    {Level = {1350, 1374}, Quest = "ChocQuest2", QuestLvl = 1, Enemy = "Candy Rebel",
     QuestCFrame = CFrame.new(150.51, 30.69, -12774.61),
     MobCFrame = CFrame.new(47.51, 30.69, -12974.61)},
    
    {Level = {1375, 1399}, Quest = "ChocQuest2", QuestLvl = 2, Enemy = "Cocoa Warrior",
     QuestCFrame = CFrame.new(150.51, 30.69, -12774.61),
     MobCFrame = CFrame.new(58.91, 73.10, -12379.18)},
    
    {Level = {1400, 1424}, Quest = "MagmaQuest", QuestLvl = 1, Enemy = "Magma Ninja",
     QuestCFrame = CFrame.new(-5495.95, 48.52, -5264.14),
     MobCFrame = CFrame.new(-5922.06, 11.86, -5743.24)},
    
    {Level = {1425, 1449}, Quest = "MagmaQuest", QuestLvl = 2, Enemy = "Lava Pirate",
     QuestCFrame = CFrame.new(-5495.95, 48.52, -5264.14),
     MobCFrame = CFrame.new(-5308.29, 51.95, -4890.31)},
    
    -- ========== THIRD SEA ==========
    {Level = {1500, 1524}, Quest = "Area1Quest", QuestLvl = 1, Enemy = "Pirate Millionaire",
     QuestCFrame = CFrame.new(-288.61, 43.82, 5579.86),
     MobCFrame = CFrame.new(-435.68, 43.82, 5583.66)},
    
    {Level = {1525, 1574}, Quest = "Area1Quest", QuestLvl = 2, Enemy = "Pistol Billionaire",
     QuestCFrame = CFrame.new(-288.61, 43.82, 5579.86),
     MobCFrame = CFrame.new(-379.14, 43.82, 5984.03)},
    
    {Level = {1575, 1599}, Quest = "Area2Quest", QuestLvl = 1, Enemy = "Dragon Crew Warrior",
     QuestCFrame = CFrame.new(5834.14, 51.48, -1103.13),
     MobCFrame = CFrame.new(6241.59, 51.48, -1243.35)},
    
    {Level = {1600, 1624}, Quest = "Area2Quest", QuestLvl = 2, Enemy = "Dragon Crew Archer",
     QuestCFrame = CFrame.new(6483.28, 383.14, 139.45),
     MobCFrame = CFrame.new(6594.73, 383.14, 139.45)},
    
    {Level = {1625, 1649}, Quest = "MarineTreeIsland", QuestLvl = 1, Enemy = "Female Islander",
     QuestCFrame = CFrame.new(5243.14, 601.65, 344.59),
     MobCFrame = CFrame.new(5315.19, 601.65, 244.03)},
    
    {Level = {1650, 1699}, Quest = "MarineTreeIsland", QuestLvl = 2, Enemy = "Giant Islander",
     QuestCFrame = CFrame.new(5658.15, 601.65, -57.35),
     MobCFrame = CFrame.new(5347.41, 601.65, -106.28)},
    
    {Level = {1700, 1724}, Quest = "ForgottenQuest", QuestLvl = 1, Enemy = "Marine Commodore",
     QuestCFrame = CFrame.new(-2850.20, 72.99, -3300.90),
     MobCFrame = CFrame.new(-2850.20, 72.99, -3208.35)},
    
    {Level = {1725, 1774}, Quest = "ForgottenQuest", QuestLvl = 2, Enemy = "Marine Rear Admiral",
     QuestCFrame = CFrame.new(-5545.12, 28.65, -7755.08),
     MobCFrame = CFrame.new(-5636.09, 28.65, -7755.08)},
    
    {Level = {1775, 1799}, Quest = "DeepForestIsland", QuestLvl = 1, Enemy = "Mythological Pirate",
     QuestCFrame = CFrame.new(-13234.57, 331.58, -7625.78),
     MobCFrame = CFrame.new(-13508.62, 331.58, -7925.48)},
    
    {Level = {1800, 1849}, Quest = "DeepForestIsland2", QuestLvl = 1, Enemy = "Jungle Pirate",
     QuestCFrame = CFrame.new(-11975.96, 331.73, -10620.03),
     MobCFrame = CFrame.new(-12121.27, 331.73, -10654.84)},
    
    {Level = {1850, 1899}, Quest = "DeepForestIsland3", QuestLvl = 1, Enemy = "Musketeer Pirate",
     QuestCFrame = CFrame.new(-13283.43, 386.90, -9902.06),
     MobCFrame = CFrame.new(-13388.43, 386.90, -9902.06)},
    
    {Level = {1900, 1924}, Quest = "PiratePortQuest", QuestLvl = 1, Enemy = "Pirate",
     QuestCFrame = CFrame.new(-6240.98, 38.30, 5577.57),
     MobCFrame = CFrame.new(-6305.98, 38.30, 5577.57)},
    
    {Level = {1925, 1974}, Quest = "PiratePortQuest", QuestLvl = 2, Enemy = "Ship Deckhand",
     QuestCFrame = CFrame.new(-6508.65, 39.00, 5736.06),
     MobCFrame = CFrame.new(-6508.65, 39.00, 5836.06)},
    
    {Level = {1975, 1999}, Quest = "AmazonQuest", QuestLvl = 1, Enemy = "Amazon Warrior",
     QuestCFrame = CFrame.new(5497.07, 51.48, -1800.01),
     MobCFrame = CFrame.new(5386.07, 51.48, -1800.01)},
    
    {Level = {2000, 2024}, Quest = "AmazonQuest", QuestLvl = 2, Enemy = "Amazon Archer",
     QuestCFrame = CFrame.new(5251.51, 51.61, -1655.34),
     MobCFrame = CFrame.new(5145.51, 51.61, -1655.34)},
    
    {Level = {2025, 2049}, Quest = "HauntedQuest1", QuestLvl = 1, Enemy = "Living Zombie",
     QuestCFrame = CFrame.new(-9479.43, 141.22, 5566.09),
     MobCFrame = CFrame.new(-10144.07, 138.65, 5975.96)},
    
    {Level = {2050, 2074}, Quest = "HauntedQuest1", QuestLvl = 2, Enemy = "Demonic Soul",
     QuestCFrame = CFrame.new(-9515.62, 172.13, 6078.89),
     MobCFrame = CFrame.new(-9712.03, 172.13, 6144.49)},
    
    {Level = {2075, 2099}, Quest = "HauntedQuest2", QuestLvl = 1, Enemy = "Posessed Mummy",
     QuestCFrame = CFrame.new(-9546.99, 172.13, 6079.08),
     MobCFrame = CFrame.new(-9738.99, 172.13, 6079.08)},
    
    {Level = {2100, 2124}, Quest = "NutsIslandQuest", QuestLvl = 1, Enemy = "Peanut Scout",
     QuestCFrame = CFrame.new(-2104.39, 38.10, -10192.54),
     MobCFrame = CFrame.new(-2188.78, 38.10, -10289.54)},
    
    {Level = {2125, 2149}, Quest = "NutsIslandQuest", QuestLvl = 2, Enemy = "Peanut President",
     QuestCFrame = CFrame.new(-2150.41, 38.32, -10520.01),
     MobCFrame = CFrame.new(-1850.41, 38.32, -10520.01)},
    
    {Level = {2150, 2199}, Quest = "IceCreamIslandQuest", QuestLvl = 1, Enemy = "Ice Cream Chef",
     QuestCFrame = CFrame.new(-820.66, 65.81, -10965.97),
     MobCFrame = CFrame.new(-641.64, 125.95, -11062.80)},
    
    {Level = {2200, 2224}, Quest = "IceCreamIslandQuest", QuestLvl = 2, Enemy = "Ice Cream Commander",
     QuestCFrame = CFrame.new(-558.07, 125.95, -10965.98),
     MobCFrame = CFrame.new(-558.07, 125.95, -11062.80)},
    
    {Level = {2225, 2249}, Quest = "CakeQuest1", QuestLvl = 1, Enemy = "Cookie Crafter",
     QuestCFrame = CFrame.new(-2021.77, 37.80, -12027.74),
     MobCFrame = CFrame.new(-2374.47, 37.80, -12142.31)},
    
    {Level = {2250, 2274}, Quest = "CakeQuest1", QuestLvl = 2, Enemy = "Cake Guard",
     QuestCFrame = CFrame.new(-1570.91, 37.80, -12224.68),
     MobCFrame = CFrame.new(-1570.91, 37.80, -12424.68)},
    
    {Level = {2275, 2299}, Quest = "CakeQuest2", QuestLvl = 1, Enemy = "Baking Staff",
     QuestCFrame = CFrame.new(-1927.37, 37.80, -12983.11),
     MobCFrame = CFrame.new(-1927.37, 37.80, -13083.11)},
    
    {Level = {2300, 2324}, Quest = "CakeQuest2", QuestLvl = 2, Enemy = "Head Baker",
     QuestCFrame = CFrame.new(-2251.51, 52.25, -12373.53),
     MobCFrame = CFrame.new(-2251.51, 52.25, -12573.53)},
    
    {Level = {2325, 2349}, Quest = "ChocQuest1", QuestLvl = 1, Enemy = "Chocolate Bar Battler",
     QuestCFrame = CFrame.new(232.66, 24.82, -12243.20),
     MobCFrame = CFrame.new(172.23, 29.88, -12305.48)},
    
    {Level = {2350, 2374}, Quest = "ChocQuest1", QuestLvl = 2, Enemy = "Sweet Thief",
     QuestCFrame = CFrame.new(150.51, 30.69, -12774.61),
     MobCFrame = CFrame.new(150.51, 30.69, -12874.61)},
    
    {Level = {2375, 2399}, Quest = "ChocQuest2", QuestLvl = 1, Enemy = "Candy Rebel",
     QuestCFrame = CFrame.new(-12350.91, 332.40, -10507.69),
     MobCFrame = CFrame.new(-12350.91, 332.40, -10607.69)},
    
    {Level = {2400, 2424}, Quest = "ChocQuest2", QuestLvl = 2, Enemy = "Cocoa Warrior",
     QuestCFrame = CFrame.new(117.91, 73.10, -12319.44),
     MobCFrame = CFrame.new(58.91, 73.10, -12379.18)},
    
    {Level = {2425, 2450}, Quest = "SeaQuest1", QuestLvl = 1, Enemy = "Tide Keeper",
     QuestCFrame = CFrame.new(-3711.93, 235.99, -10467.96),
     MobCFrame = CFrame.new(-3711.93, 235.99, -10767.96)}
}

-- =============================================
-- 🎯 QUEST FUNCTIONS
-- =============================================
function GetQuestByLevel()
    local Level = Player.Data.Level.Value
    
    for _, v in pairs(QuestDatabase) do
        if Level >= v.Level[1] and Level <= v.Level[2] then
            return v
        end
    end
    
    return QuestDatabase[#QuestDatabase]
end

function HasQuest(EnemyName)
    local QuestUI = Player.PlayerGui:FindFirstChild("Main")
    if QuestUI and QuestUI:FindFirstChild("Quest") then
        local Title = QuestUI.Quest.Container.QuestTitle.Title.Text
        return string.find(Title, EnemyName) ~= nil
    end
    return false
end

function TakeQuest(QuestData)
    if not getgenv().Settings.AutoQuest then return true end
    
    if HasQuest(QuestData.Enemy) then
        return true
    end
    
    UpdateStatus("📜 Taking Quest: " .. QuestData.Enemy)
    
    -- TP to Quest Giver
    TP(QuestData.QuestCFrame)
    wait(1)
    
    -- Get closer
    if RootPart then
        RootPart.CFrame = QuestData.QuestCFrame * CFrame.new(0, 2, -3)
    end
    wait(0.8)
    
    -- Accept Quest
    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", QuestData.Quest, QuestData.QuestLvl)
    wait(1.5)
    
    -- Retry if failed
    if not HasQuest(QuestData.Enemy) then
        RootPart.CFrame = QuestData.QuestCFrame * CFrame.new(0, 0, -2)
        wait(0.5)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", QuestData.Quest, QuestData.QuestLvl)
        wait(1)
    end
    
    return HasQuest(QuestData.Enemy)
end

-- =============================================
-- 🚀 TELEPORT SYSTEM
-- =============================================
local TweenInProgress = false

function TP(targetCFrame, description)
    if not RootPart then return end
    if TweenInProgress then return end
    
    TweenInProgress = true
    
    local Distance = (targetCFrame.Position - RootPart.Position).Magnitude
    
    if description then
        UpdateStatus("🚀 " .. description .. " (" .. math.floor(Distance) .. " studs)")
    end
    
    if getgenv().Settings.InstantTeleport then
        -- ⚠️ INSTANT TP (RISKY)
        EnableNoClip()
        RootPart.CFrame = targetCFrame
        wait(0.5)
        DisableNoClip()
    elseif getgenv().Settings.BypassTeleport and Distance > 1500 then
        -- 🛡️ BYPASS MODE
        BypassTP(targetCFrame)
    else
        -- ✈️ NORMAL TWEEN
        NormalTween(targetCFrame)
    end
    
    TweenInProgress = false
end

function NormalTween(targetCFrame)
    local Distance = (targetCFrame.Position - RootPart.Position).Magnitude
    local Duration = Distance / getgenv().Settings.TweenSpeed
    
    local Tween = TweenService:Create(
        RootPart,
        TweenInfo.new(Duration, Enum.EasingStyle.Linear),
        {CFrame = targetCFrame}
    )
    
    Tween:Play()
    Tween.Completed:Wait()
end

function BypassTP(targetCFrame)
    EnableNoClip()
    
    local Distance = (targetCFrame.Position - RootPart.Position).Magnitude
    local Checkpoints = math.floor(Distance / 1500)
    local Direction = (targetCFrame.Position - RootPart.Position).Unit
    
    for i = 1, Checkpoints do
        local CheckpointPos = RootPart.Position + (Direction * 1500)
        RootPart.CFrame = CFrame.new(CheckpointPos)
        wait(0.15)
    end
    
    RootPart.CFrame = targetCFrame
    wait(0.5)
    
    DisableNoClip()
end

-- =============================================
-- 🛡️ NOCLIP SYSTEM
-- =============================================
local NoClipConnection

function EnableNoClip()
    if NoClipConnection then return end
    
    NoClipConnection = RunService.Stepped:Connect(function()
        if Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function DisableNoClip()
    if NoClipConnection then
        NoClipConnection:Disconnect()
        NoClipConnection = nil
    end
    
    if Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

-- =============================================
-- ⚔️ COMBAT SYSTEM
-- =============================================
function EquipWeapon()
    local WeaponName = getgenv().Settings.SelectWeapon
    
    pcall(function()
        local Tool = Player.Backpack:FindFirstChild(WeaponName) or Character:FindFirstChild(WeaponName)
        if Tool and not Character:FindFirstChild(WeaponName) then
            Humanoid:EquipTool(Tool)
        end
    end)
end

local FastAttackLoop

function StartFastAttack()
    if FastAttackLoop then return end
    
    FastAttackLoop = RunService.Heartbeat:Connect(function()
        if getgenv().Settings.FastAttack then
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(getgenv().Settings.FastAttackDelay)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end
    end)
end

function StopFastAttack()
    if FastAttackLoop then
        FastAttackLoop:Disconnect()
        FastAttackLoop = nil
    end
end

function EnableHaki()
    if getgenv().Settings.AutoHaki and not Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

function BringMobs(Enemy)
    if not getgenv().Settings.BringMob or not Enemy then return end
    
    pcall(function()
        if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") then
            if Enemy.Humanoid.Health > 0 then
                Enemy.HumanoidRootPart.CanCollide = false
                Enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                Enemy.HumanoidRootPart.Transparency = 1
                
                if RootPart then
                    Enemy.HumanoidRootPart.CFrame = RootPart.CFrame * CFrame.new(0, 0, -getgenv().Settings.FarmDistance)
                end
                
                -- Disable Enemy AI
                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
            end
        end
    end)
end

-- =============================================
-- 🎯 MAIN FARM LOOP
-- =============================================
local FarmLoop

function StartAutoFarm()
    if FarmLoop then return end
    
    FarmLoop = RunService.Heartbeat:Connect(function()
        if not getgenv().Settings.AutoFarmLevel then
            StopFastAttack()
            return
        end
        
        pcall(function()
            local QuestData = GetQuestByLevel()
            
            -- Step 1: Take Quest
            if getgenv().Settings.CheckQuestBeforeFarm and not HasQuest(QuestData.Enemy) then
                StopFastAttack()
                UpdateStatus("📜 Getting Quest: " .. QuestData.Enemy)
                TakeQuest(QuestData)
                wait(2)
                return
            end
            
            -- Step 2: Find Enemy
            local Enemy = nil
            for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                if mob.Name == QuestData.Enemy and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    Enemy = mob
                    break
                end
            end
            
            -- Step 3: Farm
            if Enemy and Enemy:FindFirstChild("HumanoidRootPart") then
                UpdateStatus("⚔️ Farming: " .. QuestData.Enemy)
                
                EnableHaki()
                EquipWeapon()
                StartFastAttack()
                
                if RootPart then
                    local TargetPos = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().Settings.FarmDistance, 0)
                    RootPart.CFrame = TargetPos
                    
                    Humanoid.AutoRotate = false
                    RootPart.CFrame = CFrame.new(RootPart.Position, Enemy.HumanoidRootPart.Position)
                end
                
                BringMobs(Enemy)
                
            else
                StopFastAttack()
                UpdateStatus("🔍 Searching for: " .. QuestData.Enemy)
                if QuestData.MobCFrame then
                    TP(QuestData.MobCFrame, "Going to Mob Spawn")
                    wait(3)
                end
            end
        end)
    end)
end

function StopAutoFarm()
    if FarmLoop then
        FarmLoop:Disconnect()
        FarmLoop = nil
    end
    StopFastAttack()
    DisableNoClip()
    if Humanoid then Humanoid.AutoRotate = true end
    UpdateStatus("Idle")
end

-- =============================================
-- 📊 AUTO STATS
-- =============================================
spawn(function()
    while wait(0.2) do
        pcall(function()
            if getgenv().Settings.AutoStats.Melee then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
            end
            if getgenv().Settings.AutoStats.Defense then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end
            if getgenv().Settings.AutoStats.Sword then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
            end
            if getgenv().Settings.AutoStats.Gun then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
            end
            if getgenv().Settings.AutoStats.Fruit then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
            end
        end)
    end
end)

-- =============================================
-- 🎨 FARM TAB
-- =============================================
local FarmSection = Tabs.Farm:AddSection("⚔️ Main Farm")

Tabs.Farm:AddToggle("AutoFarmLevel", {
    Title = "Auto Farm Level",
    Description = "Farm levels automatically with quests",
    Default = false
}):OnChanged(function(value)
    getgenv().Settings.AutoFarmLevel = value
    
    if value then
        StartAutoFarm()
        local Quest = GetQuestByLevel()
        Fluent:Notify({
            Title = "Auto Farm Started",
            Content = "Target: " .. Quest.Enemy,
            Duration = 5
        })
    else
        StopAutoFarm()
        Fluent:Notify({
            Title = "Auto Farm Stopped",
            Content = "Farm stopped successfully",
            Duration = 3
        })
    end
end)

Tabs.Farm:AddToggle("AutoQuest", {
    Title = "Auto Take Quest",
    Default = true
}):OnChanged(function(value)
    getgenv().Settings.AutoQuest = value
end)

Tabs.Farm:AddToggle("CheckQuestBeforeFarm", {
    Title = "Check Quest Before Farm",
    Default = true
}):OnChanged(function(value)
    getgenv().Settings.CheckQuestBeforeFarm = value
end)

local WeaponSection = Tabs.Farm:AddSection("🗡️ Weapon Settings")

local WeaponDropdown = Tabs.Farm:AddDropdown("SelectWeapon", {
    Title = "Select Weapon",
    Values = {"Combat", "Melee", "Sword", "Gun", "Blox Fruit"},
    Multi = false,
    Default = 1
})

WeaponDropdown:OnChanged(function(value)
    getgenv().Settings.SelectWeapon = value
end)

local MobSection = Tabs.Farm:AddSection("👹 Mob Settings")

Tabs.Farm:AddToggle("BringMob", {
    Title = "Bring Mobs",
    Default = true
}):OnChanged(function(value)
    getgenv().Settings.BringMob = value
end)

Tabs.Farm:AddSlider("FarmDistance", {
    Title = "Farm Distance",
    Description = "Distance from mob while farming",
    Default = 25,
    Min = 15,
    Max = 50,
    Rounding = 0
}):OnChanged(function(value)
    getgenv().Settings.FarmDistance = value
end)

-- =============================================
-- ⚡ COMBAT TAB
-- =============================================
local AttackSection = Tabs.Combat:AddSection("⚔️ Combat Settings")

Tabs.Combat:AddToggle("FastAttack", {
    Title = "Fast Attack",
    Default = true
}):OnChanged(function(value)
    getgenv().Settings.FastAttack = value
end)

Tabs.Combat:AddSlider("FastAttackDelay", {
    Title = "Fast Attack Delay",
    Default = 0.1,
    Min = 0,
    Max = 0.5,
    Rounding = 2
}):OnChanged(function(value)
    getgenv().Settings.FastAttackDelay = value
end)

Tabs.Combat:AddToggle("AutoHaki", {
    Title = "Auto Haki",
    Default = true
}):OnChanged(function(value)
    getgenv().Settings.AutoHaki = value
end)

-- =============================================
-- 📊 STATS TAB
-- =============================================
Tabs.Stats:AddToggle("AutoMelee", {
    Title = "Auto Melee",
    Default = false
}):OnChanged(function(value)
    getgenv().Settings.AutoStats.Melee = value
end)

Tabs.Stats:AddToggle("AutoDefense", {
    Title = "Auto Defense",
    Default = false
}):OnChanged(function(value)
    getgenv().Settings.AutoStats.Defense = value
end)

Tabs.Stats:AddToggle("AutoSword", {
    Title = "Auto Sword",
    Default = false
}):OnChanged(function(value)
    getgenv().Settings.AutoStats.Sword = value
end)

Tabs.Stats:AddToggle("AutoGun", {
    Title = "Auto Gun",
    Default = false
}):OnChanged(function(value)
    getgenv().Settings.AutoStats.Gun = value
end)

Tabs.Stats:AddToggle("AutoFruit", {
    Title = "Auto Devil Fruit",
    Default = false
}):OnChanged(function(value)
    getgenv().Settings.AutoStats.Fruit = value
end)

-- =============================================
-- 🌍 TELEPORT TAB
-- =============================================
local TPSection = Tabs.Teleport:AddSection("🚀 Teleport Settings")

Tabs.Teleport:AddToggle("BypassTeleport", {
    Title = "Bypass Teleport",
    Description = "Use checkpoints for long distances",
    Default = true
}):OnChanged(function(value)
    getgenv().Settings.BypassTeleport = value
end)

Tabs.Teleport:AddToggle("InstantTeleport", {
    Title = "⚠️ Instant Teleport (RISKY)",
    Description = "May cause kicks!",
    Default = false
}):OnChanged(function(value)
    getgenv().Settings.InstantTeleport = value
    
    if value then
        Fluent:Notify({
            Title = "⚠️ Warning",
            Content = "Instant TP may cause account kicks!",
            Duration = 5
        })
    end
end)

Tabs.Teleport:AddSlider("TweenSpeed", {
    Title = "Tween Speed",
    Default = 350,
    Min = 250,
    Max = 500,
    Rounding = 0
}):OnChanged(function(value)
    getgenv().Settings.TweenSpeed = value
end)

-- =============================================
-- ⚙️ MISC TAB
-- =============================================
local VisualSection = Tabs.Misc:AddSection("🎨 Visual Settings")

Tabs.Misc:AddButton({
    Title = "Remove Fog",
    Description = "Clear game fog for better visibility",
    Callback = function()
        game:GetService("Lighting").FogEnd = 100000
        Fluent:Notify({
            Title = "Visual",
            Content = "Fog removed successfully!",
            Duration = 3
        })
    end
})

Tabs.Misc:AddButton({
    Title = "FPS Boost",
    Description = "Optimize game performance",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            end
        end
        Fluent:Notify({
            Title = "Performance",
            Content = "FPS optimized!",
            Duration = 3
        })
    end
})

local UtilitySection = Tabs.Misc:AddSection("🔧 Utilities")

Tabs.Misc:AddToggle("AntiAFK", {
    Title = "Anti AFK",
    Default = true
}):OnChanged(function(value)
    getgenv().Settings.AntiAFK = value
end)

-- Anti AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if getgenv().Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- =============================================
-- 💾 CONFIG TAB
-- =============================================
Tabs.Configs:AddButton({
    Title = "Save Configuration",
    Description = "Save current settings",
    Callback = function()
        writefile("VortexHub_Config.json", game:GetService("HttpService"):JSONEncode(getgenv().Settings))
        Fluent:Notify({
            Title = "Config",
            Content = "Settings saved successfully!",
            Duration = 3
        })
    end
})

Tabs.Configs:AddButton({
    Title = "Load Configuration",
    Description = "Load saved settings",
    Callback = function()
        if isfile("VortexHub_Config.json") then
            getgenv().Settings = game:GetService("HttpService"):JSONDecode(readfile("VortexHub_Config.json"))
            Fluent:Notify({
                Title = "Config",
                Content = "Settings loaded successfully!",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Config",
                Content = "No saved config found!",
                Duration = 3
            })
        end
    end
})

-- =============================================
-- 🎬 INITIALIZE
-- =============================================
Window:SelectTab(1)

Fluent:Notify({
    Title = "🔱 VORTEX HUB V3 🔱",
    Content = "Loaded successfully! Level: " .. Player.Data.Level.Value,
    Duration = 5
})

print("✅ Vortex Hub V3 Loaded | Redz Style | Level: " .. Player.Data.Level.Value)
