--[[
    🔱 VORTEX HUB - LOADER 🔱
    Based on Redz Hub V5
]]--

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer

-- =============================================
-- 🔒 ANTI-DUPLICATE
-- =============================================
if getgenv().VortexHubLoaded then
    warn("⚠️ Vortex Hub already loaded!")
    return
end
getgenv().VortexHubLoaded = true

-- =============================================
-- 📊 CONFIGURATION
-- =============================================
local Config = {
    -- استخدم ملفات Redz الأصلية (لأنها شغالة)
    UseOriginal = true,
    
    -- أو استخدم ملفاتك (بعد ما تحمّل كل الملفات)
    GitHub = {
        Owner = "aq05390533-art",
        Repo = "vortexhub",
        Branch = "main"
    }
}

-- =============================================
-- 🔗 LOAD FROM ORIGINAL SOURCE
-- =============================================
if Config.UseOriginal then
    print("📡 Loading from Official Redz Hub...")
    
    -- حمّل من المصدر الأصلي (يشتغل 100%)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.lua"
        ))()
    end)
    
    if success then
        print("✅ Vortex Hub loaded successfully!")
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "✅ Vortex Hub";
            Text = "Loaded successfully!";
            Duration = 5;
        })
    else
        warn("❌ Failed to load")
        warn("Error: " .. tostring(result))
    end
    
-- =============================================
-- 🔗 LOAD FROM YOUR REPO
-- =============================================
else
    print("📡 Loading from custom repo...")
    
    local Url = string.format(
        "https://raw.githubusercontent.com/%s/%s/%s/main.lua",
        Config.GitHub.Owner,
        Config.GitHub.Repo,
        Config.GitHub.Branch
    )
    
    local success, result = pcall(function()
        return loadstring(game:HttpGet(Url))()
    end)
    
    if success then
        print("✅ Custom version loaded!")
    else
        warn("❌ Failed, loading official version...")
        
        -- Fallback للنسخة الأصلية
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.lua"
        ))()
    end
end
