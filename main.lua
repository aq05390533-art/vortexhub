--[[
    VORTEX HUB V3 - PREMIUM
    Advanced Auto Farm System
    Anti-Detection + Stable Performance
]]--

-- =============================================
-- ANTI-DETECTION & PROTECTION
-- =============================================
local function ProtectScript()
    -- إخفاء السكريبت من الديتكشن
    if not getgenv().VortexLoaded then
        getgenv().VortexLoaded = true
    else
        return -- منع التحميل المزدوج
    end
    
    -- حماية من الباند
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if method == "FireServer" or method == "InvokeServer" then
            if tostring(self) == "RemoteEvent" or tostring(self) == "RemoteFunction" then
                -- تأخير عشوائي طبيعي
                wait(math.random(1, 3) / 100)
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
end

ProtectScript()

-- =============================================
-- UI LIBRARY (CLEAN & SIMPLE)
-- =============================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Vortex Hub V3 Premium",
    SubTitle = "Advanced Auto Farm",
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
    Info = Window:AddTab({ Title = "Info", Icon = "info" })
}

-- =============================================
-- CORE VARIABLES
-- =============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- تحديث الكاراكتر عند الموت
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

-- =============================================
-- SETTINGS
-- =============================================
local Config = {
    AutoFarm = false,
    SelectedWeapon = "Melee",
    FastAttackSpeed = 0.1,
    BringMobs = true,
    AutoHaki = true,
    SafeMode = true, -- وضع آمن ضد الباند
    DistanceFromMob = 20,
    TweenSpeed = 300,
    UseQuest = true
}

