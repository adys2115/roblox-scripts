local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Czyszczenie starych wersji interfejsu
local guiName = "StealEggAutoHub"
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(guiName) then
    LocalPlayer.PlayerGui[guiName]:Destroy()
end

-- Baza danych zaktualizowana na podstawie podanych obrazów
local EGG_DATABASE = {
    ["Forest"] = {
        Common = {"Chicken Egg", "Dog Egg"},
        Uncommon = {"Bird Egg"},
        Rare = {"Burrowing Owl Egg", "Raccoon Egg"},
        Epic = {"Fox Egg", "Bear Egg"},
        Legendary = {"Brr Brr Patapim Egg"}
    },
    ["Lake"] = {
        Common = {"Frog Egg", "Duckling Egg"},
        Uncommon = {"Catfish Egg"},
        Rare = {"Turtle Egg"},
        Epic = {"Trulimero Trulicina Egg", "Swan Egg"},
        Legendary = {"Axolotl Egg"},
        Cosmic = {"Leviathan Egg"}
    },
    ["Desert"] = {
        Common = {"Jerboa Egg"},
        Uncommon = {"Fennec Egg"},
        Rare = {"Camel Egg"},
        Epic = {"Tob Tobi Tob Tob Egg"},
        Legendary = {"Snake Egg"},
        Mythic = {"Sand Spider Egg", "Scorpion Egg"},
        Cosmic = {"Royal Sphinx Egg"}
    },
    ["Jungle"] = {
        Rare = {"Chimpanzee Egg", "Toucan Egg"},
        Epic = {"Crocodile Egg"},
        Legendary = {"Gorilla Egg", "Orangutini Ananassini Egg"},
        Mythic = {"Spider Egg", "Tiger Egg"},
        Secret = {"King Snake Egg"}
    },
    ["Snow"] = {
        Rare = {"Penguin Egg"},
        Epic = {"Walrus Egg"},
        Legendary = {"Polar Bear Egg"},
        Mythic = {"Sabertooth Tiger Egg", "Mammoth Egg"},
        Cosmic = {"King Mammoth Egg"},
        Secret = {"Yeti Egg"},
        Eternal = {"Ice Dragon Egg"}
    },
    ["Volcano"] = {
        Rare = {"Lava Gecko Egg"},
        Epic = {"Lava Frog Egg"},
        Legendary = {"Flaming Bull Egg", "Lava Iguana Egg"},
        Mythic = {"Chillin Chilli Egg"},
        Secret = {"Cerberus Egg"},
        Eternal = {"Phoenix Egg", "Lava Dragon Egg"}
    },
    ["Abyss Ocean"] = {
        Rare = {"Parrotfish Egg"},
        Epic = {"Swordfish Egg"},
        Legendary = {"Shark Egg"},
        Mythic = {"Orca Egg"},
        Cosmic = {"Whale Shark Egg", "Beluga Whale Egg"},
        Secret = {"Kraken Egg"},
        Eternal = {"El Maja Egg"}
    },
    ["Prehistoric"] = {
        Rare = {"Dodo Egg"},
        Legendary = {"Pterodactyl Egg"},
        Mythic = {"Ankylosaurus Egg"},
        Cosmic = {"Triceratops Egg", "Bronto Egg"},
        Secret = {"T-Rex Egg", "Tralaledon Egg"},
        Eternal = {"Mosasaurus Egg"}
    },
    ["Cosmic"] = {
        Epic = {"Centipede Egg"},
        Legendary = {"Cosmic Gecko Egg"},
        Mythic = {"Cosmic Gorilla Egg"},
        Cosmic = {"La Vacca Saturno Saturnita Egg"},
        Secret = {"Cosmic Skeleton Boss Egg", "Cosmic Dragon Egg"},
        Eternal = {"Eternal Lunar Dragon Egg"},
        Divine = {"Unicorn Egg"}
    },
    ["Cherry Blossom"] = {
        Epic = {"Crane Egg"},
        Legendary = {"Salamander Egg"},
        Mythic = {"Red Panda Egg"},
        Cosmic = {"Snowy Owl Egg", "Koi Egg"},
        Secret = {"Stag Egg"},
        Eternal = {"Oni Tiger Egg"},
        Divine = {"Kitsune Egg"}
    },
    ["Titan Temple"] = {
        Legendary = {"Spideron Egg", "Crustacia Egg"},
        Mythic = {"Bladehide Egg"},
        Cosmic = {"Mantaris Egg", "Rhinotaur Egg"},
        Secret = {"Mutant Shark Egg"},
        Eternal = {"Gorilla King Egg"},
        Divine = {"Nightflame Egg"}
    },
    ["Angels & Demons"] = {
        Legendary = {"Flame Sprite Egg", "Light Dove Egg"},
        Mythic = {"Winged Lamb Egg", "Toro Egg"},
        Cosmic = {"Imp Egg", "Sacred Moth Egg", "Holy Peacock Egg", "Demon Hound Egg"},
        Secret = {"Gargoyle Egg", "Pure Jellyfish Egg", "Centaur Egg", "RazorFang Egg"},
        Eternal = {"Pegasus Egg", "Skeleton Horse Egg", "Equinox Egg"},
        Divine = {"ArchAngel Egg", "World Burner Egg", "Aetheron Egg"}
    }
}

