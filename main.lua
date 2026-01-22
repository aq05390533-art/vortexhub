--[[
    VORTEX HUB V3 - ANTI-KICK SYSTEM
    Bypass Detection: NoClip + Safe Tween
]]--

-- =============================================
-- ANTI-DETECTION & PROTECTION
-- =============================================
local function ProtectScript()
    if getgenv().VortexLoaded then return end
    getgenv().VortexLoaded = true
    
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if method == "FireServer" or method == "InvokeServer" then
            wait(math.random(5, 15) / 1000)
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
    Title = "Vortex Hub V3 | Anti-Kick",
    SubTitle = "Bypass Anti-Cheat System",
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
-- NOCLIP SYSTEM
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
-- QUEST DATA
-- =============================================
local QuestList = {
    -- ========== FIRST SEA ==========
    {Lvl = {1, 9}, Quest = "BanditQuest1", QuestLvl = 1, Enemy = "Bandit", 
     QuestPos = CFrame.new(1059.37, 16.55, 1550.42),
     MobPos = CFrame.new(1145.45, 16.55, 1550.18)},
     
    {Lvl = {10, 14}, Quest = "JungleQuest", QuestLvl = 1, Enemy = "Monkey", 
     QuestPos = CFrame.new(-1598.09, 35.55, 153.38),
     MobPos = CFrame.new(-1448.51, 49.85, 11.46)},
     
    {Lvl = {15, 29}, Quest = "BuggyQuest1", QuestLvl = 1, Enemy = "Bandit", 
     QuestPos = CFrame.new(-1119.81, 4.79, 3831.37),
     MobPos = CFrame.new(-1145.45, 16.55, 3550.18)},
     
    {Lvl = {30, 39}, Quest = "DesertQuest", QuestLvl = 1, Enemy = "Desert Bandit", 
     QuestPos = CFrame.new(897.03, 6.45, 4388.93),
     MobPos = CFrame.new(932.13, 6.45, 4488.38)},
     
    {Lvl = {60, 74}, Quest = "MarineQuest2", QuestLvl = 1, Enemy = "Chief Petty Officer", 
     QuestPos = CFrame.new(-5039.59, 28.65, 4324.68),
     MobPos = CFrame.new(-4882.69, 22.65, 4255.53)},
     
    {Lvl = {75, 89}, Quest = "AreaQuest", QuestLvl = 1, Enemy = "Sky Bandit", 
     QuestPos = CFrame.new(-4841.83, 717.67, -2623.96),
     MobPos = CFrame.new(-4955.72, 717.67, -2953.18)},
     
    {Lvl = {100, 119}, Quest = "PrisonerQuest", QuestLvl = 1, Enemy = "Prisoner", 
     QuestPos = CFrame.new(5308.93, 1.66, 475.12),
     MobPos = CFrame.new(5411.93, 1.66, 475.12)},
     
    {Lvl = {150, 174}, Quest = "MagmaQuest", QuestLvl = 1, Enemy = "Lava Pirate", 
     QuestPos = CFrame.new(-5234.61, 51.95, -4732.22),
     MobPos = CFrame.new(-5308.29, 51.95, -4890.31)},
     
    -- ========== SECOND SEA ==========
    {Lvl = {1300, 1324}, Quest = "ChocQuest1", QuestLvl = 1, Enemy = "Chocolate Bar Battler", 
     QuestPos = CFrame.new(233.23, 29.88, -12201.23),
     MobPos = CFrame.new(172.23, 29.88, -12305.48)},
     
    {Lvl = {1350, 1374}, Quest = "CocoaQuest", QuestLvl = 1, Enemy = "Cocoa Warrior", 
     QuestPos = CFrame.new(117.91, 73.10, -12319.44),
     MobPos = CFrame.new(58.91, 73.10, -12379.18)},
     
    -- ========== THIRD SEA ==========
    {Lvl = {1500, 1524}, Quest = "Area1Quest", QuestLvl = 1, Enemy = "Pirate Millionaire", 
     QuestPos = CFrame.new(-288.61, 43.82, 5579.86),
     MobPos = CFrame.new(-435.68, 43.82, 5583.66)},
     
    {Lvl = {1525, 1574}, Quest = "Area1Quest", QuestLvl = 2, Enemy = "Pistol Billionaire", 
     QuestPos = CFrame.new(-295.35, 43.82, 5559.84),
     MobPos = CFrame.new(-379.14, 43.82, 5984.03)},
     
    {Lvl = {1575, 1599}, Quest = "Area2Quest", QuestLvl = 1, Enemy = "Dragon Crew Warrior", 
     QuestPos = CFrame.new(5834.14, 51.48, -1103.13),
     MobPos = CFrame.new(6241.59, 51.48, -1243.35)},
     
    {Lvl = {1600, 1624}, Quest = "Area2Quest", QuestLvl = 2, Enemy = "Dragon Crew Archer", 
     QuestPos = CFrame.new(6483.28, 383.14, 139.45),
     MobPos = CFrame.new(6594.73, 383.14, 139.45)},
     
    {Lvl = {1625, 1649}, Quest = "MarineTreeIsland", QuestLvl = 1, Enemy = "Female Islander", 
     QuestPos = CFrame.new(5243.14, 601.65, 344.59),
     MobPos = CFrame.new(5315.19, 601.65, 244.03)},
     
    {Lvl = {1650, 1699}, Quest = "MarineTreeIsland", QuestLvl = 2, Enemy = "Giant Islander", 
     QuestPos = CFrame.new(5658.15, 601.65, -57.35),
     MobPos = CFrame.new(5347.41, 601.65, -106.28)},
     
    {Lvl = {1700, 1724}, Quest = "ForgottenQuest", QuestLvl = 1, Enemy = "Marine Commodore", 
     QuestPos = CFrame.new(-2850.20, 72.99, -3300.90),
     MobPos = CFrame.new(-2850.20, 72.99, -3208.35)},
     
    {Lvl = {1725, 1774}, Quest = "ForgottenQuest", QuestLvl = 2, Enemy = "Marine Rear Admiral", 
     QuestPos = CFrame.new(-5545.12, 28.65, -7755.08),
     MobPos = CFrame.new(-5636.09, 28.65, -7755.08)},
     
    {Lvl = {1775, 1799}, Quest = "DeepForestIsland", QuestLvl = 1, Enemy = "Mythological Pirate", 
     QuestPos = CFrame.new(-13234.57, 331.58, -7625.78),
     MobPos = CFrame.new(-13508.62, 331.58, -7925.48)},
     
    {Lvl = {1800, 1849}, Quest = "DeepForestIsland2", QuestLvl = 1, Enemy = "Jungle Pirate", 
     QuestPos = CFrame.new(-11975.96, 331.73, -10620.03),
     MobPos = CFrame.new(-12121.27, 331.73, -10654.84)},
     
    {Lvl = {1850, 1899}, Quest = "DeepForestIsland3", QuestLvl = 1, Enemy = "Musketeer Pirate", 
     QuestPos = CFrame.new(-13283.43, 386.90, -9902.06),
     MobPos = CFrame.new(-13388.43, 386.90, -9902.06)},
     
    {Lvl = {1900, 1924}, Quest = "PiratePortQuest", QuestLvl = 1, Enemy = "Pirate", 
     QuestPos = CFrame.new(-6240.98, 38.30, 5577.57),
     MobPos = CFrame.new(-6305.98, 38.30, 5577.57)},
     
    {Lvl = {1925, 1974}, Quest = "PiratePortQuest", QuestLvl = 2, Enemy = "Ship Deckhand", 
     QuestPos = CFrame.new(-6508.65, 39.00, 5736.06),
     MobPos = CFrame.new(-6508.65, 39.00, 5836.06)},
     
    {Lvl = {1975, 1999}, Quest = "AmazonQuest", QuestLvl = 1, Enemy = "Amazon Warrior", 
     QuestPos = CFrame.new(5497.07, 51.48, -1800.01),
     MobPos = CFrame.new(5386.07, 51.48, -1800.01)},
     
    {Lvl = {2000, 2024}, Quest = "AmazonQuest", QuestLvl = 2, Enemy = "Amazon Archer", 
     QuestPos = CFrame.new(5251.51, 51.61, -1655.34),
     MobPos = CFrame.new(5145.51, 51.61, -1655.34)},
     
    -- ========== HAUNTED CASTLE ==========
    {Lvl = {2025, 2049}, Quest = "HauntedQuest1", QuestLvl = 1, Enemy = "Living Zombie", 
     QuestPos = CFrame.new(-9479.43, 141.22, 5566.09),
     MobPos = CFrame.new(-10144.07, 138.65, 5975.96)},
     
    {Lvl = {2050, 2074}, Quest = "HauntedQuest1", QuestLvl = 2, Enemy = "Demonic Soul", 
     QuestPos = CFrame.new(-9515.62, 172.13, 6078.89),
     MobPos = CFrame.new(-9712.03, 172.13, 6144.49)},
     
    {Lvl = {2075, 2099}, Quest = "HauntedQuest2", QuestLvl = 1, Enemy = "Posessed Mummy", 
     QuestPos = CFrame.new(-9546.99, 172.13, 6079.08),
     MobPos = CFrame.new(-9738.99, 172.13, 6079.08)},
     
    {Lvl = {2100, 2124}, Quest = "HauntedQuest2", QuestLvl = 2, Enemy = "Peanut Scout", 
     QuestPos = CFrame.new(-2104.39, 38.10, -10192.54),
     MobPos = CFrame.new(-2188.78, 38.10, -10289.54)},
     
    {Lvl = {2125, 2149}, Quest = "NutsIslandQuest", QuestLvl = 1, Enemy = "Peanut President", 
     QuestPos = CFrame.new(-2150.41, 38.32, -10520.01),
     MobPos = CFrame.new(-1850.41, 38.32, -10520.01)},
     
    {Lvl = {2150, 2199}, Quest = "NutsIslandQuest", QuestLvl = 2, Enemy = "Captain Elephant", 
     QuestPos = CFrame.new(-2188.78, 38.10, -9942.58),
     MobPos = CFrame.new(-2188.78, 38.10, -10042.58)},
     
    {Lvl = {2200, 2224}, Quest = "IceCreamIslandQuest", QuestLvl = 1, Enemy = "Ice Cream Chef", 
     QuestPos = CFrame.new(-820.66, 65.81, -10965.97),
     MobPos = CFrame.new(-641.64, 125.95, -11062.80)},
     
    {Lvl = {2225, 2249}, Quest = "IceCreamIslandQuest", QuestLvl = 2, Enemy = "Ice Cream Commander", 
     QuestPos = CFrame.new(-558.07, 125.95, -10965.98),
     MobPos = CFrame.new(-558.07, 125.95, -11062.80)},
     
    {Lvl = {2250, 2274}, Quest = "CakeQuest1", QuestLvl = 1, Enemy = "Cookie Crafter", 
     QuestPos = CFrame.new(-2021.77, 37.80, -12027.74),
     MobPos = CFrame.new(-2374.47, 37.80, -12142.31)},
     
    {Lvl = {2275, 2299}, Quest = "CakeQuest1", QuestLvl = 2, Enemy = "Cake Guard", 
     QuestPos = CFrame.new(-1570.91, 37.80, -12224.68),
     MobPos = CFrame.new(-1570.91, 37.80, -12424.68)},
     
    {Lvl = {2300, 2324}, Quest = "CakeQuest2", QuestLvl = 1, Enemy = "Baking Staff", 
     QuestPos = CFrame.new(-1927.37, 37.80, -12983.11),
     MobPos = CFrame.new(-1927.37, 37.80, -13083.11)},
     
    {Lvl = {2325, 2349}, Quest = "CakeQuest2", QuestLvl = 2, Enemy = "Head Baker", 
     QuestPos = CFrame.new(-2251.51, 52.25, -12373.53),
     MobPos = CFrame.new(-2251.51, 52.25, -12573.53)},
     
    {Lvl = {2350, 2374}, Quest = "ChocQuest1", QuestLvl = 1, Enemy = "Chocolate Bar Battler", 
     QuestPos = CFrame.new(232.66, 24.82, -12243.20),
     MobPos = CFrame.new(172.23, 29.88, -12305.48)},
     
    {Lvl = {2375, 2399}, Quest = "ChocQuest1", QuestLvl = 2, Enemy = "Sweet Thief", 
     QuestPos = CFrame.new(150.51, 30.69, -12774.61),
     MobPos = CFrame.new(150.51, 30.69, -12874.61)},
     
    {Lvl = {2400, 2424}, Quest = "ChocQuest2", QuestLvl = 1, Enemy = "Candy Rebel", 
     QuestPos = CFrame.new(-12350.91, 332.40, -10507.69),
     MobPos = CFrame.new(-12350.91, 332.40, -10607.69)},
     
    {Lvl = {2425, 2450}, Quest = "ChocQuest2", QuestLvl = 2, Enemy = "Cocoa Warrior", 
     QuestPos = CFrame.new(117.91, 73.10, -12319.44),
     MobPos = CFrame.new(58.91, 73.10, -12379.18)}
}

