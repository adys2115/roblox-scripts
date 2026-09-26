-- Steal an Egg GUI
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local AutoStealBtn = Instance.new("TextButton")
local SpeedBtn = Instance.new("TextButton")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "StealEggGUI"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Steal an Egg Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

AutoStealBtn.Parent = MainFrame
AutoStealBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
AutoStealBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
AutoStealBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
AutoStealBtn.Text = "Teleportuj do Jajka"
AutoStealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoStealBtn.TextSize = 14

SpeedBtn.Parent = MainFrame
SpeedBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
SpeedBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
SpeedBtn.Text = "Szybkość (Speed Boost)"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.TextSize = 14

AutoStealBtn.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local targetEgg = nil
    local shortestDist = math.huge

    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("egg") or v.Parent.Name:lower():find("egg")) then
            local dist = (hrp.Position - v.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                targetEgg = v
            end
        end
    end

    if targetEgg then
        hrp.CFrame = targetEgg.CFrame + Vector3.new(0, 3, 0)
    end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = 50
    end
end)