local currentBiome = "All"
local currentRarity = "Any"
local autoFarmActive = false
local farmInterval = 3

-- GUI setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 360)
MainFrame.Position = UDim2.new(0.35, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.Text = "Egg Steal Auto-Farm"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Parent = MainFrame

-- Tworzenie rozwijanego menu dla biomów
local BiomeLabel = Instance.new("TextLabel")
BiomeLabel.Position = UDim2.new(0.05, 0, 0.12, 0)
BiomeLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
BiomeLabel.BackgroundTransparency = 1
BiomeLabel.Text = "Biom:"
BiomeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
BiomeLabel.TextXAlignment = Enum.TextXAlignment.Left
BiomeLabel.Parent = MainFrame

local BiomeBtn = Instance.new("TextButton")
BiomeBtn.Position = UDim2.new(0.05, 0, 0.18, 0)
BiomeBtn.Size = UDim2.new(0.9, 0, 0.09, 0)
BiomeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BiomeBtn.Text = "All"
BiomeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BiomeBtn.Parent = MainFrame

local BiomeList = Instance.new("ScrollingFrame")
BiomeList.Position = UDim2.new(0.05, 0, 0.27, 0)
BiomeList.Size = UDim2.new(0.9, 0, 0.3, 0)
BiomeList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BiomeList.Visible = false
BiomeList.ZIndex = 10
BiomeList.Parent = MainFrame

-- Tworzenie rozwijanego menu dla rzadkości
local RarityLabel = Instance.new("TextLabel")
RarityLabel.Position = UDim2.new(0.05, 0, 0.29, 0)
RarityLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
RarityLabel.BackgroundTransparency = 1
RarityLabel.Text = "Rzadkość:"
RarityLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
RarityLabel.TextXAlignment = Enum.TextXAlignment.Left
RarityLabel.Parent = MainFrame

local RarityBtn = Instance.new("TextButton")
RarityBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
RarityBtn.Size = UDim2.new(0.9, 0, 0.09, 0)
RarityBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
RarityBtn.Text = "Any"
RarityBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RarityBtn.Parent = MainFrame

local RarityList = Instance.new("ScrollingFrame")
RarityList.Position = UDim2.new(0.05, 0, 0.44, 0)
RarityList.Size = UDim2.new(0.9, 0, 0.3, 0)
RarityList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
RarityList.Visible = false
RarityList.ZIndex = 10
RarityList.Parent = MainFrame

-- Przycisk Teleportacji
local TPBtn = Instance.new("TextButton")
TPBtn.Position = UDim2.new(0.05, 0, 0.48, 0)
TPBtn.Size = UDim2.new(0.9, 0, 0.12, 0)
TPBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TPBtn.Text = "Teleportuj Raz"
TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPBtn.Parent = MainFrame

-- Przycisk Auto Farm
local AutoBtn = Instance.new("TextButton")
AutoBtn.Position = UDim2.new(0.05, 0, 0.63, 0)
AutoBtn.Size = UDim2.new(0.9, 0, 0.14, 0)
AutoBtn.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
AutoBtn.Text = "AUTO FARM: OFF"
AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBtn.Parent = MainFrame

-- Status informacji o wykrytych jajkach
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Position = UDim2.new(0.05, 0, 0.80, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0.15, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Skanowanie mapy..."
StatusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

-- Populowanie listy biomów
local biomes = {"All", "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple", "Angels & Demons"}
BiomeList.CanvasSize = UDim2.new(0, 0, 0, #biomes * 25)
for i, name in ipairs(biomes) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 25)
    b.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.ZIndex = 11
    b.Parent = BiomeList
    b.MouseButton1Click:Connect(function()
        currentBiome = name
        BiomeBtn.Text = name
        BiomeList.Visible = false
    end)
end

-- Populowanie listy rzadkości
local rarities = {"Any", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine"}
RarityList.CanvasSize = UDim2.new(0, 0, 0, #rarities * 25)
for i, name in ipairs(rarities) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 25)
    b.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.ZIndex = 11
    b.Parent = RarityList
    b.MouseButton1Click:Connect(function()
        currentRarity = name
        RarityBtn.Text = name
        RarityList.Visible = false
    end)
end

BiomeBtn.MouseButton1Click:Connect(function()
    RarityList.Visible = false
    BiomeList.Visible = not BiomeList.Visible
end)

RarityBtn.MouseButton1Click:Connect(function()
    BiomeList.Visible = false
    RarityList.Visible = not RarityList.Visible
end)

-- Weryfikacja nazwy obiektu względem filtrów
local function isEggMatching(obj)
    local nameLower = obj.Name:lower()
    local parentLower = obj.Parent and obj.Parent.Name:lower() or ""

    if not (nameLower:find("egg") or parentLower:find("egg")) then
        return false
    end

    if currentBiome == "All" and currentRarity == "Any" then
        return true
    end

    for bName, rTable in pairs(EGG_DATABASE) do
        if currentBiome == "All" or currentBiome == bName then
            for rName, eggList in pairs(rTable) do
                if currentRarity == "Any" or currentRarity == rName then
                    for _, eggName in ipairs(eggList) do
                        local target = eggName:lower()
                        if nameLower:find(target) or parentLower:find(target) then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

-- Funkcja wykonywania teleportacji
local function executeTeleport()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local targetEgg = nil
    local shortestDist = math.huge
    local totalFound = 0

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            if isEggMatching(obj) then
                totalFound = totalFound + 1
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local dist = (hrp.Position - part.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        targetEgg = part
                    end
                end
            end
        end
    end

    if targetEgg then
        hrp.CFrame = targetEgg.CFrame + Vector3.new(0, 3, 0)
        StatusLabel.Text = "Wykryto: " .. totalFound .. " jajek. Teleportowano do: " .. targetEgg.Name
    else
        StatusLabel.Text = "Brak jajek pasujących do wybranego filtra na mapie."
    end
end

TPBtn.MouseButton1Click:Connect(executeTeleport)

AutoBtn.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    if autoFarmActive then
        AutoBtn.Text = "AUTO FARM: ON"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 40)
    else
        AutoBtn.Text = "AUTO FARM: OFF"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
    end
end)

-- Pętla Auto Farm
task.spawn(function()
    while true do
        task.wait(farmInterval)
        if autoFarmActive then
            pcall(executeTeleport)
        end
    end
end)