-- =============================================
-- SAFE TWEEN SYSTEM (NO TELEPORT AT ALL)
-- =============================================
function SafeTween(targetPos, description)
    if not RootPart or not targetPos then return end
    
    EnableNoClip()
    
    local Distance = (targetPos.Position - RootPart.Position).Magnitude
    local Speed = getgenv().Config.TweenSpeed
    
    local tweenInfo = TweenInfo.new(
        Distance / Speed,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = targetPos})
    
    print("🛫 " .. (description or "Traveling") .. " | Distance: " .. math.floor(Distance) .. " studs")
    
    tween:Play()
    tween.Completed:Wait()
    
    wait(0.3)
    DisableNoClip()
end

function TweenToPosition(pos, description)
    SafeTween(pos, description)
end

-- =============================================
-- QUEST & COMBAT FUNCTIONS
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
    
    if CheckQuest(questData.Enemy) then 
        return true
    end
    
    print("📜 Taking Quest: " .. questData.Enemy)
    
    -- الذهاب للـ Quest Giver بشكل طبيعي (Tween)
    TweenToPosition(questData.QuestPos * CFrame.new(0, 5, -5), "Going to Quest NPC")
    wait(1)
    
    -- الاقتراب من الـ NPC (Tween)
    SafeTween(questData.QuestPos * CFrame.new(0, 0, -3), "Approaching NPC")
    wait(0.8)
    
    -- أخذ الكويست
    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData.Quest, questData.QuestLvl)
    wait(1.5)
    
    -- محاولة ثانية لو فشل
    if not CheckQuest(questData.Enemy) then
        SafeTween(questData.QuestPos * CFrame.new(0, 0, -2), "Retry Quest")
        wait(0.5)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData.Quest, questData.QuestLvl)
        wait(1)
    end
    
    if CheckQuest(questData.Enemy) then
        print("✅ Quest Accepted!")
        return true
    else
        print("❌ Quest Failed!")
        return false
    end
