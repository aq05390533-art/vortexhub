--[[
    VORTEX HUB - Modern UI 2025
    Powered by Rayfield Interface
]]--

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🔥 Vortex Hub",
   LoadingTitle = "Vortex Hub V2",
   LoadingSubtitle = "by aq05390533-art",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "VortexHub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

Rayfield:Notify({
   Title = "Vortex Hub Loaded",
   Content = "Welcome! Team: "..(getgenv().Team or "Marines"),
   Duration = 6.5,
   Image = 4483362458,
})

-- تبويب Main
local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local Section = MainTab:CreateSection("Auto Farm")

local AutoFarmToggle = MainTab:CreateToggle({
   Name = "🚀 Auto Farm Level",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(Value)
      getgenv().AutoFarm = Value
      if Value then
         Rayfield:Notify({Title = "Auto Farm", Content = "Started!", Duration = 3})
         -- هنا كود الأوتو فارم
      else
         Rayfield:Notify({Title = "Auto Farm", Content = "Stopped!", Duration = 3})
      end
   end,
})

local AutoMasteryToggle = MainTab:CreateToggle({
   Name = "⚔️ Auto Farm Mastery",
   CurrentValue = false,
   Flag = "AutoMastery",
   Callback = function(Value)
      getgenv().AutoMastery = Value
   end,
})

-- تبويب Stats
local StatsTab = Window:CreateTab("⚡ Stats", 4483362458)
local StatsSection = StatsTab:CreateSection("Auto Stats")

local MeleeSlider = StatsTab:CreateSlider({
   Name = "Melee Points",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 33,
   Flag = "MeleeSlider",
   Callback = function(Value)
      getgenv().MeleePercent = Value
   end,
})

local DefenseSlider = StatsTab:CreateSlider({
   Name = "Defense Points",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 33,
   Flag = "DefenseSlider",
   Callback = function(Value)
      getgenv().DefensePercent = Value
   end,
})

local SwordSlider = StatsTab:CreateSlider({
   Name = "Sword Points",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 34,
   Flag = "SwordSlider",
   Callback = function(Value)
      getgenv().SwordPercent = Value
   end,
})

local AutoStatsToggle = StatsTab:CreateToggle({
   Name = "🎯 Auto Stats",
   CurrentValue = false,
   Flag = "AutoStats",
   Callback = function(Value)
      getgenv().AutoStats = Value
   end,
})

-- تبويب Misc
local MiscTab = Window:CreateTab("🔧 Misc", 4483362458)

local FPSBoostButton = MiscTab:CreateButton({
   Name = "💨 FPS Boost",
   Callback = function()
      for i,v in pairs(game:GetDescendants()) do
         if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
         end
      end
      Rayfield:Notify({Title = "FPS Boost", Content = "Applied Successfully!", Duration = 3})
   end,
})

local ServerHopButton = MiscTab:CreateButton({
   Name = "🌐 Server Hop",
   Callback = function()
      Rayfield:Notify({Title = "Server Hop", Content = "Searching...", Duration = 2})
      -- كود السيرفر هوب
   end,
})

local RejoinButton = MiscTab:CreateButton({
   Name = "🔄 Rejoin Server",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
   end,
})