-- =============================================
-- QUEST DATABASE (COMPLETE)
-- =============================================
local QuestList = {
    -- Sea 1
    {Lvl = {1,9}, Quest = "BanditQuest1", QuestLvl = 1, Enemy = "Bandit", QuestPos = CFrame.new(1059.37, 16.5, 1550.4)},
    {Lvl = {10,14}, Quest = "JungleQuest", QuestLvl = 1, Enemy = "Monkey", QuestPos = CFrame.new(-1601.6, 36.9, 153.4)},
    {Lvl = {15,29}, Quest = "BuggyQuest1", QuestLvl = 1, Enemy = "Bandit", QuestPos = CFrame.new(-1119, 4.8, 3831)},
    {Lvl = {30,39}, Quest = "DesertQuest", QuestLvl = 1, Enemy = "Desert Bandit", QuestPos = CFrame.new(897, 6.4, 4388)},
    {Lvl = {40,59}, Quest = "SnowQuest", QuestLvl = 1, Enemy = "Snowman", QuestPos = CFrame.new(1384, 87, -1297)},
    {Lvl = {60,74}, Quest = "MarineQuest2", QuestLvl = 1, Enemy = "Chief Petty Officer", QuestPos = CFrame.new(-5035, 28.6, 4324)},
    {Lvl = {75,89}, Quest = "AreaQuest", QuestLvl = 1, Enemy = "Sky Bandit", QuestPos = CFrame.new(-4841, 717.6, -2623)},
    {Lvl = {90,99}, Quest = "AreaQuest", QuestLvl = 2, Enemy = "Dark Master", QuestPos = CFrame.new(-5260, 389.8, -2229)},
    {Lvl = {100,119}, Quest = "PrisonerQuest", QuestLvl = 1, Enemy = "Prisoner", QuestPos = CFrame.new(5308, 1.6, 475)},
    {Lvl = {120,149}, Quest = "ColosseumQuest", QuestLvl = 1, Enemy = "Gladiator", QuestPos = CFrame.new(-1535, 7.2, -29)},
    {Lvl = {150,174}, Quest = "MagmaQuest", QuestLvl = 1, Enemy = "Lava Pirate", QuestPos = CFrame.new(-5234, 51.4, -4732)},
    {Lvl = {175,189}, Quest = "MagmaQuest", QuestLvl = 2, Enemy = "Magma Admiral", QuestPos = CFrame.new(-5530, 85.5, -5380)},
    {Lvl = {190,209}, Quest = "FishmanQuest", QuestLvl = 1, Enemy = "Fishman Warrior", QuestPos = CFrame.new(60858, 18.5, 1389)},
    {Lvl = {210,249}, Quest = "FishmanQuest", QuestLvl = 2, Enemy = "Fishman Commando", QuestPos = CFrame.new(61122, 18.5, 1568)},
    {Lvl = {250,274}, Quest = "SkypieaQuest", QuestLvl = 1, Enemy = "God's Guard", QuestPos = CFrame.new(-4721, 843, -1949)},
    {Lvl = {275,299}, Quest = "SkypieaQuest", QuestLvl = 2, Enemy = "Shanda", QuestPos = CFrame.new(-7863, 5545, -380)},
    {Lvl = {300,324}, Quest = "SkyExp1Quest", QuestLvl = 1, Enemy = "Royal Squad", QuestPos = CFrame.new(-7684, 5567, -1704)},
    {Lvl = {325,374}, Quest = "SkyExp1Quest", QuestLvl = 2, Enemy = "Royal Soldier", QuestPos = CFrame.new(-7670, 5607, -1460)},
    {Lvl = {375,399}, Quest = "SkyExp2Quest", QuestLvl = 1, Enemy = "Galley Pirate", QuestPos = CFrame.new(-4990, 717.9, -2900)},
    {Lvl = {400,449}, Quest = "SkyExp2Quest", QuestLvl = 2, Enemy = "Galley Captain", QuestPos = CFrame.new(-5533, 528.3, -3141)},
    {Lvl = {450,474}, Quest = "FountainQuest", QuestLvl = 1, Enemy = "Cyborg", QuestPos = CFrame.new(5834, 38.3, 4047)},
    {Lvl = {475,524}, Quest = "FountainQuest", QuestLvl = 2, Enemy = "Cyborg", QuestPos = CFrame.new(6239, 38.3, 3945)},
    {Lvl = {525,549}, Quest = "ZombieQuest", QuestLvl = 1, Enemy = "Zombie", QuestPos = CFrame.new(-5736, 126.1, -728)},
    {Lvl = {550,574}, Quest = "ZombieQuest", QuestLvl = 2, Enemy = "Vampire", QuestPos = CFrame.new(-6033, 6.7, -1313)},
    {Lvl = {575,599}, Quest = "ShipQuest1", QuestLvl = 1, Enemy = "Pirate", QuestPos = CFrame.new(1037, 125.7, 32911)},
    {Lvl = {600,624}, Quest = "ShipQuest1", QuestLvl = 2, Enemy = "Pirate", QuestPos = CFrame.new(971, 125.1, 33245)},
    {Lvl = {625,649}, Quest = "ShipQuest2", QuestLvl = 1, Enemy = "Ship Deckhand", QuestPos = CFrame.new(1162, 125.7, 32911)},
    {Lvl = {650,699}, Quest = "ShipQuest2", QuestLvl = 2, Enemy = "Ship Engineer", QuestPos = CFrame.new(918, 43.8, 32787)},
    {Lvl = {700,724}, Quest = "FrostQuest", QuestLvl = 1, Enemy = "Raider", QuestPos = CFrame.new(-5496, 48.6, -4800)},
    {Lvl = {725,774}, Quest = "FrostQuest", QuestLvl = 2, Enemy = "Mercenary", QuestPos = CFrame.new(-5231, 42.5, -4519)},
    {Lvl = {775,799}, Quest = "PrisonQuest", QuestLvl = 1, Enemy = "Dangerous Prisoner", QuestPos = CFrame.new(5411, 95.7, 690)},
    {Lvl = {800,874}, Quest = "ColosseumQuest", QuestLvl = 1, Enemy = "Toga Warrior", QuestPos = CFrame.new(-1576, 7.4, -2984)},
    {Lvl = {875,899}, Quest = "ColosseumQuest", QuestLvl = 2, Enemy = "Gladiator", QuestPos = CFrame.new(-1267, 8.2, -2983)},
    {Lvl = {900,949}, Quest = "MagmaQuest", QuestLvl = 1, Enemy = "Military Soldier", QuestPos = CFrame.new(-5313, 10.9, 8515)},
    {Lvl = {950,974}, Quest = "MagmaQuest", QuestLvl = 2, Enemy = "Military Spy", QuestPos = CFrame.new(-5815, 83.9, 8820)},
    {Lvl = {975,999}, Quest = "SnowMountainQuest", QuestLvl = 1, Enemy = "Winter Warrior", QuestPos = CFrame.new(607, 401.4, -5370)},
    {Lvl = {1000,1049}, Quest = "SnowMountainQuest", QuestLvl = 2, Enemy = "Lab Subordinate", QuestPos = CFrame.new(-5769, 23.8, -4203)},
    {Lvl = {1050,1099}, Quest = "IceSideQuest", QuestLvl = 1, Enemy = "Horned Warrior", QuestPos = CFrame.new(-6078, 15.6, -5376)},
    {Lvl = {1100,1124}, Quest = "IceSideQuest", QuestLvl = 2, Enemy = "Magma Ninja", QuestPos = CFrame.new(-5428, 15.9, -5299)},
    {Lvl = {1125,1174}, Quest = "FireSideQuest", QuestLvl = 1, Enemy = "Lava Pirate", QuestPos = CFrame.new(-5234, 15.6, -4906)},
    {Lvl = {1175,1199}, Quest = "FireSideQuest", QuestLvl = 2, Enemy = "Ship Deckhand", QuestPos = CFrame.new(-5034, 15.6, -4905)},
    {Lvl = {1200,1249}, Quest = "ShipQuest1", QuestLvl = 1, Enemy = "Ship Steward", QuestPos = CFrame.new(1036, 125.8, 32910)},
    {Lvl = {1250,1274}, Quest = "ShipQuest2", QuestLvl = 1, Enemy = "Ship Officer", QuestPos = CFrame.new(919, 125.9, 32918)},
    {Lvl = {1275,1299}, Quest = "FrostQuest", QuestLvl = 1, Enemy = "Arctic Warrior", QuestPos = CFrame.new(5668, 28.2, -6484)},
    
    -- Sea 2
    {Lvl = {1300,1324}, Quest = "ChocQuest1", QuestLvl = 1, Enemy = "Chocolate Bar Battler", QuestPos = CFrame.new(233, 29.2, -12194)},
    {Lvl = {1325,1349}, Quest = "ChocQuest2", QuestLvl = 1, Enemy = "Sweet Thief", QuestPos = CFrame.new(150, 23.8, -12774)},
    {Lvl = {1350,1374}, Quest = "CocoaQuest", QuestLvl = 1, Enemy = "Cocoa Warrior", QuestPos = CFrame.new(117, 73.1, -12319)},
    {Lvl = {1375,1424}, Quest = "CocoaQuest", QuestLvl = 2, Enemy = "Chocolate Bar Battler", QuestPos = CFrame.new(527, 73.1, -12849)},
    {Lvl = {1425,1449}, Quest = "CakeQuest1", QuestLvl = 1, Enemy = "Cookie Crafter", QuestPos = CFrame.new(-2020, 38.1, -12025)},
    {Lvl = {1450,1474}, Quest = "CakeQuest1", QuestLvl = 2, Enemy = "Cake Guard", QuestPos = CFrame.new(-1571, 38.2, -12224)},
    {Lvl = {1475,1524}, Quest = "CakeQuest2", QuestLvl = 1, Enemy = "Baking Staff", QuestPos = CFrame.new(-1927, 38.1, -12983)},
    {Lvl = {1525,1574}, Quest = "CakeQuest2", QuestLvl = 2, Enemy = "Head Baker", QuestPos = CFrame.new(-2251, 52.2, -12373)},
    {Lvl = {1575,1599}, Quest = "IceCreamQuest", QuestLvl = 1, Enemy = "Ice Cream Chef", QuestPos = CFrame.new(-820, 65.8, -10965)},
    {Lvl = {1600,1624}, Quest = "IceCreamQuest", QuestLvl = 2, Enemy = "Ice Cream Commander", QuestPos = CFrame.new(-558, 73.6, -10965)},
    {Lvl = {1625,1649}, Quest = "SeaBeasts1", QuestLvl = 1, Enemy = "Pirate Millionaire", QuestPos = CFrame.new(-289, 43.8, 5579)},
    {Lvl = {1650,1699}, Quest = "SeaBeasts1", QuestLvl = 2, Enemy = "Pistol Billionaire", QuestPos = CFrame.new(-295, 43.8, 5555)},
    {Lvl = {1700,1724}, Quest = "ForgetQuest", QuestLvl = 1, Enemy = "Dragon Crew Warrior", QuestPos = CFrame.new(6339, 51.6, -1213)},
    {Lvl = {1725,1774}, Quest = "ForgetQuest", QuestLvl = 2, Enemy = "Dragon Crew Archer", QuestPos = CFrame.new(6594, 383.1, 139)},
    {Lvl = {1775,1799}, Quest = "ForgottenQuest", QuestLvl = 1, Enemy = "Female Islander", QuestPos = CFrame.new(5244, 601.6, 345)},
    {Lvl = {1800,1849}, Quest = "ForgottenQuest", QuestLvl = 2, Enemy = "Giant Islander", QuestPos = CFrame.new(5347, 601.8, -106)},
    {Lvl = {1850,1899}, Quest = "HauntedQuest1", QuestLvl = 1, Enemy = "Marine Commodore", QuestPos = CFrame.new(-2850, 72.9, -3300)},
    {Lvl = {1900,1924}, Quest = "HauntedQuest2", QuestLvl = 1, Enemy = "Marine Rear Admiral", QuestPos = CFrame.new(-5545, 28.6, -7755)},
    {Lvl = {1925,1974}, Quest = "DeepForestIsland", QuestLvl = 1, Enemy = "Mythological Pirate", QuestPos = CFrame.new(-13234, 331.5, -7625)},
    {Lvl = {1975,1999}, Quest = "DeepForestIsland2", QuestLvl = 1, Enemy = "Jungle Pirate", QuestPos = CFrame.new(-11975, 331.7, -10960)},
    {Lvl = {2000,2024}, Quest = "DeepForestIsland3", QuestLvl = 1, Enemy = "Musketeer Pirate", QuestPos = CFrame.new(-13284, 386.9, -9902)},
    {Lvl = {2025,2049}, Quest = "PiratePortQuest", QuestLvl = 1, Enemy = "Pirate", QuestPos = CFrame.new(-6240, 38.3, 5577)},
    {Lvl = {2050,2074}, Quest = "PiratePortQuest", QuestLvl = 2, Enemy = "Pistol Billionaire", QuestPos = CFrame.new(-6508, 38.9, 5736)},
    {Lvl = {2075,2099}, Quest = "AmazonQuest", QuestLvl = 1, Enemy = "Amazon Warrior", QuestPos = CFrame.new(5497, 51.5, -1800)},
    {Lvl = {2100,2124}, Quest = "AmazonQuest", QuestLvl = 2, Enemy = "Amazon Archer", QuestPos = CFrame.new(5251, 51.4, -1655)},
    {Lvl = {2125,2149}, Quest = "MarineTreeIsland", QuestLvl = 1, Enemy = "Marine Captain", QuestPos = CFrame.new(-4914, 717.7, -2622)},
    {Lvl = {2150,2174}, Quest = "MarineTreeIsland", QuestLvl = 2, Enemy = "Marine Commodore", QuestPos = CFrame.new(2286, 73.1, -7159)},
    {Lvl = {2175,2199}, Quest = "DeepForestIsland", QuestLvl = 1, Enemy = "Reborn Skeleton", QuestPos = CFrame.new(-9515, 172.1, 6079)},
    {Lvl = {2200,2224}, Quest = "DeepForestIsland2", QuestLvl = 1, Enemy = "Living Zombie", QuestPos = CFrame.new(-10238, 172.1, 6133)},
    {Lvl = {2225,2249}, Quest = "DeepForestIsland3", QuestLvl = 1, Enemy = "Demonic Soul", QuestPos = CFrame.new(-9507, 172.1, 6158)},
    {Lvl = {2250,2274}, Quest = "HauntedQuest1", QuestLvl = 1, Enemy = "Posessed Mummy", QuestPos = CFrame.new(-9546, 172.1, 6079)},
    {Lvl = {2275,2299}, Quest = "HauntedQuest2", QuestLvl = 1, Enemy = "Peanut Scout", QuestPos = CFrame.new(-2104, 38.1, -10192)},
    {Lvl = {2300,2324}, Quest = "NutsIslandQuest", QuestLvl = 1, Enemy = "Peanut President", QuestPos = CFrame.new(-2150, 38.3, -10520)},
    {Lvl = {2325,2349}, Quest = "NutsIslandQuest", QuestLvl = 2, Enemy = "Captain Elephant", QuestPos = CFrame.new(-2188, 38.1, -9942)},
    {Lvl = {2350,2374}, Quest = "IceCreamIslandQuest", QuestLvl = 1, Enemy = "Ice Cream Chef", QuestPos = CFrame.new(-641, 125.9, -11062)},
    {Lvl = {2375,2399}, Quest = "IceCreamIslandQuest", QuestLvl = 2, Enemy = "Ice Cream Commander", QuestPos = CFrame.new(-558, 125.9, -10965)},
    {Lvl = {2400,2424}, Quest = "CakeQuest1", QuestLvl = 1, Enemy = "Cookie Crafter", QuestPos = CFrame.new(-2374, 37.8, -12142)},
    {Lvl = {2425,2449}, Quest = "CakeQuest2", QuestLvl = 1, Enemy = "Cake Guard", QuestPos = CFrame.new(-1928, 37.8, -12030)},
    {Lvl = {2450,2474}, Quest = "CakeQuest2", QuestLvl = 2, Enemy = "Baking Staff", QuestPos = CFrame.new(-1927, 37.9, -12983)},
    {Lvl = {2475,2499}, Quest = "CakeQuest2", QuestLvl = 3, Enemy = "Head Baker", QuestPos = CFrame.new(-2251, 52.3, -12373)},
    {Lvl = {2500,2550}, Quest = "ChocQuest1", QuestLvl = 1, Enemy = "Chocolate Bar Battler", QuestPos = CFrame.new(620, 78.1, -12581)}
}

