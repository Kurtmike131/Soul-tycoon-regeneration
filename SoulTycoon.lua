-- Server-Side Script (for health regeneration)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local regenEvent = Instance.new("RemoteEvent")
regenEvent.Name = "RegenEvent"
regenEvent.Parent = ReplicatedStorage

regenEvent.OnServerEvent:Connect(function(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        if humanoid.Health < humanoid.MaxHealth / 2 then
            humanoid.Health = humanoid.Health + 1
        end
    end
end)

-- Client-Side Script (for GUI and toggling regen)
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local enabled = false
local regenConnection = nil
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local regenEvent = ReplicatedStorage:WaitForChild("RegenEvent")

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = gui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0, 0, 0, 25)
button.Text = "Enable Regeneration"
button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = frame

local function enableScript()
    if not enabled then
        enabled = true
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        button.Text = "Disable Regeneration"
        
        regenConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if enabled then
                regenEvent:FireServer() -- Call server to regenerate health
            end
        end)
    end
end

local function disableScript()
    if enabled then
        enabled = false
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        button.Text = "Enable Regeneration"
        
        if regenConnection then
            regenConnection:Disconnect()
            regenConnection = nil
        end
    end
end

button.MouseButton1Click:Connect(function()
    if enabled then
        disableScript()
    else
        enableScript()
    end
end)
