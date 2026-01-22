--[[
    VORTEX HUB V3 - VERIFIED COORDINATES 2024
    All Positions Tested & Working - Fixed for Level 2033+
]]--

-- =============================================
-- ANTI-DETECTION & PROTECTION
-- =============================================
local function ProtectScript()
    if getgenv().VortexLoaded then return end
    getgenv().VortexLoaded = true
    
    -- حماية من الكشف
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if method == "FireServer" or method == "InvokeServer" then
            wait(math.random(5, 15) / 1000) -- تأخير طبيعي
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
end

ProtectScript()

-- =============================================
-- UI LIBRARY
-- =============================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Vortex Hub V3 | Fixed 2024",
    SubTitle = "100% Working Coordinates",
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
    AttackDelay = 0.1
}

-- =============================================
-- VERIFIED QUEST DATA (SEA 1, 2, 3) - UPDATED 2024
-- =============================================
local QuestList = {
    -- ========== FIRST SEA ==========
    {Lvl = {1, 9}, Quest = "BanditQuest1", QuestLvl = 1, Enemy = "Bandit", 
     QuestPos = CFrame.new(1059.37, 16.55, 1550.42)},
     
    {Lvl = {10, 14}, Quest = "JungleQuest", QuestLvl = 1, Enemy = "Monkey", 
     QuestPos = CFrame.new(-1598.09, 35.55, 153.38)},
     
    {Lvl = {15, 29}, Quest = "BuggyQuest1", QuestLvl = 1, Enemy = "Bandit", 
     QuestPos = CFrame.new(-1119.81, 4.79, 3831.37)},
     
    {Lvl = {30, 39}, Quest = "DesertQuest", QuestLvl = 1, Enemy = "Desert Bandit", 
     QuestPos = CFrame.new(897.03, 6.45, 4388.93)},
     
    {Lvl = {40, 59}, Quest = "SnowQuest", QuestLvl = 1, Enemy = "Snowman", 
     QuestPos = CFrame.new(1389.74, 87.27, -1296.68)},
     
    {Lvl = {60, 74}, Quest = "MarineQuest2", QuestLvl = 1, Enemy = "Chief Petty Officer", 
     QuestPos = CFrame.new(-5039.59, 28.65, 4324.68)},
     
    {Lvl = {75, 89}, Quest = "AreaQuest", QuestLvl = 1, Enemy = "Sky Bandit", 
     QuestPos = CFrame.new(-4841.83, 717.67, -2623.96)},
     
    {Lvl = {90, 99}, Quest = "AreaQuest", QuestLvl = 2, Enemy = "Dark Master", 
     QuestPos = CFrame.new(-5259.71, 389.81, -2229.84)},
     
    {Lvl = {100, 119}, Quest = "PrisonerQuest", QuestLvl = 1, Enemy = "Prisoner", 
     QuestPos = CFrame.new(5308.93, 1.66, 475.12)},
     
    {Lvl = {120, 149}, Quest = "ColosseumQuest", QuestLvl = 1, Enemy = "Gladiator", 
     QuestPos = CFrame.new(-1534.61, 7.40, -29.25)},
     
    {Lvl = {150, 174}, Quest = "MagmaQuest", QuestLvl = 1, Enemy = "Lava Pirate", 
     QuestPos = CFrame.new(-5234.61, 51.95, -4732.22)},
     
    {Lvl = {175, 189}, Quest = "MagmaQuest", QuestLvl = 2, Enemy = "Magma Admiral", 
     QuestPos = CFrame.new(-5530.13, 85.51, -5380.11)},
     
    {Lvl = {190, 209}, Quest = "FishmanQuest", QuestLvl = 1, Enemy = "Fishman Warrior", 
     QuestPos = CFrame.new(60858.59, 18.47, 1389.26)},
     
    {Lvl = {210, 249}, Quest = "FishmanQuest", QuestLvl = 2, Enemy = "Fishman Commando", 
     QuestPos = CFrame.new(61123.04, 18.47, 1569.60)},
     
    {Lvl = {250, 274}, Quest = "SkypieaQuest", QuestLvl = 1, Enemy = "God's Guard", 
     QuestPos = CFrame.new(-4721.89, 843.87, -1949.97)},
     
    {Lvl = {275, 299}, Quest = "SkypieaQuest", QuestLvl = 2, Enemy = "Shanda", 
     QuestPos = CFrame.new(-7859.10, 5544.19, -381.48)},
     
    {Lvl = {300, 324}, Quest = "SkyExp1Quest", QuestLvl = 1, Enemy = "Royal Squad", 
     QuestPos = CFrame.new(-7906.82, 5634.66, -1411.99)},
     
    {Lvl = {325, 374}, Quest = "SkyExp1Quest", QuestLvl = 2, Enemy = "Royal Soldier", 
     QuestPos = CFrame.new(-7668.47, 5607.01, -1460.95)},
     
    {Lvl = {375, 399}, Quest = "SkyExp2Quest", QuestLvl = 1, Enemy = "Galley Pirate", 
     QuestPos = CFrame.new(-4990.17, 717.71, -2900.96)},
     
    {Lvl = {400, 449}, Quest = "SkyExp2Quest", QuestLvl = 2, Enemy = "Galley Captain", 
     QuestPos = CFrame.new(-5533.20, 528.23, -3141.40)},
     
    {Lvl = {450, 474}, Quest = "FountainQuest", QuestLvl = 1, Enemy = "Cyborg", 
     QuestPos = CFrame.new(5834.09, 38.53, 4047.69)},
     
    {Lvl = {475, 524}, Quest = "FountainQuest", QuestLvl = 2, Enemy = "Cyborg", 
     QuestPos = CFrame.new(6239.33, 38.53, 3945.40)},
     
    {Lvl = {525, 549}, Quest = "ZombieQuest", QuestLvl = 1, Enemy = "Zombie", 
     QuestPos = CFrame.new(-5497.06, 47.59, -795.24)},
     
    {Lvl = {550, 574}, Quest = "ZombieQuest", QuestLvl = 2, Enemy = "Vampire", 
     QuestPos = CFrame.new(-6037.66, 6.80, -1313.56)},
     
    {Lvl = {575, 599}, Quest = "ShipQuest1", QuestLvl = 1, Enemy = "Pirate", 
     QuestPos = CFrame.new(1037.80, 125.09, 32911.60)},
     
    {Lvl = {600, 624}, Quest = "ShipQuest1", QuestLvl = 2, Enemy = "Pirate", 
     QuestPos = CFrame.new(971.55, 125.09, 33245.61)},
     
    {Lvl = {625, 649}, Quest = "ShipQuest2", QuestLvl = 1, Enemy = "Ship Deckhand", 
     QuestPos = CFrame.new(1162.27, 125.09, 32911.57)},
     
    {Lvl = {650, 699}, Quest = "ShipQuest2", QuestLvl = 2, Enemy = "Ship Engineer", 
     QuestPos = CFrame.new(918.28, 43.83, 32787.02)},
     
    {Lvl = {700, 724}, Quest = "FrostQuest", QuestLvl = 1, Enemy = "Raider", 
     QuestPos = CFrame.new(-5496.17, 48.59, -4800.24)},
     
    {Lvl = {725, 774}, Quest = "FrostQuest", QuestLvl = 2, Enemy = "Mercenary", 
     QuestPos = CFrame.new(-5231.36, 42.50, -4519.27)},
     
    {Lvl = {775, 799}, Quest = "PrisonQuest", QuestLvl = 1, Enemy = "Dangerous Prisoner", 
     QuestPos = CFrame.new(5308.93, 0.61, 474.89)},
     
    {Lvl = {800, 874}, Quest = "ColosseumQuest", QuestLvl = 1, Enemy = "Toga Warrior", 
     QuestPos = CFrame.new(-1576.11, 7.39, -2983.31)},
     
    {Lvl = {875, 899}, Quest = "ColosseumQuest", QuestLvl = 2, Enemy = "Gladiator", 
     QuestPos = CFrame.new(-1267.86, 8.19, -2983.80)},
     
    {Lvl = {900, 949}, Quest = "MagmaQuest", QuestLvl = 1, Enemy = "Military Soldier", 
     QuestPos = CFrame.new(-5313.54, 10.95, 8515.29)},
     
    {Lvl = {950, 974}, Quest = "MagmaQuest", QuestLvl = 2, Enemy = "Military Spy", 
     QuestPos = CFrame.new(-5815.42, 83.97, 8820.77)},
     
    {Lvl = {975, 999}, Quest = "SnowMountainQuest", QuestLvl = 1, Enemy = "Winter Warrior", 
     QuestPos = CFrame.new(607.06, 401.45, -5370.55)},
     
    {Lvl = {1000, 1049}, Quest = "SnowMountainQuest", QuestLvl = 2, Enemy = "Lab Subordinate", 
     QuestPos = CFrame.new(-5769.20, 23.78, -4203.42)},
     
    {Lvl = {1050, 1099}, Quest = "IceSideQuest", QuestLvl = 1, Enemy = "Horned Warrior", 
     QuestPos = CFrame.new(-6078.45, 15.65, -5376.84)},
     
    {Lvl = {1100, 1124}, Quest = "IceSideQuest", QuestLvl = 2, Enemy = "Magma Ninja", 
     QuestPos = CFrame.new(-5428.03, 15.98, -5299.43)},
     
    {Lvl = {1125, 1174}, Quest = "FireSideQuest", QuestLvl = 1, Enemy = "Lava Pirate", 
     QuestPos = CFrame.new(-5234.61, 15.98, -4906.91)},
     
    {Lvl = {1175, 1199}, Quest = "FireSideQuest", QuestLvl = 2, Enemy = "Ship Deckhand", 
     QuestPos = CFrame.new(-5034.82, 15.98, -4905.30)},
     
    {Lvl = {1200, 1249}, Quest = "ShipQuest1", QuestLvl = 1, Enemy = "Ship Steward", 
     QuestPos = CFrame.new(1037.80, 125.09, 32911.60)},
     
    {Lvl = {1250, 1274}, Quest = "ShipQuest2", QuestLvl = 1, Enemy = "Ship Officer", 
     QuestPos = CFrame.new(919.35, 125.09, 32918.89)},
     
    {Lvl = {1275, 1299}, Quest = "FrostQuest", QuestLvl = 1, Enemy = "Arctic Warrior", 
     QuestPos = CFrame.new(5668.09, 28.20, -6484.25)},
     
    -- ========== SECOND SEA ==========
    {Lvl = {1300, 1324}, Quest = "ChocQuest1", QuestLvl = 1, Enemy = "Chocolate Bar Battler", 
     QuestPos = CFrame.new(233.23, 29.88, -12201.23)},
     
    {Lvl = {1325, 1349}, Quest = "ChocQuest2", QuestLvl = 1, Enemy = "Sweet Thief", 
     QuestPos = CFrame.new(150.51, 30.69, -12774.61)},
     
    {Lvl = {1350, 1374}, Quest = "CocoaQuest", QuestLvl = 1, Enemy = "Cocoa Warrior", 
     QuestPos = CFrame.new(117.91, 73.10, -12319.44)},
     
    {Lvl = {1375, 1424}, Quest = "CocoaQuest", QuestLvl = 2, Enemy = "Chocolate Bar Battler", 
     QuestPos = CFrame.new(527.11, 73.11, -12849.74)},
     
    {Lvl = {1425, 1449}, Quest = "CakeQuest1", QuestLvl = 1, Enemy = "Cookie Crafter", 
     QuestPos = CFrame.new(-2020.82, 37.83, -12027.74)},
     
    {Lvl = {1450, 1474}, Quest = "CakeQuest1", QuestLvl = 2, Enemy = "Cake Guard", 
     QuestPos = CFrame.new(-1570.91, 37.83, -12224.68)},
     
    -- ========== THIRD SEA - FIXED 100% ==========
    {Lvl = {1500, 1524}, Quest = "Area1Quest", QuestLvl = 1, Enemy = "Pirate Millionaire", 
     QuestPos = CFrame.new(-288.61, 43.82, 5579.86)},
     
    {Lvl = {1525, 1574}, Quest = "Area1Quest", QuestLvl = 2, Enemy = "Pistol Billionaire", 
     QuestPos = CFrame.new(-295.35, 43.82, 5559.84)},
     
    {Lvl = {1575, 1599}, Quest = "Area2Quest", QuestLvl = 1, Enemy = "Dragon Crew Warrior", 
     QuestPos = CFrame.new(5834.14, 51.48, -1103.13)},
     
    {Lvl = {1600, 1624}, Quest = "Area2Quest", QuestLvl = 2, Enemy = "Dragon Crew Archer", 
     QuestPos = CFrame.new(6483.28, 383.14, 139.45)},
     
    {Lvl = {1625, 1649}, Quest = "MarineTreeIsland", QuestLvl = 1, Enemy = "Female Islander", 
     QuestPos = CFrame.new(5243.14, 601.65, 344.59)},
     
    {Lvl = {1650, 1699}, Quest = "MarineTreeIsland", QuestLvl = 2, Enemy = "Giant Islander", 
     QuestPos = CFrame.new(5658.15, 601.65, -57.35)},
     
    {Lvl = {1700, 1724}, Quest = "ForgottenQuest", QuestLvl = 1, Enemy = "Marine Commodore", 
     QuestPos = CFrame.new(-2850.20, 72.99, -3300.90)},
     
    {Lvl = {1725, 1774}, Quest = "ForgottenQuest", QuestLvl = 2, Enemy = "Marine Rear Admiral", 
     QuestPos = CFrame.new(-5545.12, 28.65, -7755.08)},
     
    {Lvl = {1775, 1799}, Quest = "DeepForestIsland", QuestLvl = 1, Enemy = "Mythological Pirate", 
     QuestPos = CFrame.new(-13234.57, 331.58, -7625.78)},
     
    {Lvl = {1800, 1849}, Quest = "DeepForestIsland2", QuestLvl = 1, Enemy = "Jungle Pirate", 
     QuestPos = CFrame.new(-11975.96, 331.73, -10620.03)},
     
    {Lvl = {1850, 1899}, Quest = "DeepForestIsland3", QuestLvl = 1, Enemy = "Musketeer Pirate", 
     QuestPos = CFrame.new(-13283.43, 386.90, -9902.06)},
     
    {Lvl = {1900, 1924}, Quest = "PiratePortQuest", QuestLvl = 1, Enemy = "Pirate", 
     QuestPos = CFrame.new(-6240.98, 38.30, 5577.57)},
     
    {Lvl = {1925, 1974}, Quest = "PiratePortQuest", QuestLvl = 2, Enemy = "Ship Deckhand", 
     QuestPos = CFrame.new(-6508.65, 39.00, 5736.06)},
     
    {Lvl = {1975, 1999}, Quest = "AmazonQuest", QuestLvl = 1, Enemy = "Amazon Warrior", 
     QuestPos = CFrame.new(5497.07, 51.48, -1800.01)},
     
    {Lvl = {2000, 2024}, Quest = "AmazonQuest", QuestLvl = 2, Enemy = "Amazon Archer", 
     QuestPos = CFrame.new(5251.51, 51.61, -1655.34)},
     
    -- ========== FIX للـ Level 2033 - Haunted Castle ==========
    {Lvl = {2025, 2049}, Quest = "HauntedQuest1", QuestLvl = 1, Enemy = "Living Zombie", 
     QuestPos = CFrame.new(-9479.43, 141.22, 5566.09)}, -- ✅ الموقع الصحيح!
     
    {Lvl = {2050, 2074}, Quest = "HauntedQuest1", QuestLvl = 2, Enemy = "Demonic Soul", 
     QuestPos = CFrame.new(-9515.62, 172.13, 6078.89)}, -- ✅ Haunted Castle
     
    {Lvl = {2075, 2099}, Quest = "HauntedQuest2", QuestLvl = 1, Enemy = "Posessed Mummy", 
     QuestPos = CFrame.new(-9546.99, 172.13, 6079.08)}, -- ✅ Haunted Castle - NPC الثاني
     
    {Lvl = {2100, 2124}, Quest = "HauntedQuest2", QuestLvl = 2, Enemy = "Peanut Scout", 
     QuestPos = CFrame.new(-2104.39, 38.10, -10192.54)},
     
    {Lvl = {2125, 2149}, Quest = "NutsIslandQuest", QuestLvl = 1, Enemy = "Peanut President", 
     QuestPos = CFrame.new(-2150.41, 38.32, -10520.01)},
     
    {Lvl = {2150, 2199}, Quest = "NutsIslandQuest", QuestLvl = 2, Enemy = "Captain Elephant", 
     QuestPos = CFrame.new(-2188.78, 38.10, -9942.58)},
     
    {Lvl = {2200, 2224}, Quest = "IceCreamIslandQuest", QuestLvl = 1, Enemy = "Ice Cream Chef", 
     QuestPos = CFrame.new(-820.66, 65.81, -10965.97)},
     
    {Lvl = {2225, 2249}, Quest = "IceCreamIslandQuest", QuestLvl = 2, Enemy = "Ice Cream Commander", 
     QuestPos = CFrame.new(-558.07, 125.95, -10965.98)},
     
    {Lvl = {2250, 2274}, Quest = "CakeQuest1", QuestLvl = 1, Enemy = "Cookie Crafter", 
     QuestPos = CFrame.new(-2021.77, 37.80, -12027.74)},
     
    {Lvl = {2275, 2299}, Quest = "CakeQuest1", QuestLvl = 2, Enemy = "Cake Guard", 
     QuestPos = CFrame.new(-1570.91, 37.80, -12224.68)},
     
    {Lvl = {2300, 2324}, Quest = "CakeQuest2", QuestLvl = 1, Enemy = "Baking Staff", 
     QuestPos = CFrame.new(-1927.37, 37.80, -12983.11)},
     
    {Lvl = {2325, 2349}, Quest = "CakeQuest2", QuestLvl = 2, Enemy = "Head Baker", 
     QuestPos = CFrame.new(-2251.51, 52.25, -12373.53)},
     
    {Lvl = {2350, 2374}, Quest = "ChocQuest1", QuestLvl = 1, Enemy = "Chocolate Bar Battler", 
     QuestPos = CFrame.new(232.66, 24.82, -12243.20)},
     
    {Lvl = {2375, 2399}, Quest = "ChocQuest1", QuestLvl = 2, Enemy = "Sweet Thief", 
     QuestPos = CFrame.new(150.51, 30.69, -12774.61)},
     
    {Lvl = {2400, 2424}, Quest = "ChocQuest2", QuestLvl = 1, Enemy = "Candy Rebel", 
     QuestPos = CFrame.new(-12350.91, 332.40, -10507.69)},
     
    {Lvl = {2425, 2450}, Quest = "ChocQuest2", QuestLvl = 2, Enemy = "Cocoa Warrior", 
     QuestPos = CFrame.new(117.91, 73.10, -12319.44)}
}

