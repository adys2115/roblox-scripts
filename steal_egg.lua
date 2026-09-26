-- Steal an Egg Complete GUI Script
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Baza danych biomów
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
local BiomeBtn = Instance.new("TextButton")
local RarityBtn = Instance.new("TextButton")
local StealBtn = Instance.new("TextButton")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "StealEggMasterGUI"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "Steal an Egg Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

BiomeBtn.Parent = MainFrame
BiomeBtn.Position = UDim2.new(0.05, 0, 0.22, 0)
BiomeBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
BiomeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
BiomeBtn.Text = "Biom: All"
BiomeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

RarityBtn.Parent = MainFrame
RarityBtn.Position = UDim2.new(0.05, 0, 0.46, 0)
RarityBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
RarityBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RarityBtn.Text = "Rzadkość: Any"
RarityBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

StealBtn.Parent = MainFrame
StealBtn.Position = UDim2.new(0.05, 0, 0.70, 0)
StealBtn.Size = UDim2.new(0.9, 0, 0.24, 0)
StealBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 60)
StealBtn.Text = "TELEPORTUJ DO JAJKA"
StealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Przełączanie Biomów
local biomesList = {"All", "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", "Abyss", "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple", "Angels & Demons"}
local biomeIndex = 1

BiomeBtn.MouseButton1Click:Connect(function()
    biomeIndex = biomeIndex + 1
    if biomeIndex > #biomesList then biomeIndex = 1 end
    currentBiome = biomesList[biomeIndex]
    BiomeBtn.Text = "Biom: " .. currentBiome
end)

-- Przełączanie Rzadkości
local rarityList = {"Any", "Divine", "Secret", "Eternal"}
local rarityIndex = 1

RarityBtn.MouseButton1Click:Connect(function()
    rarityIndex = rarityIndex + 1
    if rarityIndex > #rarityList then rarityIndex = 1 end
    currentRarity = rarityList[rarityIndex]
    RarityBtn.Text = "Rzadkość: " .. currentRarity
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