-- =============================================
-- HELPER FUNCTIONS
-- =============================================

-- Get Quest Based on Level
local function GetQuestByLevel()
    local Level = Player.Data.Level.Value
    
    for _, quest in pairs(QuestList) do
        if Level >= quest.Lvl[1] and Level <= quest.Lvl[2] then
            return quest
        end
    end
    
    return QuestList[1] -- Default
end

-- Smooth Tween Teleport
local function TweenToPosition(targetCFrame)
    if not Character or not RootPart then return end
    
    local Distance = (targetCFrame.Position - RootPart.Position).Magnitude
    
    if Distance < 250 then
        RootPart.CFrame = targetCFrame
        return
    end
    
    local TweenInfo = TweenInfo.new(
        Distance / Config.TweenSpeed,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    local Tween = TweenService:Create(RootPart, TweenInfo, {CFrame = targetCFrame})
    Tween:Play()
    
    -- انتظار بشكل آمن
    local Completed = false
    Tween.Completed:Connect(function()
        Completed = true
    end)
    
    -- Timeout بعد 10 ثواني
    local TimeOut = 0
    while not Completed and TimeOut < 100 do
        wait(0.1)
        TimeOut = TimeOut + 1
        if not Config.AutoFarm then break end
    end
end

-- Equip Weapon
local function EquipTool(toolName)
    if not Character then return end
    
    local Tool = Player.Backpack:FindFirstChild(toolName) or Character:FindFirstChild(toolName)
    
    if Tool and Tool:IsA("Tool") then
        if not Character:FindFirstChild(toolName) then
            Humanoid:EquipTool(Tool)
        end
    end
end

-- Fast Attack (Optimized)
local AttackConnection
local function StartFastAttack()
    if AttackConnection then return end
    
    AttackConnection = RunService.RenderStepped:Connect(function()
        if Config.AutoFarm then
            pcall(function()
                local Tool = Character:FindFirstChildOfClass("Tool")
                if Tool then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    wait(Config.FastAttackSpeed)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end)
        end
    end)
end

local function StopFastAttack()
    if AttackConnection then
        AttackConnection:Disconnect()
        AttackConnection = nil
    end
end

-- Enable Haki
local function EnableBusoHaki()
    if Config.AutoHaki and not Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

-- Check if Quest is Active
local function IsQuestActive(questName)
    local QuestGui = Player.PlayerGui:FindFirstChild("Main")
    if QuestGui and QuestGui:FindFirstChild("Quest") then
        local Title = QuestGui.Quest.Container.QuestTitle.Title.Text
        return string.find(Title, questName)
    end
    return false
end

-- Start Quest
local function TakeQuest(questData)
    if Config.UseQuest and not IsQuestActive(questData.Enemy) then
        TweenToPosition(questData.QuestPos)
        wait(0.5)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData.Quest, questData.QuestLvl)
        wait(0.3)
    end
