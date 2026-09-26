local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local guiName = "StealEggAutoHub_v2"
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(guiName) then
    LocalPlayer.PlayerGui[guiName]:Destroy()
end

local EGG_DATABASE = {
    ["Forest"] = {"Chicken", "Dog", "Bird", "Burrowing Owl", "Raccoon", "Fox", "Bear", "Brr Brr Patapim"},
    ["Lake"] = {"Frog", "Duckling", "Catfish", "Turtle", "Trulimero Trulicina", "Swan", "Axolotl", "Leviathan"},
    ["Desert"] = {"Jerboa", "Fennec", "Camel", "Tob Tobi Tob Tob", "Snake", "Sand Spider", "Scorpion", "Royal Sphinx"},
    ["Jungle"] = {"Chimpanzee", "Toucan", "Crocodile", "Gorilla", "Orangutini Ananassini", "Spider", "Tiger", "King Snake"},
    ["Snow"] = {"Penguin", "Walrus", "Polar Bear", "Sabertooth Tiger", "Mammoth", "King Mammoth", "Yeti", "Ice Dragon"},
    ["Volcano"] = {"Lava Gecko", "Lava Frog", "Flaming Bull", "Lava Iguana", "Chillin Chilli", "Cerberus", "Phoenix", "Lava Dragon"},
    ["Abyss Ocean"] = {"Parrotfish", "Swordfish", "Shark", "Orca", "Whale Shark", "Beluga Whale", "Kraken", "El Maja"},
    ["Prehistoric"] = {"Dodo", "Pterodactyl", "Ankylosaurus", "Triceratops", "Bronto", "T-Rex", "Tralaledon", "Mosasaurus"},
    ["Cosmic"] = {"Centipede", "Cosmic Gecko", "Cosmic Gorilla", "La Vacca Saturno Saturnita", "Cosmic Skeleton Boss", "Cosmic Dragon", "Eternal Lunar Dragon", "Unicorn"},
    ["Cherry Blossom"] = {"Crane", "Salamander", "Red Panda", "Snowy Owl", "Koi", "Stag", "Oni Tiger", "Kitsune"},
    ["Titan Temple"] = {"Spideron", "Crustacia", "Bladehide", "Mantaris", "Rhinotaur", "Mutant Shark", "Gorilla King", "Nightflame"},
    ["Angels & Demons"] = {"Flame Sprite", "Light Dove", "Winged Lamb", "Toro", "Imp", "Sacred Moth", "Holy Peacock", "Demon Hound", "Gargoyle", "Pure Jellyfish", "Centaur", "RazorFang", "Pegasus", "Skeleton Horse", "Equinox", "ArchAngel", "World Burner", "Aetheron"}
}

local currentBiome = "All"
local autoFarmActive = false
local farmInterval = 2.5

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 310, 0, 380)
MainFrame.Position = UDim2.new(0.35, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.Text = "Egg Steal Auto-Farm v2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Parent = MainFrame

local BiomeLabel = Instance.new("TextLabel")
BiomeLabel.Position = UDim2.new(0.05, 0, 0.11, 0)
BiomeLabel.Size = UDim2.new(0.9, 0, 0.05, 0)
BiomeLabel.BackgroundTransparency = 1
BiomeLabel.Text = "Filtruj wg Biomu:"
BiomeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
BiomeLabel.TextXAlignment = Enum.TextXAlignment.Left
BiomeLabel.Parent = MainFrame

local BiomeBtn = Instance.new("TextButton")
BiomeBtn.Position = UDim2.new(0.05, 0, 0.17, 0)
BiomeBtn.Size = UDim2.new(0.9, 0, 0.09, 0)
BiomeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BiomeBtn.Text = "All Biomes (Dowolne Jajko)"
BiomeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BiomeBtn.Parent = MainFrame

local BiomeList = Instance.new("ScrollingFrame")
BiomeList.Position = UDim2.new(0.05, 0, 0.27, 0)
BiomeList.Size = UDim2.new(0.9, 0, 0.4, 0)
BiomeList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BiomeList.Visible = false
BiomeList.ZIndex = 10
BiomeList.Parent = MainFrame

local TPBtn = Instance.new("TextButton")
TPBtn.Position = UDim2.new(0.05, 0, 0.30, 0)
TPBtn.Size = UDim2.new(0.9, 0, 0.13, 0)
TPBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TPBtn.Text = "Teleportuj do Najbliższego Jajka"
TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPBtn.Parent = MainFrame

local AutoBtn = Instance.new("TextButton")
AutoBtn.Position = UDim2.new(0.05, 0, 0.46, 0)
AutoBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
AutoBtn.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
AutoBtn.Text = "AUTO FARM: OFF"
AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBtn.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Oczekiwanie na akcję..."
StatusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
StatusLabel.TextWrapped = true
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.Parent = MainFrame

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
        BiomeBtn.Text = name == "All" and "All Biomes (Dowolne Jajko)" or ("Biom: " .. name)
        BiomeList.Visible = false
    end)
end

BiomeBtn.MouseButton1Click:Connect(function()
    BiomeList.Visible = not BiomeList.Visible
end)

local function getFullText(obj)
    local str = obj.Name
    if obj.Parent then
        str = str .. " " .. obj.Parent.Name
    end
    for _, child in ipairs(obj:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("ProximityPrompt") then
            if child:IsA("TextLabel") then
                str = str .. " " .. child.Text
            elseif child:IsA("ProximityPrompt") then
                str = str .. " " .. child.ObjectText .. " " .. child.ActionText
            end
        end
    end
    return str:lower()
end

local function isTargetEgg(obj)
    local fullText = getFullText(obj)
    
    if not (fullText:find("egg") or obj:FindFirstChildWhichIsA("ProximityPrompt")) then
        return false
    end

    if currentBiome == "All" then
        return true
    end

    local eggList = EGG_DATABASE[currentBiome]
    if eggList then
        for _, eggName in ipairs(eggList) do
            if fullText:find(eggName:lower()) then
                return true
            end
        end
    end

    return false
end

local function executeTeleport()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        StatusLabel.Text = "Błąd: Nie znaleziono postaci gracza."
        return 
    end
    
    local hrp = character.HumanoidRootPart
    local targetPart = nil
    local shortestDist = math.huge
    local totalFound = 0

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            if isTargetEgg(obj) then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if part and not part:IsDescendantOf(character) then
                    totalFound = totalFound + 1
                    local dist = (hrp.Position - part.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        targetPart = part
                    end
                end
            end
        end
    end

    if targetPart then
        hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
        StatusLabel.Text = "Sukces!\nWykryto jajek: " .. totalFound .. "\nPrzeniesiono do: " .. targetPart.Name
    else
        StatusLabel.Text = "Nie znaleziono jajek na mapie odpowiadających filtrowi (" .. currentBiome .. ")."
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

task.spawn(function()
    while true do
        task.wait(farmInterval)
        if autoFarmActive then
            pcall(executeTeleport)
        end
    end
end)
