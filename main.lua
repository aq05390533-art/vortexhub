--[[
    VORTEX HUB - Auto Farm ALL LEVELS
    From Level 1 to 2550 (MAX)
]]--

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Vortex Hub " .. "v2.0",
    SubTitle = "by aq05390533-art",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Farm = Window:AddTab({ Title = "Farm", Icon = "sword" }),
    Stats = Window:AddTab({ Title = "Stats", Icon = "bar-chart-2" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

-- =============================================
-- VARIABLES
-- =============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

getgenv().Settings = {
    AutoFarm = false,
    SelectedWeapon = "Melee",
    FastAttack = true,
    AutoHaki = true,
    BringMobs = true,
    FarmDistance = 25
}

-- Anti AFK
LocalPlayer.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- =============================================
-- QUEST DATA - كل الكويستات في اللعبة
-- =============================================
local QuestData = {
    -- Sea 1 (Old World)
    {Level = {1, 9}, Quest = "BanditQuest1", QuestNum = 1, Mon = "Bandit", Pos = CFrame.new(1059, 16, 1550)},
    {Level = {10, 14}, Quest = "JungleQuest", QuestNum = 1, Mon = "Monkey", Pos = CFrame.new(-1448, 50, 38)},
    {Level = {15, 29}, Quest = "BuggyQuest1", QuestNum = 1, Mon = "Bandit", Pos = CFrame.new(-1119, 4, 3831)},
    {Level = {30, 39}, Quest = "DesertQuest", QuestNum = 1, Mon = "Desert Bandit", Pos = CFrame.new(924, 6, 4481)},
    {Level = {40, 59}, Quest = "SnowQuest", QuestNum = 1, Mon = "Snowman", Pos = CFrame.new(1384, 87, -1296)},
    {Level = {60, 74}, Quest = "MarineQuest2", QuestNum = 1, Mon = "Chief Petty Officer", Pos = CFrame.new(-5035, 28, 4324)},
    {Level = {75, 89}, Quest = "AreaQuest", QuestNum = 1, Mon = "Sky Bandit", Pos = CFrame.new(-4841, 717, -2623)},
    {Level = {90, 99}, Quest = "AreaQuest", QuestNum = 2, Mon = "Dark Master", Pos = CFrame.new(-5260, 389, -2229)},
    {Level = {100, 119}, Quest = "PrisonerQuest", QuestNum = 1, Mon = "Prisoner", Pos = CFrame.new(5308, 1, 474)},
    {Level = {120, 149}, Quest = "ColosseumQuest", QuestNum = 1, Mon = "Gladiator", Pos = CFrame.new(-1535, 7, -29)},
    {Level = {150, 174}, Quest = "MagmaQuest", QuestNum = 1, Mon = "Lava Pirate", Pos = CFrame.new(-5234, 51, -4732)},
    {Level = {175, 189}, Quest = "MagmaQuest", QuestNum = 2, Mon = "Magma Admiral", Pos = CFrame.new(-5530, 85, -5380)},
    {Level = {190, 209}, Quest = "FishmanQuest", QuestNum = 1, Mon = "Fishman Warrior", Pos = CFrame.new(60858, 18, 1389)},
    {Level = {210, 249}, Quest = "FishmanQuest", QuestNum = 2, Mon = "Fishman Commando", Pos = CFrame.new(61122, 18, 1568)},
    {Level = {250, 274}, Quest = "SkypieaQuest", QuestNum = 1, Mon = "God's Guard", Pos = CFrame.new(-4721, 843, -1949)},
    {Level = {275, 299}, Quest = "SkypieaQuest", QuestNum = 2, Mon = "Shanda", Pos = CFrame.new(-7863, 5545, -379)},
    {Level = {300, 324}, Quest = "SkyExp1Quest", QuestNum = 1, Mon = "Royal Squad", Pos = CFrame.new(-7684, 5567, -1704)},
    {Level = {325, 374}, Quest = "SkyExp1Quest", QuestNum = 2, Mon = "Royal Soldier", Pos = CFrame.new(-7670, 5607, -1460)},
    {Level = {375, 399}, Quest = "SkyExp2Quest", QuestNum = 1, Mon = "Galley Pirate", Pos = CFrame.new(-4990, 717, -2900)},
    {Level = {400, 449}, Quest = "SkyExp2Quest", QuestNum = 2, Mon = "Galley Captain", Pos = CFrame.new(-5533, 528, -3141)},
    {Level = {450, 474}, Quest = "FountainQuest", QuestNum = 1, Mon = "Cyborg", Pos = CFrame.new(5834, 38, 4047)},
    {Level = {475, 524}, Quest = "FountainQuest", QuestNum = 2, Mon = "Cyborg", Pos = CFrame.new(6239, 38, 3945)},
    {Level = {525, 549}, Quest = "ZombieQuest", QuestNum = 1, Mon = "Zombie", Pos = CFrame.new(-5736, 126, -728)},
    {Level = {550, 574}, Quest = "ZombieQuest", QuestNum = 2, Mon = "Vampire", Pos = CFrame.new(-6033, 6, -1313)},
    {Level = {575, 599}, Quest = "ShipQuest1", QuestNum = 1, Mon = "Pirate", Pos = CFrame.new(1037, 125, 32911)},
    {Level = {600, 624}, Quest = "ShipQuest1", QuestNum = 2, Mon = "Pirate", Pos = CFrame.new(971, 125, 33245)},
    {Level = {625, 649}, Quest = "ShipQuest2", QuestNum = 1, Mon = "Ship Deckhand", Pos = CFrame.new(1162, 125, 32911)},
    {Level = {650, 699}, Quest = "ShipQuest2", QuestNum = 2, Mon = "Ship Engineer", Pos = CFrame.new(918, 43, 32787)},
    {Level = {700, 724}, Quest = "FrostQuest", QuestNum = 1, Mon = "Raider", Pos = CFrame.new(-5496, 48, -4800)},
    {Level = {725, 774}, Quest = "FrostQuest", QuestNum = 2, Mon = "Mercenary", Pos = CFrame.new(-5231, 42, -4519)},
    {Level = {775, 799}, Quest = "PrisonQuest", QuestNum = 1, Mon = "Dangerous Prisoner", Pos = CFrame.new(5411, 95, 690)},
    {Level = {800, 874}, Quest = "PrisonQuest", QuestNum = 2, Mon = "Toga Warrior", Pos = CFrame.new(-1576, 7, -2984)},
    {Level = {875, 899}, Quest = "ColosseumQuest", QuestNum = 1, Mon = "Gladiator", Pos = CFrame.new(-1267, 8, -2983)},
    {Level = {900, 949}, Quest = "ColosseumQuest", QuestNum = 2, Mon = "Gladiator", Pos = CFrame.new(-1342, 8, -3039)},
    {Level = {950, 974}, Quest = "MagmaQuest", QuestNum = 1, Mon = "Lava Pirate", Pos = CFrame.new(-5234, 51, -4732)},
    {Level = {975, 999}, Quest = "MagmaQuest", QuestNum = 2, Mon = "Head Baker", Pos = CFrame.new(-5523, 219, -4895)},
    {Level = {1000, 1049}, Quest = "AreaQuest", QuestNum = 1, Mon = "Cake Guard", Pos = CFrame.new(-821, 64, -10965)},
    {Level = {1050, 1099}, Quest = "AreaQuest", QuestNum = 2, Mon = "Baking Staff", Pos = CFrame.new(-1927, 37, -12983)},
    
    -- Sea 2 (New World)
    {Level = {1100, 1124}, Quest = "ChocQuest1", QuestNum = 1, Mon = "Chocolate Bar Battler", Pos = CFrame.new(233, 29, -12194)},
    {Level = {1125, 1174}, Quest = "ChocQuest2", QuestNum = 1, Mon = "Sweet Thief", Pos = CFrame.new(150, 23, -12774)},
    {Level = {1175, 1199}, Quest = "IceCreamQuest", QuestNum = 1, Mon = "Ice Cream Chef", Pos = CFrame.new(-820, 65, -10965)},
    {Level = {1200, 1249}, Quest = "IceSideQuest", QuestNum = 1, Mon = "Ice Cream Commander", Pos = CFrame.new(-558, 73, -10965)},
    {Level = {1250, 1274}, Quest = "FrostQuest", QuestNum = 1, Mon = "Cookie Crafter", Pos = CFrame.new(-2020, 38, -12025)},
    {Level = {1275, 1299}, Quest = "CakeQuest", QuestNum = 1, Mon = "Cake Guard", Pos = CFrame.new(-1571, 38, -12224)},
    {Level = {1300, 1324}, Quest = "CakeQuest", QuestNum = 2, Mon = "Baking Staff", Pos = CFrame.new(-1927, 38, -12983)},
    {Level = {1325, 1349}, Quest = "CakeQuest", QuestNum = 3, Mon = "Head Baker", Pos = CFrame.new(-2251, 52, -12373)},
    {Level = {1350, 1374}, Quest = "DressQuest", QuestNum = 1, Mon = "Cocoa Warrior", Pos = CFrame.new(117, 73, -12319)},
    {Level = {1375, 1424}, Quest = "DressQuest", QuestNum = 2, Mon = "Chocolate Bar Battler", Pos = CFrame.new(527, 73, -12849)},
    {Level = {1425, 1449}, Quest = "IceCreamIslandQuest", QuestNum = 1, Mon = "Ice Cream Chef", Pos = CFrame.new(-641, 126, -11062)},
    {Level = {1450, 1474}, Quest = "IceCreamIslandQuest", QuestNum = 2, Mon = "Ice Cream Commander", Pos = CFrame.new(-558, 126, -10965)},
    {Level = {1475, 1524}, Quest = "SeaBeasts1", QuestNum = 1, Mon = "Pirate Millionaire", Pos = CFrame.new(-291, 43, 5580)},
    {Level = {1525, 1574}, Quest = "SeaBeasts1", QuestNum = 2, Mon = "Pistol Billionaire", Pos = CFrame.new(-295, 43, 5555)},
    {Level = {1575, 1599}, Quest = "ForgetQuest", QuestNum = 1, Mon = "Dragon Crew Warrior", Pos = CFrame.new(6339, 52, -1213)},
    {Level = {1600, 1624}, Quest = "ForgetQuest", QuestNum = 2, Mon = "Dragon Crew Archer", Pos = CFrame.new(6594, 383, 139)},
    {Level = {1625, 1649}, Quest = "ForgottenQuest", QuestNum = 1, Mon = "Female Islander", Pos = CFrame.new(5244, 602, 345)},
    {Level = {1650, 1699}, Quest = "ForgottenQuest", QuestNum = 2, Mon = "Giant Islander", Pos = CFrame.new(5347, 602, -106)},
    {Level = {1700, 1724}, Quest = "HauntedQuest1", QuestNum = 1, Mon = "Marine Commodore", Pos = CFrame.new(-2850, 73, -3300)},
    {Level = {1725, 1774}, Quest = "HauntedQuest2", QuestNum = 1, Mon = "Marine Rear Admiral", Pos = CFrame.new(-5545, 28, -7755)},
    {Level = {1775, 1799}, Quest = "DeepForestIsland", QuestNum = 1, Mon = "Mythological Pirate", Pos = CFrame.new(-13234, 332, -7625)},
    {Level = {1800, 1849}, Quest = "DeepForestIsland2", QuestNum = 1, Mon = "Jungle Pirate", Pos = CFrame.new(-11975, 332, -10960)},
    {Level = {1850, 1899}, Quest = "DeepForestIsland3", QuestNum = 1, Mon = "Musketeer Pirate", Pos = CFrame.new(-13284, 387, -9902)},
    {Level = {1900, 1924}, Quest = "PiratePortQuest", QuestNum = 1, Mon = "Pirate", Pos = CFrame.new(-6240, 38, 5577)},
    {Level = {1925, 1974}, Quest = "PiratePortQuest", QuestNum = 2, Mon = "Pistol Billionaire", Pos = CFrame.new(-6508, 38, 5736)},
    {Level = {1975, 1999}, Quest = "AmazonQuest", QuestNum = 1, Mon = "Amazon Warrior", Pos = CFrame.new(5497, 51, -1800)},
    {Level = {2000, 2024}, Quest = "AmazonQuest", QuestNum = 2, Mon = "Amazon Archer", Pos = CFrame.new(5251, 51, -1655)},
    {Level = {2025, 2049}, Quest = "AmazonQuest2", QuestNum = 1, Mon = "Chief Petty Officer", Pos = CFrame.new(-5039, 28, 4324)},
    {Level = {2050, 2074}, Quest = "MarineTreeIsland", QuestNum = 1, Mon = "Marine Captain", Pos = CFrame.new(-4919, 717, -2622)},
    {Level = {2075, 2099}, Quest = "MarineTreeIsland", QuestNum = 2, Mon = "Marine Commodore", Pos = CFrame.new(2286, 73, -7159)},
    {Level = {2100, 2124}, Quest = "DeepForestIsland", QuestNum = 1, Mon = "Reborn Skeleton", Pos = CFrame.new(-9515, 172, 6079)},
    {Level = {2125, 2149}, Quest = "DeepForestIsland2", QuestNum = 1, Mon = "Living Zombie", Pos = CFrame.new(-10238, 172, 6133)},
    {Level = {2150, 2199}, Quest = "DeepForestIsland3", QuestNum = 1, Mon = "Demonic Soul", Pos = CFrame.new(-9507, 172, 6158)},
    {Level = {2200, 2224}, Quest = "HauntedQuest1", QuestNum = 1, Mon = "Posessed Mummy", Pos = CFrame.new(-9546, 172, 6079)},
    {Level = {2225, 2249}, Quest = "HauntedQuest2", QuestNum = 1, Mon = "Peanut Scout", Pos = CFrame.new(-2104, 38, -10192)},
    {Level = {2250, 2274}, Quest = "NutsIslandQuest", QuestNum = 1, Mon = "Peanut President", Pos = CFrame.new(-2150, 38, -10520)},
    {Level = {2275, 2299}, Quest = "NutsIslandQuest", QuestNum = 2, Mon = "Ice Cream Chef", Pos = CFrame.new(-820, 65, -10965)},
    {Level = {2300, 2324}, Quest = "IceCreamIslandQuest", QuestNum = 1, Mon = "Ice Cream Commander", Pos = CFrame.new(-558, 126, -10965)},
    {Level = {2325, 2349}, Quest = "CakeQuest1", QuestNum = 1, Mon = "Cookie Crafter", Pos = CFrame.new(-2374, 38, -12142)},
    {Level = {2350, 2374}, Quest = "CakeQuest2", QuestNum = 1, Mon = "Cake Guard", Pos = CFrame.new(-1928, 38, -12030)},
    {Level = {2375, 2399}, Quest = "CakeQuest2", QuestNum = 2, Mon = "Baking Staff", Pos = CFrame.new(-1927, 38, -12983)},
    {Level = {2400, 2424}, Quest = "CakeQuest2", QuestNum = 3, Mon = "Head Baker", Pos = CFrame.new(-2251, 52, -12373)},
    {Level = {2425, 2449}, Quest = "ChocQuest1", QuestNum = 1, Mon = "Chocolate Bar Battler", Pos = CFrame.new(620, 78, -12581)},
    {Level = {2450, 2474}, Quest = "ChocQuest2", QuestNum = 1, Mon = "Sweet Thief", Pos = CFrame.new(142, 78, -12847)},
    {Level = {2475, 2499}, Quest = "ChocQuest2", QuestNum = 2, Mon = "Candy Rebel", Pos = CFrame.new(151, 78, -12404)},
    {Level = {2500, 2550}, Quest = "ChocQuest2", QuestNum = 3, Mon = "Cocoa Warrior", Pos = CFrame.new(117, 78, -12319)}
}

-- =============================================
-- GET QUEST بناءً على اللفل الحالي
-- =============================================
function GetCurrentQuest()
    local level = LocalPlayer.Data.Level.Value
    
    for i, data in pairs(QuestData) do
        if level >= data.Level[1] and level <= data.Level[2] then
            return data
        end
    end
    
    -- إذا ما لقى، يرجع أول كويست
    return QuestData[1]
end

-- =============================================
-- TELEPORT FUNCTION
-- =============================================
function TPTo(pos)
    local Distance = (pos.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    
    if Distance < 250 then
        LocalPlayer.Character.HumanoidRootPart.CFrame = pos
    else
        local tween = game:GetService("TweenService"):Create(
            LocalPlayer.Character.HumanoidRootPart,
            TweenInfo.new(Distance / 300, Enum.EasingStyle.Linear),
            {CFrame = pos}
        )
        tween:Play()
        tween.Completed:Wait()
    end
end

-- =============================================
-- EQUIP WEAPON
-- =============================================
function EquipWeapon(weapon)
    pcall(function()
        local tool = LocalPlayer.Backpack:FindFirstChild(weapon) or LocalPlayer.Character:FindFirstChild(weapon)
        if tool and not LocalPlayer.Character:FindFirstChild(weapon) then
            LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end)
end

-- =============================================
-- FAST ATTACK
-- =============================================
spawn(function()
    while wait() do
        if getgenv().Settings.FastAttack then
            pcall(function()
                repeat wait()
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                until not getgenv().Settings.FastAttack
            end)
        end
    end
end)

-- =============================================
-- AUTO FARM MAIN LOOP
-- =============================================
spawn(function()
    while wait() do
        if getgenv().Settings.AutoFarm then
            pcall(function()
                local quest = GetCurrentQuest()
                local QuestTitle = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                
                -- ✅ أخذ الكويست
                if QuestTitle and not string.find(QuestTitle.Container.QuestTitle.Title.Text, quest.Mon) then
                    TPTo(quest.Pos)
                    wait(0.5)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", quest.Quest, quest.QuestNum)
                end
                
                -- ✅ البحث عن المونستر
                for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v.Name == quest.Mon and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                            wait()
                            
                            -- تفعيل الهاكي
                            if getgenv().Settings.AutoHaki and not LocalPlayer.Character:FindFirstChild("HasBuso") then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                            end
                            
                            -- تجهيز السلاح
                            EquipWeapon(getgenv().Settings.SelectedWeapon)
                            
                            -- الانتقال للمونستر
                            LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().Settings.FarmDistance, 0)
                            
                            -- جلب المونسترات
                            if getgenv().Settings.BringMobs then
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -getgenv().Settings.FarmDistance)
                                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                            end
                            
                        until not getgenv().Settings.AutoFarm or not v.Parent or v.Humanoid.Health <= 0 or not QuestTitle or not string.find(QuestTitle.Container.QuestTitle.Title.Text, quest.Mon)
                    end
                end
            end)
        end
    end
end)

-- =============================================
-- UI SETUP
-- =============================================

Tabs.Farm:AddParagraph({
    Title = "Current Level",
    Content = "Level: " .. LocalPlayer.Data.Level.Value .. " / 2550"
})

spawn(function()
    while wait(1) do
        pcall(function()
            Tabs.Farm:FindFirstChild("Current Level").Content = "Level: " .. LocalPlayer.Data.Level.Value .. " / 2550"
        end)
    end
end)

Tabs.Farm:AddDropdown("WeaponSelect", {
    Title = "Select Weapon",
    Values = {"Combat", "Melee", "Sword", "Blox Fruit"},
    Multi = false,
    Default = 1,
    Callback = function(Value)
        getgenv().Settings.SelectedWeapon = Value
    end
})

Tabs.Farm:AddSection("Auto Farm Settings")

Tabs.Farm:AddToggle("AutoFarmLevel", {
    Title = "Auto Farm Level (All Levels)",
    Description = "From Level 1 to 2550",
    Default = false,
    Callback = function(Value)
        getgenv().Settings.AutoFarm = Value
        if Value then
            Fluent:Notify({
                Title = "Vortex Hub",
                Content = "Auto Farm Started! Current Level: " .. LocalPlayer.Data.Level.Value,
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "Vortex Hub",
                Content = "Auto Farm Stopped!",
                Duration = 3
            })
        end
    end
})

Tabs.Farm:AddToggle("FastAttack", {
    Title = "Fast Attack",
    Default = true,
    Callback = function(Value)
        getgenv().Settings.FastAttack = Value
    end
})

Tabs.Farm:AddToggle("BringMobs", {
    Title = "Bring Mobs",
    Description = "Pull enemies to you",
    Default = true,
    Callback = function(Value)
        getgenv().Settings.BringMobs = Value
    end
})

Tabs.Farm:AddToggle("AutoHaki", {
    Title = "Auto Haki (Buso)",
    Default = true,
    Callback = function(Value)
        getgenv().Settings.AutoHaki = Value
    end
})

Tabs.Farm:AddSlider("FarmDistance", {
    Title = "Farm Distance",
    Description = "Distance from enemy",
    Default = 25,
    Min = 15,
    Max = 50,
    Rounding = 0,
    Callback = function(Value)
        getgenv().Settings.FarmDistance = Value
    end
})

-- =============================================
-- AUTO STATS
-- =============================================

Tabs.Stats:AddSection("Auto Stats Distribution")

local StatSettings = {
    Melee = false,
    Defense = false,
    Sword = false,
    Gun = false,
    Fruit = false
}

Tabs.Stats:AddToggle("AutoMelee", {
    Title = "Auto Melee",
    Default = false,
    Callback = function(Value)
        StatSettings.Melee = Value
    end
})

Tabs.Stats:AddToggle("AutoDefense", {
    Title = "Auto Defense",
    Default = false,
    Callback = function(Value)
        StatSettings.Defense = Value
    end
})

Tabs.Stats:AddToggle("AutoSword", {
    Title = "Auto Sword",
    Default = false,
    Callback = function(Value)
        StatSettings.Sword = Value
    end
})

Tabs.Stats:AddToggle("AutoGun", {
    Title = "Auto Gun",
    Default = false,
    Callback = function(Value)
        StatSettings.Gun = Value
    end
})

Tabs.Stats:AddToggle("AutoFruit", {
    Title = "Auto Devil Fruit",
    Default = false,
    Callback = function(Value)
        StatSettings.Fruit = Value
    end
})

-- Auto Stats Loop
spawn(function()
    while wait(0.1) do
        pcall(function()
            if StatSettings.Melee then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
            end
            if StatSettings.Defense then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end
            if StatSettings.Sword then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
            end
            if StatSettings.Gun then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
            end
            if StatSettings.Fruit then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
            end
        end)
    end
end)

-- =============================================
-- MISC
-- =============================================

Tabs.Misc:AddButton({
    Title = "FPS Boost",
    Description = "Remove lag and boost performance",
    Callback = function()
        for i, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            end
        end
        Fluent:Notify({Title = "System", Content = "FPS Boost Applied!", Duration = 3})
    end
})

Tabs.Misc:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

Tabs.Misc:AddButton({
    Title = "Server Hop",
    Callback = function()
        local PlaceId = game.PlaceId
        local AllServers = {}
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        
        if success then
            for i, v in pairs(result.data) do
                if type(v) == "table" and v.playing ~= nil and v.id ~= game.JobId then
                    table.insert(AllServers, v.id)
                end
            end
            
            if #AllServers > 0 then
                TeleportService:TeleportToPlaceInstance(PlaceId, AllServers[math.random(1, #AllServers)])
            end
        end
    end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:BuildConfigSection(Tabs.Misc)
InterfaceManager:BuildInterfaceSection(Tabs.Misc)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Vortex Hub Loaded",
    Content = "Current Level: " .. LocalPlayer.Data.Level.Value .. " | Ready to farm!",
    Duration = 6
})

print("✅ Vortex Hub Loaded | Auto Farm ALL Levels (1-2550)")