end

-- Bring Mobs (Safe)
local function BringMob(mob)
    if not Config.BringMobs or not mob or not mob:FindFirstChild("HumanoidRootPart") then return end
    
    pcall(function()
        mob.HumanoidRootPart.CanCollide = false
        mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
        mob.HumanoidRootPart.Transparency = 1
        
        if RootPart then
            mob.HumanoidRootPart.CFrame = RootPart.CFrame * CFrame.new(0, 0, -Config.DistanceFromMob)
        end
    end)
end

-- =============================================
-- MAIN AUTO FARM LOOP
-- =============================================
local FarmLoop
local function StartAutoFarm()
    if FarmLoop then return end
    
    FarmLoop = RunService.Heartbeat:Connect(function()
        if not Config.AutoFarm then
            StopFastAttack()
            return
        end
        
        pcall(function()
            local Quest = GetQuestByLevel()
            if not Quest then return end
            
            -- Take Quest
            if Config.UseQuest then
                TakeQuest(Quest)
            end
            
            -- Find and Farm Enemy
            local Enemy = nil
            for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                if mob.Name == Quest.Enemy and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    Enemy = mob
                    break
                end
            end
            
            if Enemy and Enemy:FindFirstChild("HumanoidRootPart") then
                -- Enable Haki
                EnableBusoHaki()
                
                -- Equip Weapon
                EquipTool(Config.SelectedWeapon)
                
                -- Start Fast Attack
                StartFastAttack()
                
                -- Move to Enemy
                local TargetPos = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, Config.DistanceFromMob, 0)
                
                if RootPart then
                    RootPart.CFrame = TargetPos
                end
                
                -- Bring Mob
                BringMob(Enemy)
                
                -- Face Enemy
                if Humanoid and Enemy.HumanoidRootPart then
                    Humanoid.AutoRotate = false
                    RootPart.CFrame = CFrame.new(RootPart.Position, Enemy.HumanoidRootPart.Position)
                end
            else
                -- No enemy found, go to quest location
                StopFastAttack()
                if Quest.QuestPos then
                    TweenToPosition(Quest.QuestPos)
                end
            end
        end)
    end)
