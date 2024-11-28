local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local function regenerateHealth()
    if humanoid.Health < (humanoid.MaxHealth / 2) then
        humanoid.Health = humanoid.MaxHealth
    end
end

humanoid.HealthChanged:Connect(function()
    regenerateHealth()
end)
