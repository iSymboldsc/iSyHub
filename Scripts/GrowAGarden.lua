--// Fully featured Rayfield GUI Script for Roblox

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "iSy Grow-A-Garden",
    LoadingTitle = "Inventory Tools",
    LoadingSubtitle = "by iSy",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GrowGarden",
        FileName = "InventoryConfig"
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

--// Services and Vars
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local SellPos = CFrame.new(90.08035, 0.98381, 3.02662)

--// Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local AutoTab = Window:CreateTab("Auto", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

--// Functions
local function teleportAndSell(eventName)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local original = hrp.CFrame
        hrp.CFrame = SellPos
        task.wait(0.1)
        local event = ReplicatedStorage:FindFirstChild("GameEvents") and ReplicatedStorage.GameEvents:FindFirstChild(eventName)
        if event then
            event:FireServer()
        end
        task.wait(0.1)
        hrp.CFrame = original
    end
end

--// MainTab Buttons
MainTab:CreateButton({
    Name = "Sell Inventory",
    Callback = function()
        teleportAndSell("Sell_Inventory")
    end,
})

MainTab:CreateButton({
    Name = "Sell Item in Hand",
    Callback = function()
        teleportAndSell("Sell_Item")
    end,
})

MainTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, player)
    end,
})

MainTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local placeId = game.PlaceId
        local function getServers(cursor)
            local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
            if cursor then url = url.."&cursor="..cursor end
            return HttpService:JSONDecode(game:HttpGet(url))
        end

        local cursor
        repeat
            local data = getServers(cursor)
            cursor = data.nextPageCursor

            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
                    return
                end
            end
        until not cursor

        Rayfield:Notify({
            Title = "Server Hop",
            Content = "No available server found.",
            Duration = 5,
            Actions = { Dismiss = { Name = "OK" } }
        })
    end,
})

--// AutoTab Controls
local autoSell = false
local delay = 5

AutoTab:CreateToggle({
    Name = "Auto Sell Inventory",
    CurrentValue = false,
    Callback = function(v)
        autoSell = v
        while autoSell do
            teleportAndSell("Sell_Inventory")
            task.wait(delay)
        end
    end,
})

AutoTab:CreateSlider({
    Name = "Auto Sell Delay (Seconds)",
    Range = {1, 30},
    Increment = 0.1,
    CurrentValue = 5,
    Callback = function(v)
        delay = v
    end,
})

--// MiscTab
MiscTab:CreateParagraph({
    Title = "Credits",
    Content = "Made by iSy"
})

MiscTab:CreateButton({
    Name = "Copy Discord Invite",
    Callback = function()
        setclipboard("https://discord.gg/QaY7QENehU")
        Rayfield:Notify({
            Title = "Copied!",
            Content = "Discord invite copied to clipboard.",
            Duration = 4
        })
    end,
})

--// SettingsTab
SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightControl",
    HoldToInteract = false,
    Callback = function()
        Rayfield:Toggle()
    end,
})