end

local function StopAutoFarm()
    if FarmLoop then
        FarmLoop:Disconnect()
        FarmLoop = nil
    end
    StopFastAttack()
    
    if Humanoid then
        Humanoid.AutoRotate = true
    end
end

-- =============================================
-- UI SETUP
-- =============================================

-- Info Tab
Tabs.Info:AddParagraph({
    Title = "Player Information",
    Content = string.format("Level: %d\nBeli: %s", 
        Player.Data.Level.Value,
        tostring(Player.Data.Beli.Value))
})

-- Main Tab
Tabs.Main:AddParagraph({
    Title = "Auto Farm System",
    Content = "Advanced auto leveling with anti-detection"
})

local WeaponDropdown = Tabs.Main:AddDropdown("WeaponSelect", {
    Title = "Select Weapon",
    Values = {"Combat", "Melee", "Sword", "Gun", "Blox Fruit"},
    Multi = false,
    Default = 1,
})

WeaponDropdown:OnChanged(function(Value)
    Config.SelectedWeapon = Value
end)

local AutoFarmToggle = Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm Level",
    Description = "Farm to max level automatically",
    Default = false
})

AutoFarmToggle:OnChanged(function(Value)
    Config.AutoFarm = Value
    
    if Value then
        StartAutoFarm()
        Fluent:Notify({
            Title = "Vortex Hub",
            Content = "Auto Farm Started!",
            Duration = 3
        })
    else
        StopAutoFarm()
        Fluent:Notify({
            Title = "Vortex Hub",
            Content = "Auto Farm Stopped",
            Duration = 3
        })
    end
end)