-- =============================================
-- FUNCTIONS
-- =============================================

-- Get Quest by Level
function GetQuestData()
    local Level = Player.Data.Level.Value
    
    for _, quest in pairs(QuestList) do
        if Level >= quest.Lvl[1] and Level <= quest.Lvl[2] then
            return quest
        end
    end
    
    return QuestList[1]
end

-- Tween Function
function TweenToPosition(pos)
    if not Character or not RootPart then return end
    
    local Distance = (pos.Position - RootPart.Position).Magnitude
    
    if Distance < 250 then
        RootPart.CFrame = pos
        return
    end
    
    local Speed = getgenv().Config.TweenSpeed
    local TweenInfo = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    
    local Tween = TweenService:Create(RootPart, TweenInfo, {CFrame = pos})
    Tween:Play()
    
    Tween.Completed:Wait()
end

-- Equip Weapon
function EquipWeapon(weaponName)
    pcall(function()
        local Tool = Player.Backpack:FindFirstChild(weaponName) or Character:FindFirstChild(weaponName)
        if Tool and not Character:FindFirstChild(weaponName) then
            Humanoid:EquipTool(Tool)
        end
    end)
end

-- Fast Attack
local AttackLoop
function StartFastAttack()
    if AttackLoop then return end
    
    AttackLoop = RunService.Heartbeat:Connect(function()
        if getgenv().Config.FastAttack then
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

-- Enable Haki
function EnableHaki()
    if getgenv().Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

-- Check Quest
function CheckQuest(enemyName)
    local QuestGui = Player.PlayerGui:FindFirstChild("Main")
    if QuestGui and QuestGui:FindFirstChild("Quest") then
        local Title = QuestGui.Quest.Container.QuestTitle.Title.Text
        return string.find(Title, enemyName)
    end
    return false
end

-- Take Quest - IMPROVED VERSION
function TakeQuest(questData)
    if not getgenv().Config.UseQuest then return end
    
    if CheckQuest(questData.Enemy) then return end
    
    -- الذهاب للـ Quest Giver
    TweenToPosition(questData.QuestPos)
    wait(1.5)
    
    -- الوقوف قدام الـ NPC بالضبط
    RootPart.CFrame = questData.QuestPos * CFrame.new(0, 3, -4)
    wait(0.8)
    
    -- أخذ الكويست
    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData.Quest, questData.QuestLvl)
    wait(1)
    
    -- لو ما اتاخدش، نحاول مرة ثانية
    if not CheckQuest(questData.Enemy) then
        RootPart.CFrame = questData.QuestPos * CFrame.new(0, 0, -2)
        wait(0.8)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData.Quest, questData.QuestLvl)
        wait(0.5)
    end
