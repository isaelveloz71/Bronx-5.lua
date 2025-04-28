-- Menú manual para South Bronx (sin Orion)
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local AutoFarm = Instance.new("TextButton")
local AutoRob = Instance.new("TextButton")
local AutoCollect = Instance.new("TextButton")
local AutoSell = Instance.new("TextButton")
local Aimbot = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 200, 0, 300)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local buttons = {AutoFarm, AutoRob, AutoCollect, AutoSell, Aimbot}
local names = {"AutoFarm NPCs", "AutoRob", "AutoCollect", "AutoSell", "Aimbot"}
local toggles = {false, false, false, false, false}

for i,btn in ipairs(buttons) do
	btn.Parent = Frame
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, 5 + (i-1)*45)
	btn.Text = names[i]
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.MouseButton1Click:Connect(function()
		toggles[i] = not toggles[i]
		btn.BackgroundColor3 = toggles[i] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50,50,50)
	end)
end

-- Funciones automáticas
game:GetService("RunService").RenderStepped:Connect(function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if toggles[1] then -- AutoFarm
        for _, npc in pairs(workspace:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                if npc.Humanoid.Health > 0 then
                    root.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
                    break
                end
            end
        end
    end

    if toggles[2] then -- AutoRob
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (obj.Name:lower():find("bank") or obj.Name:lower():find("atm")) then
                root.CFrame = obj.CFrame * CFrame.new(0,2,0)
                local click = obj:FindFirstChildWhichIsA("ClickDetector")
                if click then fireclickdetector(click) end
                break
            end
        end
    end

    if toggles[3] then -- AutoCollect
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (obj.Name:lower():find("bag") or obj.Name:lower():find("drop") or obj.Name:lower():find("gelatin")) then
                root.CFrame = obj.CFrame * CFrame.new(0,2,0)
                break
            end
        end
    end

    if toggles[4] then -- AutoSell
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (obj.Name:lower():find("sell") or obj.Name:lower():find("vendedor") or obj.Name:lower():find("trade")) then
                root.CFrame = obj.CFrame * CFrame.new(0,2,0)
                break
            end
        end
    end

    if toggles[5] then -- Aimbot
        local cam = workspace.CurrentCamera
        for _, npc in pairs(workspace:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, npc.HumanoidRootPart.Position)
                break
            end
        end
    end
end)
