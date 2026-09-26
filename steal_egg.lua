-- Steal an Egg GUI z zabezpieczeniem przed powielaniem
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Usuwanie starej wersji GUI przed załadowaniem nowej
local guiName = "StealEggDropdownGUI"
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(guiName) then
    LocalPlayer.PlayerGui[guiName]:Destroy()
end

local BIOME_DATABASE = {
    ["Forest"] = {"kurczak", "chicken", "pies", "dog", "szop", "raccoon", "forest"},
    ["Lake"] = {"zaba", "frog", "kaczatko", "duck", "labedz", "swan", "lewiatan", "leviathan", "lake", "jezioro"},
    ["Desert"] = {"skoczek", "fenek", "fennec", "waz", "snake", "kobra", "cobra", "sfinks", "sphinx", "desert", "pustynia"},
    ["Jungle"] = {"tukan", "toucan", "malpa", "monkey", "krokodyl", "crocodile", "tygrys", "tiger", "jungle", "dzungla"},
    ["Snow"] = {"pingwin", "penguin", "mamut", "mammoth", "yeti", "lodowy smok", "ice dragon", "snow", "snieg"},
    ["Volcano"] = {"gekon", "gecko", "ognisty byk", "fire bull", "cerber", "cerberus", "wulkaniczny smok", "volcano dragon", "volcano", "wulkan"},
    ["Abyss"] = {"rekin", "shark", "orka", "orca", "wieloryb", "whale", "kraken", "abyss", "ocean", "glebiny"},
    ["Prehistoric"] = {"prehistoric", "dino", "dinozaur", "prehistoryczny"},
    ["Cosmic"] = {"jednorozec", "unicorn", "cosmic", "kosmos"},
    ["Cherry Blossom"] = {"cherry", "blossom", "sakura"},
    ["Titan Temple"] = {"titan", "temple", "tytan"},
    ["Angels & Demons"] = {"angel", "demon", "aniol", "diabel"}
}

local currentBiome = "All"
local currentRarity = "Any"

-- Tworzenie GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local BiomeLabel = Instance.new("TextLabel")
local BiomeDropdown = Instance.new("TextButton")
local BiomeListFrame = Instance.new("ScrollingFrame")
local RarityLabel = Instance.new("TextLabel")
local RarityDropdown = Instance.new("TextButton")
local RarityListFrame = Instance.new("ScrollingFrame")
local StealBtn = Instance.new("TextButton")

ScreenGui.Name = guiName
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 280)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "Steal an Egg Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- Wybór Biomu
BiomeLabel.Parent = MainFrame
BiomeLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
BiomeLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
BiomeLabel.BackgroundTransparency = 1
BiomeLabel.Text = "Wybierz Biom:"
BiomeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
BiomeLabel.TextXAlignment = Enum.TextXAlignment.Left

BiomeDropdown.Parent = MainFrame
BiomeDropdown.Position = UDim2.new(0.05, 0, 0.23, 0)
BiomeDropdown.Size = UDim2.new(0.9, 0, 0.12, 0)
BiomeDropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
BiomeDropdown.Text = "All"
BiomeDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)

BiomeListFrame.Parent = MainFrame
BiomeListFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
BiomeListFrame.Size = UDim2.new(0.9, 0, 0.35, 0)
BiomeListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BiomeListFrame.Visible = false
BiomeListFrame.ZIndex = 5

-- Wybór Rzadkości
RarityLabel.Parent = MainFrame
RarityLabel.Position = UDim2.new(0.05, 0, 0.38, 0)
RarityLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
RarityLabel.BackgroundTransparency = 1
RarityLabel.Text = "Wybierz Rzadkość:"
RarityLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
RarityLabel.TextXAlignment = Enum.TextXAlignment.Left

RarityDropdown.Parent = MainFrame
RarityDropdown.Position = UDim2.new(0.05, 0, 0.46, 0)
RarityDropdown.Size = UDim2.new(0.9, 0, 0.12, 0)
RarityDropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RarityDropdown.Text = "Any"
RarityDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)

RarityListFrame.Parent = MainFrame
RarityListFrame.Position = UDim2.new(0.05, 0, 0.58, 0)
RarityListFrame.Size = UDim2.new(0.9, 0, 0.25, 0)
RarityListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
RarityListFrame.Visible = false
RarityListFrame.ZIndex = 5

StealBtn.Parent = MainFrame
StealBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
StealBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
StealBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 60)
StealBtn.Text = "TELEPORTUJ DO JAJKA"
StealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Obsługa listy biomów
local biomesList = {"All", "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", "Abyss", "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple", "Angels & Demons"}
BiomeListFrame.CanvasSize = UDim2.new(0, 0, 0, #biomesList * 25)

for i, bName in ipairs(biomesList) do
    local btn = Instance.new("TextButton")
    btn.Parent = BiomeListFrame
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = bName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.ZIndex = 6
    
    btn.MouseButton1Click:Connect(function()
        currentBiome = bName
        BiomeDropdown.Text = bName
        BiomeListFrame.Visible = false
    end)
end

BiomeDropdown.MouseButton1Click:Connect(function()
    RarityListFrame.Visible = false
    BiomeListFrame.Visible = not BiomeListFrame.Visible
end)

-- Obsługa listy rzadkości
local rarityList = {"Any", "Divine", "Secret", "Eternal"}
RarityListFrame.CanvasSize = UDim2.new(0, 0, 0, #rarityList * 25)

for i, rName in ipairs(rarityList) do
    local btn = Instance.new("TextButton")
    btn.Parent = RarityListFrame
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = rName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.ZIndex = 6
    
    btn.MouseButton1Click:Connect(function()
        currentRarity = rName
        RarityDropdown.Text = rName
        RarityListFrame.Visible = false
    end)
end

RarityDropdown.MouseButton1Click:Connect(function()
    BiomeListFrame.Visible = false
    RarityListFrame.Visible = not RarityListFrame.Visible
end)

-- Logika Filtru i Teleportacji
local function matchesFilter(objName, parentName)
    local nameLower = objName:lower()
    local parentLower = parentName:lower()

    if currentRarity ~= "Any" then
        local rarityLower = currentRarity:lower()
        if not (nameLower:find(rarityLower) or parentLower:find(rarityLower)) then
            return false
        end
    end

    if currentBiome ~= "All" then
        local keywords = BIOME_DATABASE[currentBiome]
        if keywords then
            local matched = false
            for _, kw in ipairs(keywords) do
                if nameLower:find(kw) or parentLower:find(kw) then
                    matched = true
                    break
                end
            end
            if not matched then return false end
        end
    end

    return true
end

StealBtn.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart
    local nearestEgg = nil
    local shortestDistance = math.huge

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local objName = obj.Name
            local parentName = obj.Parent and obj.Parent.Name or ""

            if (objName:lower():find("egg") or parentName:lower():find("egg")) then
                if matchesFilter(objName, parentName) then
                    local dist = (hrp.Position - obj.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        nearestEgg = obj
                    end
                end
            end
        end
    end

    if nearestEgg then
        hrp.CFrame = nearestEgg.CFrame + Vector3.new(0, 3, 0)
    else
        warn("Nie znaleziono pasującego jajka!")
    end
end)
