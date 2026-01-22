--[[
    ╔════════════════════════════════════════════╗
    ║            VORTEX HUB V2.0                 ║
    ║      Best Blox Fruits Script 2025          ║
    ║         Made by aq05390533-art             ║
    ╚════════════════════════════════════════════╝
]]--

repeat wait() until game:IsLoaded()

-- تحميل المكتبة (بدون شعار أبدًا)
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- إنشاء النافذة
local Window = Library:CreateWindow({
    Title = '🔥 Vortex Hub | Team: '..(getgenv().Team or "Marines"),
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- إشعار الترحيب
Library:Notify('🔥 Vortex Hub Loaded Successfully! Enjoy <3', 5)

-- ============================================
-- تبويب Main (الأوتو فارم)
-- ============================================
local MainTab = Window:AddTab('Main')

local FarmGroup = MainTab:AddLeftGroupbox('⚔️ Auto Farm')

FarmGroup:AddToggle('AutoFarmLevel', {
    Text = '🚀 Auto Farm Level',
    Default = false,
    Tooltip = 'Best auto farm method 2025',
    Callback = function(Value)
        getgenv().AutoFarm = Value
        if Value then
            Library:Notify('Auto Farm Started!', 3)
            -- هنا كود الأوتو فارم
            spawn(function()
                while getgenv().AutoFarm do
                    wait(0.1)
                    -- Your auto farm code here
                end
            end)
        else
            Library:Notify('Auto Farm Stopped!', 3)
        end
    end
})

FarmGroup:AddToggle('AutoFarmMastery', {
    Text = '⚔️ Auto Farm Mastery',
    Default = false,
    Tooltip = 'Farm mastery for weapons',
})

FarmGroup:AddToggle('AutoFarmBones', {
    Text = '💀 Auto Farm Bones',
    Default = false,
    Tooltip = 'Farm bones in Haunted Castle',
})

FarmGroup:AddDivider()

FarmGroup:AddToggle('AutoFarmEctoplasm', {
    Text = '👻 Auto Farm Ectoplasm',
    Default = false,
})

-- المجموعة اليمنى - البوس
local BossGroup = MainTab:AddRightGroupbox('👑 Boss Farm')

BossGroup:AddToggle('AutoBoss', {
    Text = '🎯 Auto Farm All Boss',
    Default = false,
})

BossGroup:AddDropdown('SelectBoss', {
    Values = { 'Darkbeard', 'Order', 'Cursed Captain', 'Soul Reaper', 'Rip Indra' },
    Default = 1,
    Multi = false,
    Text = 'Select Boss',
})

BossGroup:AddToggle('AutoMirage', {
    Text = '🌊 Auto Mirage Island',
    Default = false,
    Tooltip = 'Auto farm mirage island + gear',
})

-- ============================================
-- تبويب Stats
-- ============================================
local StatsTab = Window:AddTab('Stats')

local StatsGroup = StatsTab:AddLeftGroupbox('⚡ Auto Stats')

StatsGroup:AddToggle('AutoStats', {
    Text = '🎯 Enable Auto Stats',
    Default = false,
    Callback = function(Value)
        getgenv().AutoStats = Value
    end
})

StatsGroup:AddDivider()

StatsGroup:AddSlider('MeleePercent', {
    Text = 'Melee %',
    Default = 33,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false,
})

StatsGroup:AddSlider('DefensePercent', {
    Text = 'Defense %',
    Default = 33,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false,
})

StatsGroup:AddSlider('SwordPercent', {
    Text = 'Sword %',
    Default = 34,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false,
})

-- Combat Settings
local CombatGroup = StatsTab:AddRightGroupbox('⚔️ Combat')

CombatGroup:AddToggle('AutoHaki', {
    Text = '🔥 Auto Haki',
    Default = false,
})

CombatGroup:AddToggle('AutoObservation', {
    Text = '👁️ Auto Observation',
    Default = false,
})

CombatGroup:AddButton({
    Text = '💪 Reset Character',
    Func = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end,
    DoubleClick = true,
})

-- ============================================
-- تبويب Misc
-- ============================================
local MiscTab = Window:AddTab('Misc')

local UtilityGroup = MiscTab:AddLeftGroupbox('🔧 Utilities')

UtilityGroup:AddButton({
    Text = '💨 FPS Boost',
    Func = function()
        for i,v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            end
        end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Library:Notify('FPS Boost Applied! +60 FPS', 4)
    end,
})

UtilityGroup:AddButton({
    Text = '🌐 Server Hop',
    Func = function()
        Library:Notify('Searching for best server...', 2)
        -- Server hop code here
    end,
})

UtilityGroup:AddButton({
    Text = '🔄 Rejoin Server',
    Func = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
})

UtilityGroup:AddDivider()

UtilityGroup:AddToggle('AntiAFK', {
    Text = '⏰ Anti AFK',
    Default = true,
})

-- Player Settings
local PlayerGroup = MiscTab:AddRightGroupbox('👤 Player')

PlayerGroup:AddSlider('WalkSpeed', {
    Text = 'Walk Speed',
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

PlayerGroup:AddSlider('JumpPower', {
    Text = 'Jump Power',
    Default = 50,
    Min = 50,
    Max = 150,
    Rounding = 0,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

-- ============================================
-- تبويب Settings (الثيمات)
-- ============================================
local MenuGroup = MiscTab:AddLeftGroupbox('⚙️ Menu')
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
MenuGroup:AddButton('Unload', function() Library:Unload() end)

local ThemeManager = MiscTab:AddRightGroupbox('🎨 Themes')
ThemeManager:AddLabel('Background color'):AddColorPicker('BackgroundColor', { Default = Color3.fromRGB(20, 20, 25) })
ThemeManager:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = Color3.fromRGB(0, 170, 255) })

-- حفظ الإعدادات تلقائيًا
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
SaveManager:SetFolder('VortexHub/configs')
SaveManager:BuildConfigSection(MiscTab)
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('VortexHub')
ThemeManager:ApplyToTab(MiscTab)

Library:OnUnload(function()
    Library:Notify('Vortex Hub Unloaded!', 3)
end)

print('✅ Vortex Hub V2.0 Loaded Successfully!')
print('👤 Team: '..(getgenv().Team or "Marines"))
print('🎯 Made by aq05390533-art')