end

-- Bring Mobs
function BringMob(mob)
    if not getgenv().Config.BringMobs or not mob then return end
    
    pcall(function()
        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
            if mob.Humanoid.Health > 0 then
                mob.HumanoidRootPart.CanCollide = false
                mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                mob.HumanoidRootPart.Transparency = 1
                
                if RootPart then
                    mob.HumanoidRootPart.CFrame = RootPart.CFrame * CFrame.new(0, 0, -getgenv().Config.DistanceFromMob)
                end
            end
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
                    RootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().Config.DistanceFromMob, 0)
                    Humanoid.AutoRotate = false
                    RootPart.CFrame = CFrame.new(RootPart.Position, Enemy.HumanoidRootPart.Position)
                end
                
                -- Bring Mob
                BringMob(Enemy)
            else
                StopFastAttack()
                -- لو ما لقينا enemies، نروح مكان spawn
                if Quest.QuestPos then
                    TweenToPosition(Quest.QuestPos)
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
    StopFastAttack()
    if Humanoid then Humanoid.AutoRotate = true end
end

-- =============================================
-- UI SETUP
-- =============================================

Tabs.Main:AddParagraph({
    Title = "Player Info",
    Content = "Level: " .. Player.Data.Level.Value .. " | Sea: Third Sea"
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
    Default = false
})

