local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local player = game.Players.LocalPlayer
local playerHRP = player.Character and player.Character:WaitForChild("HumanoidRootPart")

local Enemies = {
    Bandit = workspace.Enemies:WaitForChild("Bandit")
}

local Window = Rayfield:CreateWindow({
    Name = "Demo GUI",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Powered by Rayfield",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "DemoConfig"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("Main Controls")

MainTab:CreateInput({
    Name = "AutoFarm",
    PlaceholderText = "Ej: Bandit",
    RemoveTextAfterFocusLost = true,
    Callback = function(text)
        local target = Enemies[text]
        if target and target:FindFirstChild("HumanoidRootPart") then
            local EnemyHRP = target.HumanoidRootPart

            Rayfield:Notify({
                Title = "Remember",
                Content = "You must be near that enemy!"
            })

            while task.wait(0.1) do
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then break end
                player.Character.HumanoidRootPart.CFrame = EnemyHRP.CFrame * CFrame.new(0, 3, 0)
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Enemy doesn't exist or is missing HumanoidRootPart."
            })
        end
    end
})

Rayfield:LoadConfiguration()
