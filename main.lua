--[[
    VORTEX HUB - Redz Style (Mobile UI)
    Exact copy of the image you wanted
]]--

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/RedzLibV2/main/redzlibv2.lua"))()

local Window = Library:MakeWindow({
  Title = "Vortex Hub",
  SubTitle = "by aq05390533",
  SaveFolder = "VortexConfig" -- يحفظ إعداداتك تلقائي
})

print("✅ Vortex Hub Loading...")

-- ==========================================
-- تبويب Farm (زي الصورة بالضبط)
-- ==========================================
local FarmTab = Window:MakeTab({"Farm", "http://www.roblox.com/asset/?id=8353802524"})

-- القائمة المنسدلة حقت السلاح (مهمة جداً زي الصورة)
FarmTab:AddDropdown({
  Name = "Farm Tool",
  Options = {"Melee", "Sword", "Blox Fruit"},
  Default = "Melee",
  Callback = function(Value)
      getgenv().Weapon = Value
  end
})

FarmTab:AddSection({"Auto Farm"})

-- زر الأوتو فارم (Toggle)
FarmTab:AddToggle({
  Name = "Auto Farm Level",
  Default = false,
  Callback = function(Value)
      getgenv().AutoFarm = Value
      if Value then
          -- كود التشغيل
      end
  end
})

FarmTab:AddToggle({
  Name = "Auto Farm Nearest",
  Default = false,
  Callback = function(Value)
      getgenv().FarmNearest = Value
  end
})

FarmTab:AddSection({"Farm Level"})

FarmTab:AddToggle({
  Name = "Sky Phea Farm",
  Default = false,
  Callback = function(Value)
      -- Code here
  end
})

FarmTab:AddToggle({
  Name = "Player Hunter Quest",
  Default = false,
  Callback = function(Value)
      -- Code here
  end
})

FarmTab:AddSection({"Chest"})

FarmTab:AddToggle({
  Name = "Auto Chest <Tween>",
  Default = false,
  Callback = function(Value)
      getgenv().AutoChest = Value
  end
})

-- ==========================================
-- تبويب Stats
-- ==========================================
local StatsTab = Window:MakeTab({"Stats", "http://www.roblox.com/asset/?id=8353801064"})

StatsTab:AddSection({"Stats Settings"})

StatsTab:AddToggle({
  Name = "Auto Stats (Melee/Def/Sword)",
  Default = false,
  Callback = function(Value)
      getgenv().AutoStats = Value
  end
})

-- ==========================================
-- تبويب Teleport
-- ==========================================
local TeleportTab = Window:MakeTab({"Teleport", "http://www.roblox.com/asset/?id=8353800624"})

TeleportTab:AddDropdown({
  Name = "Select Island",
  Options = {"Jungle", "Pirate Village", "Marine Fortress", "Skylands", "Second Sea", "Third Sea"},
  Default = "Jungle",
  Callback = function(Value)
      -- Teleport code
  end
})

TeleportTab:AddButton({
  Name = "Teleport Now",
  Callback = function()
      -- Teleport function
  end
})

-- ==========================================
-- تبويب Misc
-- ==========================================
local MiscTab = Window:MakeTab({"Misc", "http://www.roblox.com/asset/?id=8353803144"})

MiscTab:AddButton({
  Name = "FPS Boost",
  Callback = function()
      for i,v in pairs(game:GetDescendants()) do
          if v:IsA("Part") then v.Material = "Plastic" end
      end
  end
})

MiscTab:AddButton({
  Name = "Server Hop",
  Callback = function()
      -- Server hop code
  end
})

-- بداية السكربت
Library:Init()
