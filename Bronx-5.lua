--// Cargar la librería del menú
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

--// Crear la ventana del menú
local Window = OrionLib:MakeWindow({Name = "South Bronx Autofarm", HidePremium = false, SaveConfig = true, ConfigFolder = "SouthBronxConfig"})

-- Variables de configuración
local autofarmNPC = false
local autofarmBank = false
local autofarmATM = false

-- Funciones principales
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function tpTo(position)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

local function findNearestNPC()
    local nearest, dist = nil, math.huge
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local magnitude = (npc.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if magnitude < dist then
                nearest = npc
                dist = magnitude
            end
        end
    end
    return nearest
end

local function attackNPC(npc)
    local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
end

local function robATM()
    for _, atm in pairs(workspace.ATMs:GetChildren()) do
        if atm:FindFirstChild("ProximityPrompt") then
            tpTo(atm.Position)
            wait(0.5)
            fireproximityprompt(atm.ProximityPrompt)
            wait(2)
        end
    end
end

local function robBank()
    local bankDoor = workspace:FindFirstChild("BankDoor")
    if bankDoor and bankDoor:FindFirstChild("ProximityPrompt") then
        tpTo(bankDoor.Position)
        wait(0.5)
        fireproximityprompt(bankDoor.ProximityPrompt)
        wait(2)
    end
end

-- Página principal
local MainTab = Window:MakeTab({
    Name = "Autofarm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddToggle({
    Name = "Autofarm NPCs",
    Default = false,
    Callback = function(Value)
        autofarmNPC = Value
    end
})

MainTab:AddToggle({
    Name = "Autofarm ATMs",
    Default = false,
    Callback = function(Value)
        autofarmATM = Value
    end
})

MainTab:AddToggle({
    Name = "Autofarm Banco",
    Default = false,
    Callback = function(Value)
        autofarmBank = Value
    end
})

-- Loop de autofarm
RunService.RenderStepped:Connect(function()
    pcall(function()
        if autofarmNPC then
            local npc = findNearestNPC()
            if npc then
                tpTo(npc.HumanoidRootPart.Position + Vector3.new(0,2,0))
                attackNPC(npc)
            end
        end

        if autofarmATM then
            robATM()
        end

        if autofarmBank then
            robBank()
        end
    end)
end)

OrionLib:Init()

-- Fin del script
