--[[
    VORTEX HUB - Premium UI
    Auto Farm Level WORKING
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

getgenv().Settings = {
    AutoFarm = false,
    SelectedWeapon = "Melee",
    FastAttack = true,
    AutoHaki = true,
    BringMobs = true
}

-- =============================================
-- FUNCTIONS
-- =============================================

-- Anti AFK
LocalPlayer.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Get Current Quest
function GetQuest()
    local level = LocalPlayer.Data.Level.Value
    
    if level >= 1 and level <= 9 then
        return {
            QuestName = "BanditQuest1",
            Mon = "Bandit",
            LevelReq = 1,
            NameMon = "Bandit"
        }
    elseif level >= 10 and level <= 14 then
        return {
            QuestName = "JungleQuest",
            Mon = "Monkey",
            LevelReq = 10,
            NameMon = "Monkey"
        }
    elseif level >= 15 and level <= 29 then
        return {
            QuestName = "BuggyQuest1",
            Mon = "Pirate",
            LevelReq = 15,
            NameMon = "Pirate"
        }
    elseif level >= 30 and level <= 39 then
        return {
            QuestName = "DesertQuest",
            Mon = "Desert Bandit",
            LevelReq = 30,
            NameMon = "Desert Bandit"
        }
    elseif level >= 40 and level <= 59 then
        return {
            QuestName = "SnowQuest",
            Mon = "Snowman",
            LevelReq = 40,
            NameMon = "Snowman"
        }
    elseif level >= 60 and level <= 74 then
        return {
            QuestName = "MarineQuest2",
            Mon = "Chief Petty Officer",
            LevelReq = 60,
            NameMon = "Chief Petty Officer"
        }
    elseif level >= 75 and level <= 99 then
        return {
            QuestName = "AreaQuest",
            Mon = "Sky Bandit",
            LevelReq = 75,
            NameMon = "Sky Bandit"
        }
    elseif level >= 100 and level <= 119 then
        return {
            QuestName = "PrisonQuest",
            Mon = "Prisoner",
            LevelReq = 100,
            NameMon = "Prisoner"
        }
    elseif level >= 120 and level <= 149 then
        return {
            QuestName = "ColosseumQuest",
            Mon = "Gladiator",
            LevelReq = 120,
            NameMon = "Gladiator"
        }
    elseif level >= 150 and level <= 174 then
        return {
            QuestName = "MagmaQuest",
            Mon = "Lava Pirate",
            LevelReq = 150,
            NameMon = "Lava Pirate"
        }
    else
        return {
            QuestName = "BanditQuest1",
            Mon = "Bandit",
            LevelReq = 1,
            NameMon = "Bandit"
        }
    end
end

-- Equip Weapon
function EquipWeapon(weapon)
    local tool = LocalPlayer.Backpack:FindFirstChild(weapon) or LocalPlayer.Character:FindFirstChild(weapon)
    if tool and tool:IsA("Tool") then
        LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end

-- Attack Function
function Attack()
    local ac = CombatFrameworkR.activeController
    if ac and ac.equipped then
        for i = 1, 1 do
            local bladehit = ac.hitboxMagnitude and ac.hitboxMagnitude or 55
            local args = {
                p0 = bladehit,
                p1 = require(game.ReplicatedStorage.CombatFramework.RigLib),
                p2 = CombatFrameworkR.currentWeaponModel.Name,
                p3 = (require(game.ReplicatedStorage.CombatFramework.CombatFramework)).GetCurrentCameraMode()
            }
            game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange", args.p2)
            game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", args.p0, args.p1, args.p3)
        end
    end
end

-- Auto Farm Function
spawn(function()
    while wait() do
        if getgenv().Settings.AutoFarm then
            pcall(function()
                local quest = GetQuest()
                local QuestTitle = LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                
                -- Take Quest
                if not string.find(QuestTitle, quest.NameMon) then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", quest.QuestName, 1)
                end
                
                -- Find and Attack Mobs
                for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v.Name == quest.Mon and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                            wait()
                            
                            -- Teleport to Mob
                            LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                            
                            -- Auto Haki
                            if getgenv().Settings.AutoHaki then
                                if not LocalPlayer.Character:FindFirstChild("HasBuso") then
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                                end
                            end
                            
                            -- Equip Weapon
                            EquipWeapon(getgenv().Settings.SelectedWeapon)
                            
                            -- Attack
                            if getgenv().Settings.FastAttack then
                                Attack()
                            end
                            
                            -- Bring Mob
                            if getgenv().Settings.BringMobs then
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
                            end
                            
                        until not getgenv().Settings.AutoFarm or not v.Parent or v.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end
end)

-- =============================================
-- UI TABS
-- =============================================

Tabs.Farm:AddDropdown("WeaponSelect", {
    Title = "Select Weapon",
    Values = {"Combat", "Melee", "Sword"},
    Multi = false,
    Default = 1,
    Callback = function(Value)
        getgenv().Settings.SelectedWeapon = Value
    end
})

Tabs.Farm:AddSection("Auto Farm")

Tabs.Farm:AddToggle("AutoFarmLevel", {
    Title = "Auto Farm Level",
    Description = "Fastest method to max level",
    Default = false,
    Callback = function(Value)
        getgenv().Settings.AutoFarm = Value
        if Value then
            Fluent:Notify({
                Title = "Vortex Hub",
                Content = "Auto Farm Started!",
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
    Default = true,
    Callback = function(Value)
        getgenv().Settings.BringMobs = Value
    end
})

Tabs.Farm:AddToggle("AutoHaki", {
    Title = "Auto Haki",
    Default = true,
    Callback = function(Value)
        getgenv().Settings.AutoHaki = Value
    end
})

-- Stats Tab
Tabs.Stats:AddToggle("AutoMelee", { 
    Title = "Auto Melee", 
    Default = false,
    Callback = function(Value)
        while Value do
            wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
        end
    end
})

Tabs.Stats:AddToggle("AutoDefense", { 
    Title = "Auto Defense", 
    Default = false,
    Callback = function(Value)
        while Value do
            wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
        end
    end
})

-- Misc
Tabs.Misc:AddButton({
    Title = "FPS Boost",
    Callback = function()
        for i,v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            end
        end
        Fluent:Notify({Title = "System", Content = "FPS Boosted!", Duration = 3})
    end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:BuildConfigSection(Tabs.Misc)
InterfaceManager:BuildInterfaceSection(Tabs.Misc)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Vortex Hub",
    Content = "Loaded Successfully!",
    Duration = 5
})