end

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
            
            -- خطوة 1: أخذ الكويست
            if not CheckQuest(Quest.Enemy) then
                StopFastAttack()
                print("🎯 Target: " .. Quest.Enemy)
                TakeQuest(Quest)
                wait(2)
                return
            end
            
            -- خطوة 2: البحث عن العدو
            local Enemy = nil
            for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                if mob.Name == Quest.Enemy and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    Enemy = mob
                    break
                end
            end
            
            -- خطوة 3: القتال
            if Enemy and Enemy:FindFirstChild("HumanoidRootPart") then
                EnableHaki()
                EquipWeapon(getgenv().Config.SelectedWeapon)
                StartFastAttack()
                
                if RootPart then
                    RootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().Config.DistanceFromMob, 0)
                    Humanoid.AutoRotate = false
                    RootPart.CFrame = CFrame.new(RootPart.Position, Enemy.HumanoidRootPart.Position)
                end
                
                BringMob(Enemy)
            else
                StopFastAttack()
                if Quest.MobPos then
                    print("🔍 Searching for mobs...")
                    TweenToPosition(Quest.MobPos, "Going to Mob Spawn")
                    wait(3)
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
    DisableNoClip()
    if Humanoid then Humanoid.AutoRotate = true end
end

-- =============================================
-- UI SETUP
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
        local Quest = GetQuestData()
        Fluent:Notify({
            Title = "Vortex Hub", 
            Content = "Farming: " .. Quest.Enemy, 
            Duration = 5
        })
    else
        StopFarm()
        Fluent:Notify({Title = "Vortex Hub", Content = "Farm Stopped", Duration = 3})
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

Tabs.Misc:AddButton({
    Title = "Remove Fog",
    Callback = function()
        game:GetService("Lighting").FogEnd = 100000
        Fluent:Notify({Title = "System", Content = "Fog Removed!", Duration = 3})
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Vortex Hub V3",
    Content = "Safe Tween System Loaded! Level: " .. Player.Data.Level.Value,
    Duration = 5
})

print("✅ Vortex Hub V3 | Safe Tween System | Level: " .. Player.Data.Level.Value)
