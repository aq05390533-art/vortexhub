--[[
    VORTEX HUB V4 - ULTIMATE EDITION
    Smart Navigation System
    - Anti-Stuck
    - Anti-Water Death
    - Smooth Movement
]]--

-- =============================================
-- PROTECTION
-- =============================================
if getgenv().VortexLoaded then return end
getgenv().VortexLoaded = true

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" or method == "InvokeServer" then
        task.wait(math.random(5, 15) / 1000)
    end
    
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- =============================================
-- UI LIBRARY
-- =============================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Vortex Hub V4 Ultimate",
    SubTitle = "Smart Anti-Stuck System",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "zap" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "sliders" }),
    Stats = Window:AddTab({ Title = "Stats", Icon = "trending-up" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

-- =============================================
-- SERVICES
-- =============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local PathfindingService = game:GetService("PathfindingService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

-- =============================================
-- SETTINGS
-- =============================================
getgenv().Config = {
    AutoFarm = false,
    SelectedWeapon = "Melee",
    FastAttack = true,
    BringMobs = true,
    AutoHaki = true,
    DistanceFromMob = 25,
    TweenSpeed = 350,
    UseQuest = true,
    AttackDelay = 0.1,
    
    -- جديد - إعدادات الحماية
    AntiStuck = true,
    AntiWater = true,
    SafeHeight = 50, -- الارتفاع الآمن فوق الماء
    StuckTimeout = 3, -- ثواني قبل اعتبار اللاعب عالق
    UseBypass = true -- استخدام الـ Bypass للجدران
}

-- =============================================
-- QUEST DATABASE
-- =============================================
local QuestList = {
    -- SEA 1
    {Lvl = {1, 9}, Quest = "BanditQuest1", QuestLvl = 1, Enemy = "Bandit", 
     QuestPos = CFrame.new(1059.37, 16.55, 1550.42), 
     EnemySpawn = CFrame.new(1045, 17, 1560)},
     
    {Lvl = {10, 14}, Quest = "JungleQuest", QuestLvl = 1, Enemy = "Monkey", 
     QuestPos = CFrame.new(-1598.09, 35.55, 153.38), 
     EnemySpawn = CFrame.new(-1448, 50, 38)},
     
    {Lvl = {15, 29}, Quest = "BuggyQuest1", QuestLvl = 1, Enemy = "Bandit", 
     QuestPos = CFrame.new(-1119.81, 4.79, 3831.37), 
     EnemySpawn = CFrame.new(-1120, 15, 3900)},
     
    {Lvl = {30, 39}, Quest = "DesertQuest", QuestLvl = 1, Enemy = "Desert Bandit", 
     QuestPos = CFrame.new(897.03, 6.45, 4388.93), 
     EnemySpawn = CFrame.new(924, 7, 4481)},
     
    {Lvl = {40, 59}, Quest = "SnowQuest", QuestLvl = 1, Enemy = "Snowman", 
     QuestPos = CFrame.new(1389.74, 87.27, -1296.68), 
     EnemySpawn = CFrame.new(1384, 87, -1296)},
     
    {Lvl = {60, 74}, Quest = "MarineQuest2", QuestLvl = 1, Enemy = "Chief Petty Officer", 
     QuestPos = CFrame.new(-5039.59, 28.65, 4324.68), 
     EnemySpawn = CFrame.new(-4882, 21, 4260)},
     
    {Lvl = {75, 89}, Quest = "AreaQuest", QuestLvl = 1, Enemy = "Sky Bandit", 
     QuestPos = CFrame.new(-4841.83, 717.67, -2623.96), 
     EnemySpawn = CFrame.new(-4970, 717, -2900)},
     
    {Lvl = {90, 99}, Quest = "AreaQuest", QuestLvl = 2, Enemy = "Dark Master", 
     QuestPos = CFrame.new(-5259.71, 389.81, -2229.84), 
     EnemySpawn = CFrame.new(-5260, 389, -2229)},
     
    {Lvl = {100, 119}, Quest = "PrisonerQuest", QuestLvl = 1, Enemy = "Prisoner", 
     QuestPos = CFrame.new(5308.93, 1.66, 475.12), 
     EnemySpawn = CFrame.new(5411, 96, 690)},
     
    {Lvl = {120, 149}, Quest = "ColosseumQuest", QuestLvl = 1, Enemy = "Gladiator", 
     QuestPos = CFrame.new(-1534.61, 7.40, -29.25), 
     EnemySpawn = CFrame.new(-1267, 8, -2983)},
     
    {Lvl = {150, 174}, Quest = "MagmaQuest", QuestLvl = 1, Enemy = "Lava Pirate", 
     QuestPos = CFrame.new(-5234.61, 51.95, -4732.22), 
     EnemySpawn = CFrame.new(-5250, 50, -4732)},
     
    {Lvl = {175, 189}, Quest = "MagmaQuest", QuestLvl = 2, Enemy = "Magma Admiral", 
     QuestPos = CFrame.new(-5530.13, 85.51, -5380.11), 
     EnemySpawn = CFrame.new(-5530, 86, -5380)},
     
    {Lvl = {190, 209}, Quest = "FishmanQuest", QuestLvl = 1, Enemy = "Fishman Warrior", 
     QuestPos = CFrame.new(60858.59, 18.47, 1389.26), 
     EnemySpawn = CFrame.new(60878, 19, 1389)},
     
    {Lvl = {210, 249}, Quest = "FishmanQuest", QuestLvl = 2, Enemy = "Fishman Commando", 
     QuestPos = CFrame.new(61123.04, 18.47, 1569.60), 
     EnemySpawn = CFrame.new(61922, 19, 1584)},
     
    {Lvl = {250, 274}, Quest = "SkypieaQuest", QuestLvl = 1, Enemy = "God's Guard", 
     QuestPos = CFrame.new(-4721.89, 843.87, -1949.97), 
     EnemySpawn = CFrame.new(-4698, 845, -1912)},
     
    {Lvl = {275, 299}, Quest = "SkypieaQuest", QuestLvl = 2, Enemy = "Shanda", 
     QuestPos = CFrame.new(-7859.10, 5544.19, -381.48), 
     EnemySpawn = CFrame.new(-7678, 5566, -497)},
     
    {Lvl = {300, 324}, Quest = "SkyExp1Quest", QuestLvl = 1, Enemy = "Royal Squad", 
     QuestPos = CFrame.new(-7906.82, 5634.66, -1411.99), 
     EnemySpawn = CFrame.new(-7624, 5658, -1704)},
     
    {Lvl = {325, 374}, Quest = "SkyExp1Quest", QuestLvl = 2, Enemy = "Royal Soldier", 
     QuestPos = CFrame.new(-7668.47, 5607.01, -1460.95), 
     EnemySpawn = CFrame.new(-7670, 5607, -1460)},
     
    {Lvl = {375, 399}, Quest = "SkyExp2Quest", QuestLvl = 1, Enemy = "Galley Pirate", 
     QuestPos = CFrame.new(-4990.17, 717.71, -2900.96), 
     EnemySpawn = CFrame.new(-4990, 717, -2900)},
     
    {Lvl = {400, 449}, Quest = "SkyExp2Quest", QuestLvl = 2, Enemy = "Galley Captain", 
     QuestPos = CFrame.new(-5533.20, 528.23, -3141.40), 
     EnemySpawn = CFrame.new(-5533, 528, -3141)},
     
    {Lvl = {450, 474}, Quest = "FountainQuest", QuestLvl = 1, Enemy = "Cyborg", 
     QuestPos = CFrame.new(5834.09, 38.53, 4047.69), 
     EnemySpawn = CFrame.new(6041, 37, 3988)},
     
    {Lvl = {475, 524}, Quest = "FountainQuest", QuestLvl = 2, Enemy = "Cyborg", 
     QuestPos = CFrame.new(6239.33, 38.53, 3945.40), 
     EnemySpawn = CFrame.new(6125, 37, 3991)},
     
    {Lvl = {525, 549}, Quest = "ZombieQuest", QuestLvl = 1, Enemy = "Zombie", 
     QuestPos = CFrame.new(-5497.06, 47.59, -795.24), 
     EnemySpawn = CFrame.new(-5657, 126, -923)},
     
    {Lvl = {550, 574}, Quest = "ZombieQuest", QuestLvl = 2, Enemy = "Vampire", 
     QuestPos = CFrame.new(-6037.66, 6.80, -1313.56), 
     EnemySpawn = CFrame.new(-6033, 7, -1313)},
     
    {Lvl = {575, 599}, Quest = "ShipQuest1", QuestLvl = 1, Enemy = "Pirate", 
     QuestPos = CFrame.new(1037.80, 125.09, 32911.60), 
     EnemySpawn = CFrame.new(1071, 125, 32911)},
     
    {Lvl = {600, 624}, Quest = "ShipQuest1", QuestLvl = 2, Enemy = "Pirate", 
     QuestPos = CFrame.new(971.55, 125.09, 33245.61), 
     EnemySpawn = CFrame.new(1103, 125, 32911)},
     
    {Lvl = {625, 649}, Quest = "ShipQuest2", QuestLvl = 1, Enemy = "Ship Deckhand", 
     QuestPos = CFrame.new(1162.27, 125.09, 32911.57), 
     EnemySpawn = CFrame.new(1196, 125, 33040)},
     
    {Lvl = {650, 699}, Quest = "ShipQuest2", QuestLvl = 2, Enemy = "Ship Engineer", 
     QuestPos = CFrame.new(918.28, 43.83, 32787.02), 
     EnemySpawn = CFrame.new(918, 44, 32787)},
     
    {Lvl = {700, 724}, Quest = "FrostQuest", QuestLvl = 1, Enemy = "Raider", 
     QuestPos = CFrame.new(-5496.17, 48.59, -4800.24), 
     EnemySpawn = CFrame.new(-5555, 49, -4800)},
     
    {Lvl = {725, 774}, Quest = "FrostQuest", QuestLvl = 2, Enemy = "Mercenary", 
     QuestPos = CFrame.new(-5231.36, 42.50, -4519.27), 
     EnemySpawn = CFrame.new(-5231, 42, -4519)},
     
    {Lvl = {775, 799}, Quest = "PrisonQuest", QuestLvl = 1, Enemy = "Dangerous Prisoner", 
     QuestPos = CFrame.new(5308.93, 0.61, 474.89), 
     EnemySpawn = CFrame.new(5411, 96, 690)},
     
    {Lvl = {800, 874}, Quest = "ColosseumQuest", QuestLvl = 1, Enemy = "Toga Warrior", 
     QuestPos = CFrame.new(-1576.11, 7.39, -2983.31), 
     EnemySpawn = CFrame.new(-1576, 7, -2984)},
     
    {Lvl = {875, 899}, Quest = "ColosseumQuest", QuestLvl = 2, Enemy = "Gladiator", 
     QuestPos = CFrame.new(-1267.86, 8.19, -2983.80), 
     EnemySpawn = CFrame.new(-1267, 8, -2983)},
     
    {Lvl = {900, 949}, Quest = "MagmaQuest", QuestLvl = 1, Enemy = "Military Soldier", 
     QuestPos = CFrame.new(-5313.54, 10.95, 8515.29), 
     EnemySpawn = CFrame.new(-5363, 11, 8556)},
     
    {Lvl = {950, 974}, Quest = "MagmaQuest", QuestLvl = 2, Enemy = "Military Spy", 
     QuestPos = CFrame.new(-5815.42, 83.97, 8820.77), 
     EnemySpawn = CFrame.new(-5787, 84, 8762)},
     
    {Lvl = {975, 999}, Quest = "SnowMountainQuest", QuestLvl = 1, Enemy = "Winter Warrior", 
     QuestPos = CFrame.new(607.06, 401.45, -5370.55), 
     EnemySpawn = CFrame.new(1289, 429, -5087)},
     
    {Lvl = {1000, 1049}, Quest = "SnowMountainQuest", QuestLvl = 2, Enemy = "Lab Subordinate", 
     QuestPos = CFrame.new(-5769.20, 23.78, -4203.42), 
     EnemySpawn = CFrame.new(-5720, 24, -4015)},
     
    {Lvl = {1050, 1099}, Quest = "IceSideQuest", QuestLvl = 1, Enemy = "Horned Warrior", 
     QuestPos = CFrame.new(-6078.45, 15.65, -5376.84), 
     EnemySpawn = CFrame.new(-6400, 16, -5805)},
     
    {Lvl = {1100, 1124}, Quest = "IceSideQuest", QuestLvl = 2, Enemy = "Magma Ninja", 
     QuestPos = CFrame.new(-5428.03, 15.98, -5299.43), 
     EnemySpawn = CFrame.new(-5900, 16, -5521)},
     
    {Lvl = {1125, 1174}, Quest = "FireSideQuest", QuestLvl = 1, Enemy = "Lava Pirate", 
     QuestPos = CFrame.new(-5234.61, 15.98, -4906.91), 
     EnemySpawn = CFrame.new(-5234, 16, -4732)},
     
    {Lvl = {1175, 1199}, Quest = "FireSideQuest", QuestLvl = 2, Enemy = "Ship Deckhand", 
     QuestPos = CFrame.new(-5034.82, 15.98, -4905.30), 
     EnemySpawn = CFrame.new(-5034, 16, -4905)},
     
    {Lvl = {1200, 1249}, Quest = "ShipQuest1", QuestLvl = 1, Enemy = "Ship Steward", 
     QuestPos = CFrame.new(1037.80, 125.09, 32911.60), 
     EnemySpawn = CFrame.new(921, 125, 33235)},
     
    {Lvl = {1250, 1274}, Quest = "ShipQuest2", QuestLvl = 1, Enemy = "Ship Officer", 
     QuestPos = CFrame.new(919.35, 125.09, 32918.89), 
     EnemySpawn = CFrame.new(915, 181, 33424)},
     
    {Lvl = {1275, 1299}, Quest = "FrostQuest", QuestLvl = 1, Enemy = "Arctic Warrior", 
     QuestPos = CFrame.new(5668.09, 28.20, -6484.25), 
     EnemySpawn = CFrame.new(5839, 57, -6178)},
     
    -- SEA 2
    {Lvl = {1300, 1324}, Quest = "ChocQuest1", QuestLvl = 1, Enemy = "Chocolate Bar Battler", 
     QuestPos = CFrame.new(233.23, 29.88, -12201.23), 
     EnemySpawn = CFrame.new(620, 78, -12581)},
     
    {Lvl = {1325, 1349}, Quest = "ChocQuest2", QuestLvl = 1, Enemy = "Sweet Thief", 
     QuestPos = CFrame.new(150.51, 30.69, -12774.61), 
     EnemySpawn = CFrame.new(142, 78, -12847)},
     
    {Lvl = {1350, 1374}, Quest = "CocoaQuest", QuestLvl = 1, Enemy = "Cocoa Warrior", 
     QuestPos = CFrame.new(117.91, 73.10, -12319.44), 
     EnemySpawn = CFrame.new(117, 78, -12319)},
     
    {Lvl = {1375, 1424}, Quest = "CocoaQuest", QuestLvl = 2, Enemy = "Chocolate Bar Battler", 
     QuestPos = CFrame.new(527.11, 73.11, -12849.74), 
     EnemySpawn = CFrame.new(620, 78, -12581)},
     
    {Lvl = {1425, 1449}, Quest = "CakeQuest1", QuestLvl = 1, Enemy = "Cookie Crafter", 
     QuestPos = CFrame.new(-2020.82, 37.83, -12027.74), 
     EnemySpawn = CFrame.new(-2374, 38, -12142)},
     
    {Lvl = {1450, 1474}, Quest = "CakeQuest1", QuestLvl = 2, Enemy = "Cake Guard", 
     QuestPos = CFrame.new(-1570.91, 37.83, -12224.68), 
     EnemySpawn = CFrame.new(-1928, 38, -12030)},
     
    {Lvl = {1475, 1524}, Quest = "CakeQuest2", QuestLvl = 1, Enemy = "Baking Staff", 
     QuestPos = CFrame.new(-1927.69, 37.83, -12983.84), 
     EnemySpawn = CFrame.new(-1927, 38, -12983)},
     
    {Lvl = {1525, 1574}, Quest = "CakeQuest2", QuestLvl = 2, Enemy = "Head Baker", 
     QuestPos = CFrame.new(-2251.51, 52.28, -12373.16), 
     EnemySpawn = CFrame.new(-2251, 52, -12373)},
     
    {Lvl = {1575, 1599}, Quest = "IceCreamQuest", QuestLvl = 1, Enemy = "Ice Cream Chef", 
     QuestPos = CFrame.new(-820.66, 65.81, -10965.97), 
     EnemySpawn = CFrame.new(-820, 66, -10965)},
     
    {Lvl = {1600, 1624}, Quest = "IceCreamQuest", QuestLvl = 2, Enemy = "Ice Cream Commander", 
     QuestPos = CFrame.new(-558.54, 73.61, -10965.94), 
     EnemySpawn = CFrame.new(-558, 74, -10965)},
     
    {Lvl = {1625, 1649}, Quest = "SeaBeasts1", QuestLvl = 1, Enemy = "Pirate Millionaire", 
     QuestPos = CFrame.new(-289.63, 43.82, 5579.98), 
     EnemySpawn = CFrame.new(-289, 44, 5580)},
     
    {Lvl = {1650, 1699}, Quest = "SeaBeasts1", QuestLvl = 2, Enemy = "Pistol Billionaire", 
     QuestPos = CFrame.new(-295.30, 43.82, 5555.32), 
     EnemySpawn = CFrame.new(-295, 44, 5555)},
     
    {Lvl = {1700, 1724}, Quest = "ForgetQuest", QuestLvl = 1, Enemy = "Dragon Crew Warrior", 
     QuestPos = CFrame.new(6339.12, 51.27, -1213.86), 
     EnemySpawn = CFrame.new(6339, 52, -1213)},
     
    {Lvl = {1725, 1774}, Quest = "ForgetQuest", QuestLvl = 2, Enemy = "Dragon Crew Archer", 
     QuestPos = CFrame.new(6594.73, 383.14, 139.45), 
     EnemySpawn = CFrame.new(6594, 383, 139)},
     
    {Lvl = {1775, 1799}, Quest = "ForgottenQuest", QuestLvl = 1, Enemy = "Female Islander", 
     QuestPos = CFrame.new(5244.53, 601.65, 345.08), 
     EnemySpawn = CFrame.new(5244, 602, 345)},
     
    {Lvl = {1800, 1849}, Quest = "ForgottenQuest", QuestLvl = 2, Enemy = "Giant Islander", 
     QuestPos = CFrame.new(5347.41, 601.65, -106.28), 
     EnemySpawn = CFrame.new(5347, 602, -106)},
     
    {Lvl = {1850, 1899}, Quest = "HauntedQuest1", QuestLvl = 1, Enemy = "Marine Commodore", 
     QuestPos = CFrame.new(-2850.20, 72.99, -3300.90), 
     EnemySpawn = CFrame.new(2850, 73, -3300)},
     
    {Lvl = {1900, 1924}, Quest = "HauntedQuest2", QuestLvl = 1, Enemy = "Marine Rear Admiral", 
     QuestPos = CFrame.new(-5545.12, 28.65, -7755.08), 
     EnemySpawn = CFrame.new(-5545, 29, -7755)},
     
    {Lvl = {1925, 1974}, Quest = "DeepForestIsland", QuestLvl = 1, Enemy = "Mythological Pirate", 
     QuestPos = CFrame.new(-13234.57, 331.58, -7625.78), 
     EnemySpawn = CFrame.new(-13234, 332, -7625)},
     
    {Lvl = {1975, 1999}, Quest = "DeepForestIsland2", QuestLvl = 1, Enemy = "Jungle Pirate", 
     QuestPos = CFrame.new(-11975.96, 331.73, -10620.03), 
     EnemySpawn = CFrame.new(-11975, 332, -10620)},
     
    {Lvl = {2000, 2024}, Quest = "DeepForestIsland3", QuestLvl = 1, Enemy = "Musketeer Pirate", 
     QuestPos = CFrame.new(-13283.43, 386.90, -9902.06), 
     EnemySpawn = CFrame.new(-13283, 387, -9902)},
     
    {Lvl = {2025, 2049}, Quest = "PiratePortQuest", QuestLvl = 1, Enemy = "Pirate", 
     QuestPos = CFrame.new(-6240.98, 38.30, 5577.57), 
     EnemySpawn = CFrame.new(-6240, 38, 5577)},
     
    {Lvl = {2050, 2074}, Quest = "PiratePortQuest", QuestLvl = 2, Enemy = "Pistol Billionaire", 
     QuestPos = CFrame.new(-6508.65, 39.00, 5736.06), 
     EnemySpawn = CFrame.new(-6508, 39, 5736)},
     
    {Lvl = {2075, 2099}, Quest = "AmazonQuest", QuestLvl = 1, Enemy = "Amazon Warrior", 
     QuestPos = CFrame.new(5497.07, 51.48, -1800.01), 
     EnemySpawn = CFrame.new(5497, 52, -1800)},
     
    {Lvl = {2100, 2124}, Quest = "AmazonQuest", QuestLvl = 2, Enemy = "Amazon Archer", 
     QuestPos = CFrame.new(5251.51, 51.61, -1655.34), 
     EnemySpawn = CFrame.new(5251, 52, -1655)},
     
    {Lvl = {2125, 2149}, Quest = "MarineTreeIsland", QuestLvl = 1, Enemy = "Marine Captain", 
     QuestPos = CFrame.new(-4914.82, 717.70, -2622.35), 
     EnemySpawn = CFrame.new(-4914, 717, -2622)},
     
    {Lvl = {2150, 2174}, Quest = "MarineTreeIsland", QuestLvl = 2, Enemy = "Marine Commodore", 
     QuestPos = CFrame.new(2286.01, 73.13, -7159.81), 
     EnemySpawn = CFrame.new(2850, 73, -7190)},
     
    {Lvl = {2175, 2199}, Quest = "DeepForestIsland", QuestLvl = 1, Enemy = "Reborn Skeleton", 
     QuestPos = CFrame.new(-9515.75, 172.13, 6079.41), 
     EnemySpawn = CFrame.new(-9515, 172, 6079)},
     
    {Lvl = {2200, 2224}, Quest = "DeepForestIsland2", QuestLvl = 1, Enemy = "Living Zombie", 
     QuestPos = CFrame.new(-10238.88, 172.13, 6132.63), 
     EnemySpawn = CFrame.new(-10238, 172, 6133)},
     
    {Lvl = {2225, 2249}, Quest = "DeepForestIsland3", QuestLvl = 1, Enemy = "Demonic Soul", 
     QuestPos = CFrame.new(-9507.81, 172.13, 6158.99), 
     EnemySpawn = CFrame.new(-9507, 172, 6158)},
     
    {Lvl = {2250, 2274}, Quest = "HauntedQuest1", QuestLvl = 1, Enemy = "Posessed Mummy", 
     QuestPos = CFrame.new(-9546.99, 172.13, 6079.08), 
     EnemySpawn = CFrame.new(-9546, 172, 6079)},
     
    {Lvl = {2275, 2299}, Quest = "HauntedQuest2", QuestLvl = 1, Enemy = "Peanut Scout", 
     QuestPos = CFrame.new(-2104.39, 38.10, -10192.54), 
     EnemySpawn = CFrame.new(-2104, 38, -10192)},
     
    {Lvl = {2300, 2324}, Quest = "NutsIslandQuest", QuestLvl = 1, Enemy = "Peanut President", 
     QuestPos = CFrame.new(-2150.41, 38.32, -10520.01), 
     EnemySpawn = CFrame.new(-2150, 38, -10520)},
     
    {Lvl = {2325, 2349}, Quest = "NutsIslandQuest", QuestLvl = 2, Enemy = "Captain Elephant", 
     QuestPos = CFrame.new(-2188.78, 38.10, -9942.58), 
     EnemySpawn = CFrame.new(-2188, 38, -9942)},
     
    {Lvl = {2350, 2374}, Quest = "IceCreamIslandQuest", QuestLvl = 1, Enemy = "Ice Cream Chef", 
     QuestPos = CFrame.new(-641.63, 125.95, -11062.80), 
     EnemySpawn = CFrame.new(-820, 126, -10965)},
     
    {Lvl = {2375, 2399}, Quest = "IceCreamIslandQuest", QuestLvl = 2, Enemy = "Ice Cream Commander", 
     QuestPos = CFrame.new(-558.07, 125.95, -10965.98), 
     EnemySpawn = CFrame.new(-558, 126, -10965)},
     
    {Lvl = {2400, 2424}, Quest = "CakeQuest1", QuestLvl = 1, Enemy = "Cookie Crafter", 
     QuestPos = CFrame.new(-2374.47, 37.80, -12142.31), 
     EnemySpawn = CFrame.new(-2374, 38, -12142)},
     
    {Lvl = {2425, 2449}, Quest = "CakeQuest2", QuestLvl = 1, Enemy = "Cake Guard", 
     QuestPos = CFrame.new(-1928.82, 37.80, -12030.12), 
     EnemySpawn = CFrame.new(-1928, 38, -12030)},
     
    {Lvl = {2450, 2474}, Quest = "CakeQuest2", QuestLvl = 2, Enemy = "Baking Staff", 
     QuestPos = CFrame.new(-1927.37, 37.80, -12983.11), 
     EnemySpawn = CFrame.new(-1927, 38, -12983)},
     
    {Lvl = {2475, 2524}, Quest = "CakeQuest2", QuestLvl = 3, Enemy = "Head Baker", 
     QuestPos = CFrame.new(-2251.51, 52.25, -12373.53), 
     EnemySpawn = CFrame.new(-2251, 52, -12373)},
     
    {Lvl = {2525, 2550}, Quest = "ChocQuest1", QuestLvl = 1, Enemy = "Chocolate Bar Battler", 
     QuestPos = CFrame.new(620.63, 78.94, -12581.37), 
     EnemySpawn = CFrame.new(620, 78, -12581)}
}

-- =============================================
-- SMART NAVIGATION SYSTEM
-- =============================================

local LastPosition = nil
local StuckTimer = 0
local CurrentTween = nil

-- Check if in water
local function IsInWater()
    if not RootPart then return false end
    
    local RayParams = RaycastParams.new()
    RayParams.FilterType = Enum.RaycastFilterType.Whitelist
    RayParams.FilterDescendantsInstances = {workspace.Water or workspace:FindFirstChild("Water")}
    
    local result = workspace:Raycast(RootPart.Position, Vector3.new(0, -10, 0), RayParams)
    
    return result ~= nil
end

-- Check if stuck
local function IsStuck()
    if not RootPart or not getgenv().Config.AntiStuck then return false end
    
    if LastPosition then
        local distance = (RootPart.Position - LastPosition).Magnitude
        
        if distance < 2 then
            StuckTimer = StuckTimer + 1
            
            if StuckTimer >= (getgenv().Config.StuckTimeout * 10) then
                return true
            end
        else
            StuckTimer = 0
        end
    end
    
    LastPosition = RootPart.Position
    return false
end

-- Unstuck Player
local function UnstuckPlayer()
    if not RootPart then return end
    
    print("🔧 Anti-Stuck: Freeing player...")
    
    -- إيقاف الـ Tween الحالي
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
    
    -- رفع اللاعب للأعلى
    RootPart.CFrame = RootPart.CFrame + Vector3.new(0, getgenv().Config.SafeHeight, 0)
    task.wait(0.5)
    
    -- Reset Stuck Timer
    StuckTimer = 0
    LastPosition = RootPart.Position
    
    Fluent:Notify({
        Title = "Anti-Stuck",
        Content = "Position corrected!",
        Duration = 2
    })
end

-- Escape Water
local function EscapeWater()
    if not RootPart then return end
    
    print("💧 Anti-Water: Escaping water...")
    
    -- الطيران للأعلى
    RootPart.CFrame = RootPart.CFrame + Vector3.new(0, getgenv().Config.SafeHeight, 0)
    task.wait(0.3)
    
    Fluent:Notify({
        Title = "Anti-Water",
        Content = "Escaped from water!",
        Duration = 2
    })
end

-- Smart Tween (مع تجنب العوائق)
local function SmartTween(targetCFrame)
    if not Character or not RootPart then return end
    
    local Distance = (targetCFrame.Position - RootPart.Position).Magnitude
    
    -- إذا كان قريب، انتقال فوري
    if Distance < 250 then
        if getgenv().Config.UseBypass then
            -- Bypass الجدران
            RootPart.CFrame = targetCFrame
        else
            -- استخدام Pathfinding
            local path = PathfindingService:CreatePath({
                AgentRadius = 2,
                AgentHeight = 5,
                AgentCanJump = true,
                Costs = {
                    Water = math.huge
                }
            })
            
            path:ComputeAsync(RootPart.Position, targetCFrame.Position)
            
            if path.Status == Enum.PathStatus.Success then
                for _, waypoint in pairs(path:GetWaypoints()) do
                    if not getgenv().Config.AutoFarm then break end
                    RootPart.CFrame = CFrame.new(waypoint.Position)
                    task.wait(0.1)
                end
            else
                RootPart.CFrame = targetCFrame
            end
        end
        return
    end
    
    -- رفع الـ Y لتجنب الماء والجدران
    local SafeTarget = CFrame.new(
        targetCFrame.X,
        targetCFrame.Y + getgenv().Config.SafeHeight,
        targetCFrame.Z
    )
    
    local TweenInfo = TweenInfo.new(
        Distance / getgenv().Config.TweenSpeed,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    CurrentTween = TweenService:Create(RootPart, TweenInfo, {CFrame = SafeTarget})
    CurrentTween:Play()
    
    -- مراقبة أثناء الحركة
    local checkConnection
    checkConnection = RunService.Heartbeat:Connect(function()
        if not getgenv().Config.AutoFarm then
            if CurrentTween then CurrentTween:Cancel() end
            checkConnection:Disconnect()
            return
        end
        
        -- فحص الماء
        if getgenv().Config.AntiWater and IsInWater() then
            if CurrentTween then CurrentTween:Cancel() end
            EscapeWater()
            checkConnection:Disconnect()
            return
        end
        
        -- فحص العالق
        if IsStuck() then
            if CurrentTween then CurrentTween:Cancel() end
            UnstuckPlayer()
            checkConnection:Disconnect()
            return
        end
    end)
    
    CurrentTween.Completed:Wait()
    checkConnection:Disconnect()
    
    -- النزول للموقع الصحيح
    task.wait(0.2)
    RootPart.CFrame = targetCFrame
end

-- =============================================
-- CORE FUNCTIONS
-- =============================================

function GetQuestData()
    local Level = Player.Data.Level.Value
    
    for _, quest in pairs(QuestList) do
        if Level >= quest.Lvl[1] and Level <= quest.Lvl[2] then
            return quest
        end
    end
    
    return QuestList[1]
end

function EquipWeapon(weaponName)
    pcall(function()
        local Tool = Player.Backpack:FindFirstChild(weaponName) or Character:FindFirstChild(weaponName)
        if Tool and not Character:FindFirstChild(weaponName) then
            Humanoid:EquipTool(Tool)
        end
    end)
end

local AttackLoop
function StartFastAttack()
    if AttackLoop then return end
    
    AttackLoop = RunService.Heartbeat:Connect(function()
        if getgenv().Config.FastAttack and getgenv().Config.AutoFarm then
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(getgenv().Config.AttackDelay)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end
    end)
end

function StopFastAttack()
    if AttackLoop then
        AttackLoop:Disconnect()
        AttackLoop = nil
    end
end

function EnableHaki()
    if getgenv().Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

function CheckQuest(enemyName)
    local QuestGui = Player.PlayerGui:FindFirstChild("Main")
    if QuestGui and QuestGui:FindFirstChild("Quest") then
        local Title = QuestGui.Quest.Container.QuestTitle.Title.Text
        return string.find(Title, enemyName)
    end
    return false
end

function TakeQuest(questData)
    if not getgenv().Config.UseQuest then return end
    
    if not CheckQuest(questData.Enemy) then
        SmartTween(questData.QuestPos)
        task.wait(0.5)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData.Quest, questData.QuestLvl)
        task.wait(0.5)
    end
end

function BringMob(mob)
    if not getgenv().Config.BringMobs or not mob then return end
    
    pcall(function()
        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            mob.HumanoidRootPart.CanCollide = false
            mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
            mob.HumanoidRootPart.Transparency = 1
            
            if RootPart then
                mob.HumanoidRootPart.CFrame = RootPart.CFrame * CFrame.new(0, 0, -getgenv().Config.DistanceFromMob)
            end
            
            -- Disable mob movement
            if mob.Humanoid then
                mob.Humanoid.WalkSpeed = 0
                mob.Humanoid.JumpPower = 0
            end
            
            -- تعطيل Physics
            sethiddenproperty(Player, "SimulationRadius", math.huge)
        end
    end)
end

-- =============================================
-- MAIN FARM LOOP
-- =============================================
local FarmLoop
function StartFarm()
    if FarmLoop then return end
    
    FarmLoop = RunService.Heartbeat:Connect(function()
        if not getgenv().Config.AutoFarm then
            StopFastAttack()
            return
        end
        
        pcall(function()
            local Quest = GetQuestData()
            
            -- فحص الماء
            if getgenv().Config.AntiWater and IsInWater() then
                EscapeWater()
                return
            end
            
            -- فحص العالق
            if IsStuck() then
                UnstuckPlayer()
                return
            end
            
            -- Take Quest
            TakeQuest(Quest)
            
            -- Find Enemy
            local Enemy = nil
            for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                if mob.Name == Quest.Enemy and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    Enemy = mob
                    break
                end
            end
            
            if Enemy and Enemy:FindFirstChild("HumanoidRootPart") then
                -- Enable Haki
                EnableHaki()
                
                -- Equip Weapon
                EquipWeapon(getgenv().Config.SelectedWeapon)
                
                -- Start Attack
                StartFastAttack()
                
                -- Move to Enemy
                if RootPart then
                    local targetPos = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().Config.DistanceFromMob, 0)
                    
                    -- حركة آمنة
                    if getgenv().Config.UseBypass then
                        RootPart.CFrame = targetPos
                    else
                        SmartTween(targetPos)
                    end
                    
                    -- Face Enemy
                    Humanoid.AutoRotate = false
                    RootPart.CFrame = CFrame.new(RootPart.Position, Enemy.HumanoidRootPart.Position)
                end
                
                -- Bring Mob
                BringMob(Enemy)
            else
                -- No enemy, go to spawn
                StopFastAttack()
                if Quest.EnemySpawn then
                    SmartTween(Quest.EnemySpawn)
                else
                    SmartTween(Quest.QuestPos)
                end
            end
        end)
    end)
end

function StopFarm()
    if FarmLoop then
        FarmLoop:Disconnect()
        FarmLoop = nil
    end
    
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
    
    StopFastAttack()
    
    if Humanoid then
        Humanoid.AutoRotate = true
    end
    
    StuckTimer = 0
    LastPosition = nil
end

-- =============================================
-- UI SETUP
-- =============================================

Tabs.Main:AddParagraph({
    Title = "Player Info",
    Content = "Level: " .. Player.Data.Level.Value .. " / 2550"
})

local WeaponDropdown = Tabs.Main:AddDropdown("Weapon", {
    Title = "Select Weapon",
    Values = {"Combat", "Melee", "Sword", "Gun", "Blox Fruit"},
    Multi = false,
    Default = 1
})

WeaponDropdown:OnChanged(function(v)
    getgenv().Config.SelectedWeapon = v
end)

local FarmToggle = Tabs.Main:AddToggle("Farm", {
    Title = "Auto Farm Level",
    Description = "Smart navigation with anti-stuck",
    Default = false
})

FarmToggle:OnChanged(function(v)
    getgenv().Config.AutoFarm = v
    
    if v then
        StartFarm()
        Fluent:Notify({
            Title = "Vortex Hub",
            Content = "Smart Farm Started!",
            Duration = 3
        })
    else
        StopFarm()
        Fluent:Notify({
            Title = "Vortex Hub",
            Content = "Farm Stopped",
            Duration = 3
        })
    end
end)

-- Settings Tab
Tabs.Settings:AddSection("Farm Settings")

Tabs.Settings:AddToggle("BringMobs", {
    Title = "Bring Mobs",
    Default = true
}):OnChanged(function(v)
    getgenv().Config.BringMobs = v
end)

Tabs.Settings:AddToggle("AutoHaki", {
    Title = "Auto Haki",
    Default = true
}):OnChanged(function(v)
    getgenv().Config.AutoHaki = v
end)

Tabs.Settings:AddToggle("UseQuest", {
    Title = "Use Quests",
    Default = true
}):OnChanged(function(v)
    getgenv().Config.UseQuest = v
end)

Tabs.Settings:AddSection("Safety Settings")

Tabs.Settings:AddToggle("AntiStuck", {
    Title = "Anti-Stuck System",
    Description = "Automatically free from walls",
    Default = true
}):OnChanged(function(v)
    getgenv().Config.AntiStuck = v
end)

Tabs.Settings:AddToggle("AntiWater", {
    Title = "Anti-Water Death",
    Description = "Prevent drowning",
    Default = true
}):OnChanged(function(v)
    getgenv().Config.AntiWater = v
end)

Tabs.Settings:AddToggle("UseBypass", {
    Title = "Wall Bypass",
    Description = "Teleport through walls",
    Default = true
}):OnChanged(function(v)
    getgenv().Config.UseBypass = v
end)

Tabs.Settings:AddSlider("SafeHeight", {
    Title = "Safe Flying Height",
    Description = "Height above obstacles",
    Default = 50,
    Min = 30,
    Max = 100,
    Rounding = 0
}):OnChanged(function(v)
    getgenv().Config.SafeHeight = v
end)

Tabs.Settings:AddSlider("StuckTimeout", {
    Title = "Stuck Detection Time",
    Description = "Seconds before unstuck",
    Default = 3,
    Min = 1,
    Max = 10,
    Rounding = 0
}):OnChanged(function(v)
    getgenv().Config.StuckTimeout = v
end)

Tabs.Settings:AddSection("Movement Settings")

Tabs.Settings:AddSlider("Distance", {
    Title = "Distance from Enemy",
    Default = 25,
    Min = 15,
    Max = 50,
    Rounding = 0
}):OnChanged(function(v)
    getgenv().Config.DistanceFromMob = v
end)

Tabs.Settings:AddSlider("Speed", {
    Title = "Movement Speed",
    Default = 350,
    Min = 250,
    Max = 500,
    Rounding = 0
}):OnChanged(function(v)
    getgenv().Config.TweenSpeed = v
end)

Tabs.Settings:AddSlider("AttackDelay", {
    Title = "Attack Delay",
    Default = 0.1,
    Min = 0.05,
    Max = 0.3,
    Rounding = 2
}):OnChanged(function(v)
    getgenv().Config.AttackDelay = v
end)

-- Stats Tab
local Stats = {
    Melee = false,
    Defense = false,
    Sword = false,
    Gun = false,
    Fruit = false
}

Tabs.Stats:AddToggle("Melee", {Title = "Auto Melee"}):OnChanged(function(v) Stats.Melee = v end)
Tabs.Stats:AddToggle("Defense", {Title = "Auto Defense"}):OnChanged(function(v) Stats.Defense = v end)
Tabs.Stats:AddToggle("Sword", {Title = "Auto Sword"}):OnChanged(function(v) Stats.Sword = v end)
Tabs.Stats:AddToggle("Gun", {Title = "Auto Gun"}):OnChanged(function(v) Stats.Gun = v end)
Tabs.Stats:AddToggle("Fruit", {Title = "Auto Devil Fruit"}):OnChanged(function(v) Stats.Fruit = v end)

spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if Stats.Melee then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1) end
            if Stats.Defense then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1) end
            if Stats.Sword then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1) end
            if Stats.Gun then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1) end
            if Stats.Fruit then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1) end
        end)
    end
end)

-- Misc Tab
Tabs.Misc:AddButton({
    Title = "Reset Anti-Stuck",
    Description = "Manually reset stuck detection",
    Callback = function()
        StuckTimer = 0
        LastPosition = nil
        Fluent:Notify({
            Title = "System",
            Content = "Anti-Stuck reset!",
            Duration = 2
        })
    end
})

Tabs.Misc:AddButton({
    Title = "FPS Boost",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("Union") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Beam") then
                v.Enabled = false
            end
        end
        
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        
        Fluent:Notify({
            Title = "System",
            Content = "FPS Boost Applied!",
            Duration = 3
        })
    end
})

Tabs.Misc:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Vortex Hub V4 Ultimate",
    Content = "Loaded | Level: " .. Player.Data.Level.Value,
    Duration = 5
})

print("✅ Vortex Hub V4 | Smart Navigation Loaded")
print("📌 Anti-Stuck: ✓ | Anti-Water: ✓ | Wall Bypass: ✓")
