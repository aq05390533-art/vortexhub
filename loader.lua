--[[
    🔱 VORTEX HUB - STABLE LOADER 🔱
    Fixed Version
]]--

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer

local Player = game.Players.LocalPlayer

-- =============================================
-- 🔒 ANTI-DUPLICATE
-- =============================================
if getgenv().VortexHubLoaded then
    Player:Kick("⚠️ Vortex Hub is already loaded!")
    return
end
getgenv().VortexHubLoaded = true

-- =============================================
-- 📊 SAFE HTTP REQUEST
-- =============================================
local function SafeHttpGet(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        return result
    else
        warn("❌ HTTP Request failed: " .. tostring(result))
        return nil
    end
end

-- =============================================
-- 📊 SAFE LOADSTRING
-- =============================================
local function SafeLoadstring(script)
    if not script then
        return nil, "No script provided"
    end
    
    local success, func = pcall(loadstring, script)
    
    if success and type(func) == "function" then
        return func
    else
        return nil, tostring(func)
    end
end

-- =============================================
-- 🚀 MAIN LOADER
-- =============================================
local function LoadHub()
    print("=" .. string.rep("=", 50))
    print("🔱 VORTEX HUB - LOADING 🔱")
    print("=" .. string.rep("=", 50))
    
    -- List of working URLs (in order of preference)
    local URLs = {
        "https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua",
        "https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.lua",
        "https://raw.githubusercontent.com/aq05390533-art/vortexhub/main/main.lua"
    }
    
    for i, url in ipairs(URLs) do
        print(string.format("📡 Trying source #%d...", i))
        print("📍 URL: " .. url)
        
        local script = SafeHttpGet(url)
        
        if script then
            print("✅ Download successful")
            
            local func, error = SafeLoadstring(script)
            
            if func then
                print("⚙️ Executing script...")
                
                local success, executeError = pcall(func)
                
                if success then
                    print("✅ Vortex Hub loaded successfully!")
                    
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "✅ Vortex Hub";
                        Text = "Loaded successfully from source #" .. i;
                        Duration = 5;
                    })
                    
                    return true
                else
                    warn("❌ Execution failed: " .. tostring(executeError))
                end
            else
                warn("❌ Loadstring failed: " .. tostring(error))
            end
        else
            warn("❌ Download failed")
        end
        
        print("⏭️ Trying next source...")
        task.wait(1)
    end
    
    -- If all sources fail
    warn("=" .. string.rep("=", 50))
    warn("❌ ALL SOURCES FAILED")
    warn("=" .. string.rep("=", 50))
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "❌ Vortex Hub";
        Text = "All sources failed! Check console (F9)";
        Duration = 10;
    })
    
    return false
end

-- =============================================
-- 🎬 EXECUTE
-- =============================================
task.spawn(LoadHub)
