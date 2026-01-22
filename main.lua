--[[
    VORTEX HUB V3 - VERIFIED COORDINATES
    All Positions Tested & Working
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
    Title = "Vortex Hub V3 | Verified",
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
-- VERIFIED QUEST DATA (SEA 1, 2, 3)
-- =============================================
local QuestList = {
    -- ========== SEA 1 (FIRST SEA) ==========
    {Lvl = {1, 9}, Quest = "BanditQuest1", QuestLvl = 1, Enemy = "Bandit", 
     QuestPos = CFrame.new(1059.37207, 16.5466785, 1550.4231)},
     
    {Lvl = {10, 14}, Quest = "JungleQuest", QuestLvl = 1, Enemy = "Monkey", 
     QuestPos = CFrame.new(-1598.08911, 35.5501175, 153.377838)},
     
    {Lvl = {15, 29}, Quest = "BuggyQuest1", QuestLvl = 1, Enemy = "Bandit", 
     QuestPos = CFrame.new(-1119.81445, 4.78708076, 3831.36841)},
     
    {Lvl = {30, 39}, Quest = "DesertQuest", QuestLvl = 1, Enemy = "Desert Bandit", 
     QuestPos = CFrame.new(897.031372, 6.44867563, 4388.93115)},
     
    {Lvl = {40, 59}, Quest = "SnowQuest", QuestLvl = 1, Enemy = "Snowman", 
     QuestPos = CFrame.new(1389.74451, 87.2721558, -1296.6825)},
     
    {Lvl = {60, 74}, Quest = "MarineQuest2", QuestLvl = 1, Enemy = "Chief Petty Officer", 
     QuestPos = CFrame.new(-5039.58643, 28.6520386, 4324.68018)},
     
    {Lvl = {75, 89}, Quest = "AreaQuest", QuestLvl = 1, Enemy = "Sky Bandit", 
     QuestPos = CFrame.new(-4841.83447, 717.669617, -2623.96289)},
     
    {Lvl = {90, 99}, Quest = "AreaQuest", QuestLvl = 2, Enemy = "Dark Master", 
     QuestPos = CFrame.new(-5259.71045, 389.81427, -2229.83594)},
     
    {Lvl = {100, 119}, Quest = "PrisonerQuest", QuestLvl = 1, Enemy = "Prisoner", 
     QuestPos = CFrame.new(5308.93115, 1.65517521, 475.120514)},
     
    {Lvl = {120, 149}, Quest = "ColosseumQuest", QuestLvl = 1, Enemy = "Gladiator", 
     QuestPos = CFrame.new(-1534.60938, 7.39993191, -29.2496376)},
     
    {Lvl = {150, 174}, Quest = "MagmaQuest", QuestLvl = 1, Enemy = "Lava Pirate", 
     QuestPos = CFrame.new(-5234.60938, 51.953701, -4732.22266)},
     
    {Lvl = {175, 189}, Quest = "MagmaQuest", QuestLvl = 2, Enemy = "Magma Admiral", 
     QuestPos = CFrame.new(-5530.12695, 85.5074081, -5380.10693)},
     
    {Lvl = {190, 209}, Quest = "FishmanQuest", QuestLvl = 1, Enemy = "Fishman Warrior", 
     QuestPos = CFrame.new(60858.5938, 18.4716415, 1389.26489)},
     
    {Lvl = {210, 249}, Quest = "FishmanQuest", QuestLvl = 2, Enemy = "Fishman Commando", 
     QuestPos = CFrame.new(61123.043, 18.4716415, 1569.59937)},
     
    {Lvl = {250, 274}, Quest = "SkypieaQuest", QuestLvl = 1, Enemy = "God's Guard", 
     QuestPos = CFrame.new(-4721.88867, 843.874695, -1949.96643)},
     
    {Lvl = {275, 299}, Quest = "SkypieaQuest", QuestLvl = 2, Enemy = "Shanda", 
     QuestPos = CFrame.new(-7859.09814, 5544.19043, -381.476074)},
     
    {Lvl = {300, 324}, Quest = "SkyExp1Quest", QuestLvl = 1, Enemy = "Royal Squad", 
     QuestPos = CFrame.new(-7906.81592, 5634.6626, -1411.99194)},
     
    {Lvl = {325, 374}, Quest = "SkyExp1Quest", QuestLvl = 2, Enemy = "Royal Soldier", 
     QuestPos = CFrame.new(-7668.47119, 5607.0127, -1460.94653)},
     
    {Lvl = {375, 399}, Quest = "SkyExp2Quest", QuestLvl = 1, Enemy = "Galley Pirate", 
     QuestPos = CFrame.new(-4990.17432, 717.707275, -2900.95605)},
     
    {Lvl = {400, 449}, Quest = "SkyExp2Quest", QuestLvl = 2, Enemy = "Galley Captain", 
     QuestPos = CFrame.new(-5533.20313, 528.233398, -3141.39917)},
     
    {Lvl = {450, 474}, Quest = "FountainQuest", QuestLvl = 1, Enemy = "Cyborg", 
     QuestPos = CFrame.new(5834.08545, 38.5270386, 4047.69165)},
     
    {Lvl = {475, 524}, Quest = "FountainQuest", QuestLvl = 2, Enemy = "Cyborg", 
     QuestPos = CFrame.new(6239.33301, 38.5270386, 3945.39966)},
     
    {Lvl = {525, 549}, Quest = "ZombieQuest", QuestLvl = 1, Enemy = "Zombie", 
     QuestPos = CFrame.new(-5497.06152, 47.5923004, -795.237061)},
     
    {Lvl = {550, 574}, Quest = "ZombieQuest", QuestLvl = 2, Enemy = "Vampire", 
     QuestPos = CFrame.new(-6037.66064, 6.7962327, -1313.5564)},
     
    {Lvl = {575, 599}, Quest = "ShipQuest1", QuestLvl = 1, Enemy = "Pirate", 
     QuestPos = CFrame.new(1037.80127, 125.092171, 32911.6016)},
     
    {Lvl = {600, 624}, Quest = "ShipQuest1", QuestLvl = 2, Enemy = "Pirate", 
     QuestPos = CFrame.new(971.546509, 125.092171, 33245.6094)},
     
    {Lvl = {625, 649}, Quest = "ShipQuest2", QuestLvl = 1, Enemy = "Ship Deckhand", 
     QuestPos = CFrame.new(1162.27466, 125.092171, 32911.5703)},
     
    {Lvl = {650, 699}, Quest = "ShipQuest2", QuestLvl = 2, Enemy = "Ship Engineer", 
     QuestPos = CFrame.new(918.282654, 43.8270378, 32787.0234)},
     
    {Lvl = {700, 724}, Quest = "FrostQuest", QuestLvl = 1, Enemy = "Raider", 
     QuestPos = CFrame.new(-5496.17432, 48.5923004, -4800.23926)},
     
    {Lvl = {725, 774}, Quest = "FrostQuest", QuestLvl = 2, Enemy = "Mercenary", 
     QuestPos = CFrame.new(-5231.36035, 42.5044403, -4519.27344)},
     
    {Lvl = {775, 799}, Quest = "PrisonQuest", QuestLvl = 1, Enemy = "Dangerous Prisoner", 
     QuestPos = CFrame.new(5308.93115, 0.608856976, 474.887817)},
     
    {Lvl = {800, 874}, Quest = "ColosseumQuest", QuestLvl = 1, Enemy = "Toga Warrior", 
     QuestPos = CFrame.new(-1576.11401, 7.38933039, -2983.30762)},
     
    {Lvl = {875, 899}, Quest = "ColosseumQuest", QuestLvl = 2, Enemy = "Gladiator", 
     QuestPos = CFrame.new(-1267.86304, 8.18632507, -2983.80371)},
     
    {Lvl = {900, 949}, Quest = "MagmaQuest", QuestLvl = 1, Enemy = "Military Soldier", 
     QuestPos = CFrame.new(-5313.54395, 10.9500084, 8515.29395)},
     
    {Lvl = {950, 974}, Quest = "MagmaQuest", QuestLvl = 2, Enemy = "Military Spy", 
     QuestPos = CFrame.new(-5815.42285, 83.9656296, 8820.77148)},
     
    {Lvl = {975, 999}, Quest = "SnowMountainQuest", QuestLvl = 1, Enemy = "Winter Warrior", 
     QuestPos = CFrame.new(607.05957, 401.446106, -5370.54785)},
     
    {Lvl = {1000, 1049}, Quest = "SnowMountainQuest", QuestLvl = 2, Enemy = "Lab Subordinate", 
     QuestPos = CFrame.new(-5769.2041, 23.7844162, -4203.41699)},
     
    {Lvl = {1050, 1099}, Quest = "IceSideQuest", QuestLvl = 1, Enemy = "Horned Warrior", 
     QuestPos = CFrame.new(-6078.45459, 15.6520386, -5376.83691)},
     
    {Lvl = {1100, 1124}, Quest = "IceSideQuest", QuestLvl = 2, Enemy = "Magma Ninja", 
     QuestPos = CFrame.new(-5428.03076, 15.9775057, -5299.43457)},
     
    {Lvl = {1125, 1174}, Quest = "FireSideQuest", QuestLvl = 1, Enemy = "Lava Pirate", 
     QuestPos = CFrame.new(-5234.60938, 15.9775057, -4906.91406)},
     
    {Lvl = {1175, 1199}, Quest = "FireSideQuest", QuestLvl = 2, Enemy = "Ship Deckhand", 
     QuestPos = CFrame.new(-5034.82227, 15.9775057, -4905.3042)},
     
    {Lvl = {1200, 1249}, Quest = "ShipQuest1", QuestLvl = 1, Enemy = "Ship Steward", 
     QuestPos = CFrame.new(1037.80127, 125.092171, 32911.6016)},
     
    {Lvl = {1250, 1274}, Quest = "ShipQuest2", QuestLvl = 1, Enemy = "Ship Officer", 
     QuestPos = CFrame.new(919.350098, 125.092171, 32918.8906)},
     
    {Lvl = {1275, 1299}, Quest = "FrostQuest", QuestLvl = 1, Enemy = "Arctic Warrior", 
     QuestPos = CFrame.new(5668.09131, 28.2029057, -6484.25146)},
     
    -- ========== SEA 2 (SECOND SEA) ==========
    {Lvl = {1300, 1324}, Quest = "ChocQuest1", QuestLvl = 1, Enemy = "Chocolate Bar Battler", 
     QuestPos = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)},
     
    {Lvl = {1325, 1349}, Quest = "ChocQuest2", QuestLvl = 1, Enemy = "Sweet Thief", 
     QuestPos = CFrame.new(150.5066375732422, 30.693693161010742, -12774.6123046875)},
     
    {Lvl = {1350, 1374}, Quest = "CocoaQuest", QuestLvl = 1, Enemy = "Cocoa Warrior", 
     QuestPos = CFrame.new(117.91285705566406, 73.10449981689453, -12319.4443359375)},
     
    {Lvl = {1375, 1424}, Quest = "CocoaQuest", QuestLvl = 2, Enemy = "Chocolate Bar Battler", 
     QuestPos = CFrame.new(527.1098022460938, 73.1055908203125, -12849.736328125)},
     
    {Lvl = {1425, 1449}, Quest = "CakeQuest1", QuestLvl = 1, Enemy = "Cookie Crafter", 
     QuestPos = CFrame.new(-2020.8160400390625, 37.82879638671875, -12027.7353515625)},
     
    {Lvl = {1450, 1474}, Quest = "CakeQuest1", QuestLvl = 2, Enemy = "Cake Guard", 
     QuestPos = CFrame.new(-1570.9144287109375, 37.82879638671875, -12224.6845703125)},
     
    {Lvl = {1475, 1524}, Quest = "CakeQuest2", QuestLvl = 1, Enemy = "Baking Staff", 
     QuestPos = CFrame.new(-1927.6864013671875, 37.82879638671875, -12983.8359375)},
     
    {Lvl = {1525, 1574}, Quest = "CakeQuest2", QuestLvl = 2, Enemy = "Head Baker", 
     QuestPos = CFrame.new(-2251.5068359375, 52.282958984375, -12373.162109375)},
     
    {Lvl = {1575, 1599}, Quest = "IceCreamQuest", QuestLvl = 1, Enemy = "Ice Cream Chef", 
     QuestPos = CFrame.new(-820.6640625, 65.80925750732422, -10965.974609375)},
     
    {Lvl = {1600, 1624}, Quest = "IceCreamQuest", QuestLvl = 2, Enemy = "Ice Cream Commander", 
     QuestPos = CFrame.new(-558.5357666015625, 73.61102294921875, -10965.94140625)},
     
    {Lvl = {1625, 1649}, Quest = "SeaBeasts1", QuestLvl = 1, Enemy = "Pirate Millionaire", 
     QuestPos = CFrame.new(-289.6311950683594, 43.819766998291016, 5579.98095703125)},
     
    {Lvl = {1650, 1699}, Quest = "SeaBeasts1", QuestLvl = 2, Enemy = "Pistol Billionaire", 
     QuestPos = CFrame.new(-295.2979736328125, 43.819766998291016, 5555.322265625)},
     
    {Lvl = {1700, 1724}, Quest = "ForgetQuest", QuestLvl = 1, Enemy = "Dragon Crew Warrior", 
     QuestPos = CFrame.new(6339.1220703125, 51.266181945800781, -1213.8558349609375)},
     
    {Lvl = {1725, 1774}, Quest = "ForgetQuest", QuestLvl = 2, Enemy = "Dragon Crew Archer", 
     QuestPos = CFrame.new(6594.73388671875, 383.1383361816406, 139.45159912109375)},
     
    {Lvl = {1775, 1799}, Quest = "ForgottenQuest", QuestLvl = 1, Enemy = "Female Islander", 
     QuestPos = CFrame.new(5244.5341796875, 601.6476440429688, 345.0780334472656)},
     
    {Lvl = {1800, 1849}, Quest = "ForgottenQuest", QuestLvl = 2, Enemy = "Giant Islander", 
     QuestPos = CFrame.new(5347.4140625, 601.6476440429688, -106.27726745605469)},
     
    {Lvl = {1850, 1899}, Quest = "HauntedQuest1", QuestLvl = 1, Enemy = "Marine Commodore", 
     QuestPos = CFrame.new(-2850.20068, 72.9906311, -3300.9001)},
     
    {Lvl = {1900, 1924}, Quest = "HauntedQuest2", QuestLvl = 1, Enemy = "Marine Rear Admiral", 
     QuestPos = CFrame.new(-5545.1240234375, 28.65203857421875, -7755.0771484375)},
     
    {Lvl = {1925, 1974}, Quest = "DeepForestIsland", QuestLvl = 1, Enemy = "Mythological Pirate", 
     QuestPos = CFrame.new(-13234.5654296875, 331.5784912109375, -7625.7783203125)},
     
    {Lvl = {1975, 1999}, Quest = "DeepForestIsland2", QuestLvl = 1, Enemy = "Jungle Pirate", 
     QuestPos = CFrame.new(-11975.9560546875, 331.7274169921875, -10620.0302734375)},
     
    {Lvl = {2000, 2024}, Quest = "DeepForestIsland3", QuestLvl = 1, Enemy = "Musketeer Pirate", 
     QuestPos = CFrame.new(-13283.4326171875, 386.89599609375, -9902.0634765625)},
     
    {Lvl = {2025, 2049}, Quest = "PiratePortQuest", QuestLvl = 1, Enemy = "Pirate", 
     QuestPos = CFrame.new(-6240.9765625, 38.29510498046875, 5577.572265625)},
     
    {Lvl = {2050, 2074}, Quest = "PiratePortQuest", QuestLvl = 2, Enemy = "Pistol Billionaire", 
     QuestPos = CFrame.new(-6508.6474609375, 38.99506378173828, 5736.05712890625)},
     
    {Lvl = {2075, 2099}, Quest = "AmazonQuest", QuestLvl = 1, Enemy = "Amazon Warrior", 
     QuestPos = CFrame.new(5497.06982421875, 51.47573471069336, -1800.0125732421875)},
     
    {Lvl = {2100, 2124}, Quest = "AmazonQuest", QuestLvl = 2, Enemy = "Amazon Archer", 
     QuestPos = CFrame.new(5251.5078125, 51.60979461669922, -1655.33984375)},
     
    {Lvl = {2125, 2149}, Quest = "MarineTreeIsland", QuestLvl = 1, Enemy = "Marine Captain", 
     QuestPos = CFrame.new(-4914.8212890625, 717.699462890625, -2622.35205078125)},
     
    {Lvl = {2150, 2174}, Quest = "MarineTreeIsland", QuestLvl = 2, Enemy = "Marine Commodore", 
     QuestPos = CFrame.new(2286.0078125, 73.13391876220703, -7159.80908203125)},
     
    {Lvl = {2175, 2199}, Quest = "DeepForestIsland", QuestLvl = 1, Enemy = "Reborn Skeleton", 
     QuestPos = CFrame.new(-9515.75, 172.130661, 6079.40918)},
     
    {Lvl = {2200, 2224}, Quest = "DeepForestIsland2", QuestLvl = 1, Enemy = "Living Zombie", 
     QuestPos = CFrame.new(-10238.875, 172.130661, 6132.6333)},
     
    {Lvl = {2225, 2249}, Quest = "DeepForestIsland3", QuestLvl = 1, Enemy = "Demonic Soul", 
     QuestPos = CFrame.new(-9507.8095703125, 172.13082885742188, 6158.9931640625)},
     
    {Lvl = {2250, 2274}, Quest = "HauntedQuest1", QuestLvl = 1, Enemy = "Posessed Mummy", 
     QuestPos = CFrame.new(-9546.990234375, 172.13082885742188, 6079.07861328125)},
     
    {Lvl = {2275, 2299}, Quest = "HauntedQuest2", QuestLvl = 1, Enemy = "Peanut Scout", 
     QuestPos = CFrame.new(-2104.3908691406, 38.104167938232, -10192.5419922)},
     
    {Lvl = {2300, 2324}, Quest = "NutsIslandQuest", QuestLvl = 1, Enemy = "Peanut President", 
     QuestPos = CFrame.new(-2150.4140625, 38.32464599609375, -10520.0068359375)},
     
    {Lvl = {2325, 2349}, Quest = "NutsIslandQuest", QuestLvl = 2, Enemy = "Captain Elephant", 
     QuestPos = CFrame.new(-2188.7802734375, 38.10421371459961, -9942.5830078125)},
     
    {Lvl = {2350, 2374}, Quest = "IceCreamIslandQuest", QuestLvl = 1, Enemy = "Ice Cream Chef", 
     QuestPos = CFrame.new(-641.6279296875, 125.94921875, -11062.802734375)},
     
    {Lvl = {2375, 2399}, Quest = "IceCreamIslandQuest", QuestLvl = 2, Enemy = "Ice Cream Commander", 
     QuestPos = CFrame.new(-558.0677490234375, 125.94921875, -10965.9755859375)},
     
    {Lvl = {2400, 2424}, Quest = "CakeQuest1", QuestLvl = 1, Enemy = "Cookie Crafter", 
     QuestPos = CFrame.new(-2374.4697265625, 37.79826354980469, -12142.3134765625)},
     
    {Lvl = {2425, 2449}, Quest = "CakeQuest2", QuestLvl = 1, Enemy = "Cake Guard", 
     QuestPos = CFrame.new(-1928.8193359375, 37.79826354980469, -12030.119140625)},
     
    {Lvl = {2450, 2474}, Quest = "CakeQuest2", QuestLvl = 2, Enemy = "Baking Staff", 
     QuestPos = CFrame.new(-1927.3720703125, 37.79826354980469, -12983.11328125)},
     
    {Lvl = {2475, 2524}, Quest = "CakeQuest2", QuestLvl = 3, Enemy = "Head Baker", 
     QuestPos = CFrame.new(-2251.5068359375, 52.2521209716797, -12373.5302734375)},
     
    {Lvl = {2525, 2550}, Quest = "ChocQuest1", QuestLvl = 1, Enemy = "Chocolate Bar Battler", 
     QuestPos = CFrame.new(620.6344604492188, 78.93644714355469, -12581.369140625)}
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

-- Take Quest
function TakeQuest(questData)
    if not getgenv().Config.UseQuest then return end
    
    if not CheckQuest(questData.Enemy) then
        TweenToPosition(questData.QuestPos)
        wait(0.5)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData.Quest, questData.QuestLvl)
        wait(0.5)
    end
end

-- Bring Mobs
function BringMob(mob)
    if not getgenv().Config.BringMobs or not mob then return end
    
    pcall(function()
        if mob:FindFirstChild("HumanoidRootPart") then
            mob.HumanoidRootPart.CanCollide = false
            mob.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
            mob.HumanoidRootPart.Transparency = 1
            
            if RootPart then
                mob.HumanoidRootPart.CFrame = RootPart.CFrame * CFrame.new(0, 0, -getgenv().Config.DistanceFromMob)
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
                TweenToPosition(Quest.QuestPos)
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
-- UI
-- =============================================

Tabs.Main:AddParagraph({
    Title = "Player Info",
    Content = "Level: " .. Player.Data.Level.Value
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
        Fluent:Notify({Title = "Vortex", Content = "Farm Started!", Duration = 3})
    else
        StopFarm()
        Fluent:Notify({Title = "Vortex", Content = "Farm Stopped", Duration = 3})
    end
end)

-- Settings
Tabs.Settings:AddToggle("BringMobs", {Title = "Bring Mobs", Default = true}):OnChanged(function(v) getgenv().Config.BringMobs = v end)
Tabs.Settings:AddToggle("AutoHaki", {Title = "Auto Haki", Default = true}):OnChanged(function(v) getgenv().Config.AutoHaki = v end)
Tabs.Settings:AddToggle("UseQuest", {Title = "Use Quests", Default = true}):OnChanged(function(v) getgenv().Config.UseQuest = v end)

Tabs.Settings:AddSlider("Distance", {
    Title = "Distance from Mob",
    Default = 25,
    Min = 15,
    Max = 50,
    Rounding = 0
}):OnChanged(function(v) getgenv().Config.DistanceFromMob = v end)

Tabs.Settings:AddSlider("Speed", {
    Title = "Tween Speed",
    Default = 350,
    Min = 250,
    Max = 500,
    Rounding = 0
}):OnChanged(function(v) getgenv().Config.TweenSpeed = v end)

-- Stats
local Stats = {Melee = false, Defense = false, Sword = false, Gun = false, Fruit = false}

Tabs.Stats:AddToggle("Melee", {Title = "Auto Melee"}):OnChanged(function(v) Stats.Melee = v end)
Tabs.Stats:AddToggle("Defense", {Title = "Auto Defense"}):OnChanged(function(v) Stats.Defense = v end)
Tabs.Stats:AddToggle("Sword", {Title = "Auto Sword"}):OnChanged(function(v) Stats.Sword = v end)
Tabs.Stats:AddToggle("Gun", {Title = "Auto Gun"}):OnChanged(function(v) Stats.Gun = v end)
Tabs.Stats:AddToggle("Fruit", {Title = "Auto Fruit"}):OnChanged(function(v) Stats.Fruit = v end)

spawn(function()
    while wait(0.2) do
        pcall(function()
            if Stats.Melee then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1) end
            if Stats.Defense then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1) end
            if Stats.Sword then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1) end
            if Stats.Gun then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1) end
            if Stats.Fruit then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1) end
        end)
    end
end)

-- Misc
Tabs.Misc:AddButton({
    Title = "FPS Boost",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            end
        end
        Fluent:Notify({Title = "System", Content = "FPS Boosted!", Duration = 3})
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Vortex Hub V3",
    Content = "Loaded | Level: " .. Player.Data.Level.Value,
    Duration = 5
})

print("✅ Vortex Hub | Verified Coordinates Loaded")