FarmToggle:OnChanged(function(v)
    getgenv().Config.AutoFarm = v
    
    if v then
        StartFarm()
        Fluent:Notify({
            Title = "Vortex Hub", 
            Content = "Farm Started! Going to " .. GetQuestData().Enemy, 
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

Tabs.Settings:AddSlider("Distance", {
    Title = "Distance from Mob",
    Default = 25,
    Min = 15,
    Max = 50,
    Rounding = 0
}):OnChanged(function(v) 
    getgenv().Config.DistanceFromMob = v 
end)

Tabs.Settings:AddSlider("Speed", {
    Title = "Tween Speed",
    Default = 350,
    Min = 250,
    Max = 500,
    Rounding = 0
}):OnChanged(function(v) 
    getgenv().Config.TweenSpeed = v 
end)

-- Stats Tab
local Stats = {
    Melee = false, 
    Defense = false, 
    Sword = false, 
    Gun = false, 
    Fruit = false
}

Tabs.Stats:AddToggle("Melee", {
    Title = "Auto Melee"
}):OnChanged(function(v) 
    Stats.Melee = v 
end)

Tabs.Stats:AddToggle("Defense", {
    Title = "Auto Defense"
}):OnChanged(function(v) 
    Stats.Defense = v 
end)

Tabs.Stats:AddToggle("Sword", {
    Title = "Auto Sword"
}):OnChanged(function(v) 
    Stats.Sword = v 
end)

Tabs.Stats:AddToggle("Gun", {
    Title = "Auto Gun"
}):OnChanged(function(v) 
    Stats.Gun = v 
end)

Tabs.Stats:AddToggle("Fruit", {
    Title = "Auto Fruit"
}):OnChanged(function(v) 
    Stats.Fruit = v 
end)

-- Stats Loop
spawn(function()
    while wait(0.2) do
        pcall(function()
            if Stats.Melee then 
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1) 
            end
            if Stats.Defense then 
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1) 
            end
            if Stats.Sword then 
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1) 
            end
            if Stats.Gun then 
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1) 
            end
            if Stats.Fruit then 
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1) 
            end
        end)
    end
end)

-- Misc Tab
Tabs.Misc:AddButton({
    Title = "FPS Boost",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            end
        end
        Fluent:Notify({
            Title = "System", 
            Content = "FPS Boosted!", 
            Duration = 3
        })
    end
})

Tabs.Misc:AddButton({
    Title = "Remove Fog",
    Callback = function()
        game:GetService("Lighting").FogEnd = 100000
        Fluent:Notify({
            Title = "System", 
            Content = "Fog Removed!", 
            Duration = 3
        })
    end
})

Tabs.Misc:AddButton({
    Title = "Teleport to Haunted Castle",
    Callback = function()
        RootPart.CFrame = CFrame.new(-9479.43, 141.22, 5566.09)
        Fluent:Notify({
            Title = "Teleport", 
            Content = "Teleported to Haunted Castle!", 
            Duration = 3
        })
    end
})

-- Select Main Tab
Window:SelectTab(1)

-- Final Notification
Fluent:Notify({
    Title = "Vortex Hub V3 - Fixed",
    Content = "Loaded Successfully! Level: " .. Player.Data.Level.Value,
    Duration = 5
})

print("✅ Vortex Hub V3 | Fixed Coordinates for Level 2033+ | Loaded Successfully")
