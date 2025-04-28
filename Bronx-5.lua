-- Cargar librería de menú
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Flags para activar o no
local Flags = {
    AutoFarm = false,
    AutoRob = false,
    AutoCollect = false,
    AutoSell = false,
    Aimbot = false,
}

-- Funciones principales
local function getClosestEnemy()
    local closest, shortest = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= LocalPlayer.Name then
            local dist = (v.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            if dist < shortest and v.Humanoid.Health > 0 then
                shortest = dist
                closest = v
            end
        end
    end
    return closest
end

local function findObjectByName(keywords)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") then
            for _, word in pairs(keywords) do
                if v.Name:lower():find(word) then
                    return v
                end
            end
        end
    end
    return nil
end

-- RunService para manejar todo en un solo render step (super rápido)
RunService.RenderStepped:Connect(function()
    if Flags.AutoFarm then
        local target = getClosestEnemy()
        if target then
            HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
        end
    end

    if Flags.AutoRob then
        local atmOrBank = findObjectByName({"atm", "bank"})
        if atmOrBank then
            HumanoidRootPart.CFrame = atmOrBank.CFrame * CFrame.new(0,2,0)
            local click = atmOrBank:FindFirstChildWhichIsA("ClickDetector")
            if click then
                fireclickdetector(click)
            end
        end
    end

    if Flags.AutoCollect then
        local item = findObjectByName({"bag", "drop", "gelatin", "item"})
        if item then
            HumanoidRootPart.CFrame = item.CFrame * CFrame.new(0,2,0)
        end
    end

    if Flags.AutoSell then
        local sellZone = findObjectByName({"sell", "vendedor", "trade"})
        if sellZone then
            HumanoidRootPart.CFrame = sellZone.CFrame * CFrame.new(0,2,0)
        end
    end

    if Flags.Aimbot then
        local enemy = getClosestEnemy()
        if enemy then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, enemy.HumanoidRootPart.Position)
        end
    end
end)

-- Menú principal
local Window = OrionLib:MakeWindow({Name = "South Bronx PRO Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "SouthBronxPROHub"})

-- Tabs
local FarmTab = Window:MakeTab({Name = "Autofarm", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- Contenido de los Tabs
FarmTab:AddToggle({
	Name = "AutoFarm NPCs",
	Default = false,
	Callback = function(Value)
		Flags.AutoFarm = Value
	end
})

FarmTab:AddToggle({
	Name = "Auto Rob Banks/ATMs",
	Default = false,
	Callback = function(Value)
		Flags.AutoRob = Value
	end
})

MiscTab:AddToggle({
	Name = "Auto Collect Items",
	Default = false,
	Callback = function(Value)
		Flags.AutoCollect = Value
	end
})

MiscTab:AddToggle({
	Name = "Auto Sell Items",
	Default = false,
	Callback = function(Value)
		Flags.AutoSell = Value
	end
})

MiscTab:AddToggle({
	Name = "Aimbot (Lock Closest Enemy)",
	Default = false,
	Callback = function(Value)
		Flags.Aimbot = Value
	end
})

PlayerTab:AddSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 200,
	Default = 16,
	Increment = 1,
	Callback = function(Value)
		Character.Humanoid.WalkSpeed = Value
	end
})

-- Notificación
OrionLib:MakeNotification({
	Name = "South Bronx PRO Hub",
	Content = "Menu cargado. Todas las funciones activas al instante!",
	Image = "rbxassetid://4483345998",
	Time = 5
})