-- Settings Tab
Tabs.Settings:AddToggle("BringMobs", {
    Title = "Bring Mobs",
    Description = "Pull enemies to you",
    Default = true
}):OnChanged(function(Value)
    Config.BringMobs = Value
end)

Tabs.Settings:AddToggle("AutoHaki", {
    Title = "Auto Haki",
    Description = "Automatically enable Buso Haki",
    Default = true
}):OnChanged(function(Value)
    Config.AutoHaki = Value
end)

Tabs.Settings:AddToggle("UseQuest", {
    Title = "Use Quests",
    Description = "Take quests for bonus XP",
    Default = true
}):OnChanged(function(Value)
    Config.UseQuest = Value
end)

Tabs.Settings:AddSlider("AttackSpeed", {
    Title = "Attack Speed",
    Description = "Lower = Faster (0.05 - 0.2)",
    Default = 0.1,
    Min = 0.05,
    Max = 0.2,
    Rounding = 2
}):OnChanged(function(Value)
    Config.FastAttackSpeed = Value
end)

Tabs.Settings:AddSlider("Distance", {
    Title = "Distance from Enemy",
    Description = "Safe distance",
    Default = 20,
    Min = 10,
    Max = 50,
    Rounding = 0
}):OnChanged(function(Value)
    Config.DistanceFromMob = Value
end)

Tabs.Settings:AddSlider("TweenSpeed", {
    Title = "Movement Speed",
    Description = "Travel speed",
    Default = 300,
    Min = 200,
    Max = 500,
    Rounding = 0
}):OnChanged(function(Value)
    Config.TweenSpeed = Value
end)

-- Stats Tab
local StatSettings = {
    Melee = false,
    Defense = false,
    Sword = false,
    Gun = false,
    Fruit = false
}

Tabs.Stats:AddToggle("AutoMelee", {Title = "Auto Melee", Default = false}):OnChanged(function(v) StatSettings.Melee = v end)
Tabs.Stats:AddToggle("AutoDefense", {Title = "Auto Defense", Default = false}):OnChanged(function(v) StatSettings.Defense = v end)
Tabs.Stats:AddToggle("AutoSword", {Title = "Auto Sword", Default = false}):OnChanged(function(v) StatSettings.Sword = v end)
Tabs.Stats:AddToggle("AutoGun", {Title = "Auto Gun", Default = false}):OnChanged(function(v) StatSettings.Gun = v end)
Tabs.Stats:AddToggle("AutoFruit", {Title = "Auto Devil Fruit", Default = false}):OnChanged(function(v) StatSettings.Fruit = v end)

-- Auto Stats Loop
spawn(function()
    while wait(0.2) do
        pcall(function()
            if StatSettings.Melee then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1) end
            if StatSettings.Defense then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1) end
            if StatSettings.Sword then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1) end
            if StatSettings.Gun then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1) end
            if StatSettings.Fruit then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1) end
        end)
    end
end)

-- =============================================
-- FINALIZE
-- =============================================

Window:SelectTab(1)

Fluent:Notify({
    Title = "Vortex Hub V3",
    Content = "Loaded Successfully! Level: " .. Player.Data.Level.Value,
    Duration = 5
})

-- Auto-save settings
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        queue_on_teleport([[
            loadstring(game:HttpGet('YOUR_SCRIPT_URL'))()
        ]])
    end
end)

print("✅ Vortex Hub V3 Loaded | Anti-Detection Active")
